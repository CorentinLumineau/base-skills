# Caching Patterns

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

Detailed caching strategy implementations including cache-aside, invalidation, stampede prevention, and multi-tier caching.

## Strategy Selection

| Pattern | When to Use | Complexity |
|---------|-------------|------------|
| Cache-Aside | Default choice for most scenarios | Low |
| Read-Through | Simple read-heavy workloads | Low |
| Write-Through | Cache must always be consistent | Medium |
| Write-Behind | High write throughput needed | High |

## Cache-Aside (Default)

```typescript
async function getUser(id: string): Promise<User> {
  const cached = await redis.get(`user:${id}`);
  if (cached) return JSON.parse(cached);

  const user = await db.users.findById(id);
  await redis.setex(`user:${id}`, 3600, JSON.stringify(user));
  return user;
}
```

## Cache Invalidation Strategies

| Strategy | Use Case | Trade-off |
|----------|----------|-----------|
| TTL-based | Time-sensitive data | Simple but stale window |
| Event-based | Write-heavy, consistency needed | Complex but fresh |
| Tag-based | Related cache groups | Flexible but overhead |

```typescript
// Event-based invalidation
async function updateUser(id: string, data: UserData) {
  await db.users.update(id, data);
  await redis.del(`user:${id}`);    // Invalidate specific
  await redis.del(`user_list`);     // Invalidate related list
}

// Tag-based invalidation
async function cacheWithTags(key: string, value: any, tags: string[], ttl: number) {
  await redis.set(key, JSON.stringify(value), 'EX', ttl);
  for (const tag of tags) await redis.sadd(`tag:${tag}`, key);
}

async function invalidateTag(tag: string) {
  const keys = await redis.smembers(`tag:${tag}`);
  if (keys.length > 0) await redis.del(...keys);
  await redis.del(`tag:${tag}`);
}
```

## Cache Stampede Prevention

```typescript
// Mutex/Lock pattern
async function getWithLock(key: string) {
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);

  const locked = await redis.set(`lock:${key}`, '1', 'NX', 'EX', 30);
  if (!locked) {
    await sleep(100);
    return getWithLock(key);
  }

  try {
    const data = await fetchFromDB();
    await redis.setex(key, 3600, JSON.stringify(data));
    return data;
  } finally {
    await redis.del(`lock:${key}`);
  }
}

// Probabilistic early expiry (XFetch)
async function getWithProbabilisticRefresh(key: string, ttl: number) {
  const [value, expiry] = await redis.get(key);
  const timeLeft = expiry - Date.now() / 1000;
  const beta = 1.0;

  if (timeLeft - beta * Math.log(Math.random()) < 0) {
    // Probabilistic refresh before expiry
    const data = await fetchFromDB();
    await redis.setex(key, ttl, JSON.stringify(data));
    return data;
  }

  return JSON.parse(value);
}
```

## Cache Key Design

```
{entity}:{id}              -- user:123
{entity}:{qualifier}:{id}  -- user:profile:123
{namespace}:{entity}:{id}  -- app1:user:123
```

| Factor | Recommendation |
|--------|----------------|
| Length | Keep short (<100 chars) |
| Separators | Use `:` consistently |
| Versioning | Include for schema changes |
| Case | Use lowercase |

## Multi-Tier Caching

```
[Request]
    |
[L1: In-Memory] -- Fastest, limited size (~100ms)
    | miss
[L2: Redis]     -- Shared, larger capacity (~1ms)
    | miss
[L3: Database]  -- Source of truth
```

```typescript
class MultiTierCache {
  private l1 = new Map<string, { data: any; expires: number }>();

  async get(key: string): Promise<any> {
    // L1: in-process memory
    const l1Entry = this.l1.get(key);
    if (l1Entry && l1Entry.expires > Date.now()) return l1Entry.data;

    // L2: Redis
    const cached = await redis.get(key);
    if (cached) {
      const data = JSON.parse(cached);
      this.l1.set(key, { data, expires: Date.now() + 30000 }); // 30s L1 TTL
      return data;
    }

    // L3: Database
    const data = await db.query(key);
    await redis.setex(key, 3600, JSON.stringify(data));
    this.l1.set(key, { data, expires: Date.now() + 30000 });
    return data;
  }
}
```

## Key Metrics

| Metric | Target | Action if Off |
|--------|--------|---------------|
| Hit Rate | >80% | Increase TTL, review keys |
| Miss Rate | <20% | Pre-warm cache |
| Latency | <5ms | Check network, payload size |
| Memory | <80% | Review eviction policy |

## Common Pitfalls

- **Cache stampede**: Use locking or probabilistic early expiry on mass expiry
- **Stale data**: Always set TTL as safety net even with event invalidation
- **Caching errors**: Never cache error responses
- **Missing cache warming**: Pre-warm critical keys after deploy
- **No eviction policy**: Set maxmemory-policy (volatile-lru for most cases)
