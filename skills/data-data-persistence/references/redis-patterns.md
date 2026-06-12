# Redis Patterns Reference

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

Advanced Redis data structures, distributed patterns, and operational guidance.

## Data Structures Quick Reference

```redis
# Strings
SET key value | GET key | SETEX key seconds value | SETNX key value | INCR counter

# Hashes
HSET user:123 name "John" age 30 | HGET user:123 name | HGETALL user:123

# Lists
LPUSH queue task1 task2 | RPOP queue | LRANGE queue 0 -1

# Sets
SADD tags redis cache | SMEMBERS tags | SINTER tags1 tags2

# Sorted Sets
ZADD leaderboard 100 player1 | ZRANGE leaderboard 0 9 WITHSCORES | ZINCRBY leaderboard 5 player1
```

## Distributed Lock

```typescript
async function acquireLock(lockKey: string, ttl: number = 30000): Promise<string | null> {
  const lockValue = crypto.randomUUID();
  const acquired = await redis.set(lockKey, lockValue, 'NX', 'PX', ttl);
  return acquired ? lockValue : null;
}

async function releaseLock(lockKey: string, lockValue: string): Promise<boolean> {
  // Lua script for atomic check-and-delete (prevents releasing another owner's lock)
  const script = `
    if redis.call("get", KEYS[1]) == ARGV[1] then
      return redis.call("del", KEYS[1])
    else return 0 end
  `;
  return (await redis.eval(script, 1, lockKey, lockValue)) === 1;
}

// Usage
const lockId = await acquireLock('critical-section', 5000);
if (!lockId) throw new Error('Could not acquire lock');
try {
  await doWork();
} finally {
  await releaseLock('critical-section', lockId);
}
```

## Rate Limiter (Sliding Window)

```typescript
async function isRateLimited(key: string, limit: number, windowMs: number): Promise<boolean> {
  const now = Date.now();
  const multi = redis.multi();
  multi.zremrangebyscore(key, 0, now - windowMs);         // Remove old entries
  multi.zcard(key);                                         // Count current
  multi.zadd(key, now, `${now}:${Math.random()}`);         // Add current
  multi.expire(key, Math.ceil(windowMs / 1000));            // Set TTL
  const results = await multi.exec();
  return (results[1][1] as number) >= limit;
}
```

## Session Storage

```typescript
async function createSession(sessionId: string, session: Session, ttl = 86400): Promise<void> {
  await redis.setex(`session:${sessionId}`, ttl, JSON.stringify(session));
}

async function getSession(sessionId: string): Promise<Session | null> {
  const data = await redis.get(`session:${sessionId}`);
  return data ? JSON.parse(data) : null;
}

async function refreshSession(sessionId: string, ttl = 86400): Promise<void> {
  await redis.expire(`session:${sessionId}`, ttl);  // Sliding expiry
}
```

## Pub/Sub

```typescript
// Publisher
await redis.publish('events', JSON.stringify({
  type: 'user.created',
  data: { userId: '123' }
}));

// Subscriber
const subscriber = redis.duplicate();
await subscriber.subscribe('events');
subscriber.on('message', (channel, message) => {
  const event = JSON.parse(message);
  handleEvent(event);
});

// Pattern subscribe (wildcard)
await subscriber.psubscribe('user.*');
subscriber.on('pmessage', (pattern, channel, message) => {
  console.log(`Pattern ${pattern} matched ${channel}`);
});
```

## Leaderboard Pattern (Sorted Sets)

```typescript
// Update score
await redis.zadd('leaderboard:daily', { score: 1500, member: 'player123' });
await redis.zincrby('leaderboard:daily', 50, 'player123');

// Get top 10
const top10 = await redis.zrange('leaderboard:daily', 0, 9, {
  REV: true,
  WITHSCORES: true
});

// Get player rank (0-indexed)
const rank = await redis.zrevrank('leaderboard:daily', 'player123');
```

## Cluster Considerations

```typescript
// Use hash tags to co-locate related keys on the same slot
const userProfileKey = `{user:123}:profile`;
const userOrdersKey = `{user:123}:orders`;
// Keys with same content between {} go to same slot

// Multi-key operations require same-slot keys
await redis.mget(userProfileKey, userOrdersKey);  // OK — same slot

// Avoid cross-slot operations (will fail in cluster)
// await redis.mget('user:123', 'session:abc');  // Different slots!
```

## Eviction Policies

| Policy | Description | Use For |
|--------|-------------|---------|
| volatile-lru | Evict LRU key with TTL | Cache with mix of permanent data |
| allkeys-lru | Evict any LRU key | Pure cache |
| volatile-ttl | Evict key with shortest TTL | Time-sensitive cache |
| noeviction | Return error when full | Critical data, no cache use |

```ini
maxmemory 2gb
maxmemory-policy volatile-lru  # Most common for cache
```

## Monitoring

```bash
redis-cli MONITOR          # Real-time command log (careful in production)
redis-cli SLOWLOG GET 10   # Slow queries
redis-cli MEMORY DOCTOR    # Memory analysis and recommendations
redis-cli CLIENT LIST      # Active client connections
redis-cli INFO stats       # Overall statistics
redis-cli INFO keyspace    # Key counts per database
```

## Common Pitfalls

| Pitfall | Impact | Fix |
|---------|--------|-----|
| No maxmemory set | OOM crash | Always set maxmemory + eviction policy |
| Storing large values (>100KB) | Network overhead | Split or compress |
| Using KEYS * in production | Blocks server | Use SCAN instead |
| No TTL on session keys | Memory leak | Always set EXPIRE |
| Synchronous operations in loop | Latency | Use pipeline or multi |
