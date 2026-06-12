# Caching Patterns Reference

<!-- ported from mercure-plugin/skills/quality-debugging-performance/ -->

Application and HTTP caching strategies for performance optimization.

## Application Caching

### Cache-Aside (Lazy Loading)

```typescript
async function getUser(id: string): Promise<User> {
  const cached = await cache.get(`user:${id}`);
  if (cached) return JSON.parse(cached);
  const user = await db.users.findById(id);
  await cache.set(`user:${id}`, JSON.stringify(user), 'EX', 3600);
  return user;
}
```

### Write-Through

Write to cache and DB together for consistency:

```typescript
async function updateUser(id: string, data: Partial<User>): Promise<User> {
  const user = await db.users.update(id, data);
  await cache.set(`user:${id}`, JSON.stringify(user), 'EX', 3600);
  return user;
}
```

### Write-Behind (Write-Back)

Write to cache first, async flush to DB — higher throughput, risk of data loss:

```typescript
async function incrementPageViews(pageId: string): Promise<void> {
  await cache.incr(`views:${pageId}`);
  // Periodic background flush to DB every 60 seconds
}
```

## Cache Invalidation Strategies

### Time-Based (TTL)

```typescript
await cache.set('dashboard:stats', data, 'EX', 60);     // Volatile: 1 min
await cache.set('config:features', data, 'EX', 3600);   // Stable: 1 hour
```

### Event-Based

```typescript
async function updateProduct(id: string, data: Partial<Product>) {
  await db.products.update(id, data);
  await cache.del(`product:${id}`);
  await cache.del(`products:category:${data.categoryId}`);
}
```

### Tag-Based

```typescript
async function cacheWithTags(key: string, value: any, tags: string[], ttl: number) {
  await cache.set(key, JSON.stringify(value), 'EX', ttl);
  for (const tag of tags) await cache.sadd(`tag:${tag}`, key);
}

async function invalidateTag(tag: string) {
  const keys = await cache.smembers(`tag:${tag}`);
  if (keys.length > 0) await cache.del(...keys);
  await cache.del(`tag:${tag}`);
}
```

## HTTP Caching

```typescript
// Static assets — long cache with content hash
res.set('Cache-Control', 'public, max-age=31536000, immutable');

// API responses — short cache, revalidation
res.set('Cache-Control', 'public, max-age=60, stale-while-revalidate=300');

// Private data — no shared caches
res.set('Cache-Control', 'private, max-age=0, must-revalidate');
```

### ETag Validation

```typescript
const etag = crypto.createHash('md5').update(JSON.stringify(data)).digest('hex');
if (req.headers['if-none-match'] === etag) return res.status(304).end();
res.set('ETag', etag);
res.json(data);
```

## CDN Strategies

| Content Type | Cache Duration | Invalidation |
|-------------|---------------|--------------|
| Static assets (hashed) | 1 year | Deploy new hash |
| HTML pages | 5 min | Purge API |
| API responses | 1-60 sec | TTL expiry |
| User-specific | No CDN cache | `Cache-Control: private` |

## Cache Sizing

| Data Type | Recommended TTL | Eviction |
|-----------|----------------|----------|
| Session data | 24h | TTL |
| API responses | 1-5 min | TTL |
| User profiles | 1h | Event + TTL |
| Config/features | 5-15 min | Event + TTL |

## Common Pitfalls

- **Cache stampede**: Use locking or probabilistic early expiry on miss
- **Stale data**: Always set TTL as safety net even with event invalidation
- **Caching errors**: Never cache error responses
- **Missing cache warming**: Pre-warm critical keys after deploy
