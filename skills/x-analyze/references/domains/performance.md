# Performance Domain — Analysis Checks

Look for patterns that cause production performance problems.

## N+1 Query Pattern

**Signs**: A loop that makes a DB or API call per iteration.

```
# N+1 smell:
for item in items:
    db.query("SELECT * FROM details WHERE id = ?", item.id)
```

Severity: HIGH (becomes severe at scale — N calls instead of 1)
Fix direction: batch query before the loop, or use eager loading.

## Memory Leaks

**Signs**:
- Resources opened but no matching close/cleanup (files, connections, streams)
- Growing in-memory collections with no eviction (caches, event listeners, queues)
- Event emitters that attach handlers without detaching

Severity: HIGH for long-running server-side code; MEDIUM for short-lived scripts

## Inefficient Algorithms

**Signs**:
- Nested loops over the same collection (O(n²) where O(n) is possible)
- Linear search (O(n)) where a map/set lookup would give O(1)
- Sort + linear search where a single sorted pass would suffice
- String concatenation in a loop (use join or string builder)

Severity: MEDIUM in general; HIGH if provably in a hot path or handling large datasets

## Missing Caching Opportunities

**Signs**:
- Same expensive computation or query called multiple times with identical inputs
- No caching headers on static or semi-static API responses
- Session or user data fetched from DB on every request without in-memory caching

Severity: MEDIUM

## Reporting

Only flag performance issues that are concrete and evidence-based:
- "This could be slow" → not a finding
- "OrderService.getAll() makes N DB calls inside a loop over orders (line 89)" → finding

Include estimated impact where possible:
- HIGH = affects every request or large-scale processing
- MEDIUM = periodic or conditional impact
