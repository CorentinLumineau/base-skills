---
name: data-data-persistence
description: >
  Use when designing database schemas, implementing caching, or optimizing data
  storage. Covers relational design, NoSQL patterns, caching strategies, and
  storage optimization. Do NOT use for message queue patterns (use data-messaging)
  or application-level caching debug (use quality-debugging-performance).
license: MIT
compatibility: always-on
allowed-tools: Read Grep Glob
metadata:
  type: knowledge
---

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

# Data Persistence

Unified data storage patterns covering relational databases, NoSQL, and caching strategies.

## 80/20 Focus

| Area | Key Practice | Impact |
|------|-------------|--------|
| SQL vs NoSQL | Choose based on access patterns and consistency needs | Foundational architecture decision |
| Schema design | Normalize for SQL, denormalize for NoSQL | Query performance and data integrity |
| Indexing | Index filtered/joined columns, use EXPLAIN | 10-100x query speedup |
| Caching | Cache-aside with TTL as default strategy | Reduces DB load by 80%+ |
| Connection pooling | Use pgBouncer or built-in pools | 10x connection efficiency |

## SQL vs NoSQL Decision Framework

```
Need complex JOINs?           --> SQL
Need ACID transactions?       --> SQL
Need ad-hoc queries?          --> SQL
Need horizontal scaling?      --> NoSQL
Schema changes frequently?    --> NoSQL
Read pattern is key-based?    --> NoSQL
Need high write throughput?   --> NoSQL
```

| Criteria | Choose SQL | Choose NoSQL |
|----------|-----------|--------------|
| Data model | Relational, normalized | Document, key-value, wide-column |
| Consistency | Strong (ACID) | Eventual (BASE), tunable |
| Scaling | Vertical (read replicas) | Horizontal (sharding) |
| Schema | Fixed, enforced | Flexible, schema-on-read |
| Query | Complex JOINs, aggregations | Key-based lookups, document queries |
| Examples | PostgreSQL, MySQL | MongoDB, DynamoDB, Redis |

## Relational Database Patterns

### Schema Design Principles

| Principle | Description |
|-----------|-------------|
| Normalization | Reduce redundancy (3NF baseline) |
| Appropriate types | Use correct data types for columns |
| Constraints | Enforce data integrity with FKs and checks |
| Indexes | Optimize common query patterns |

### Common Relationships

```sql
-- One-to-Many
CREATE TABLE users (id SERIAL PRIMARY KEY);
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id)
);

-- Many-to-Many
CREATE TABLE user_roles (
  user_id INT REFERENCES users(id),
  role_id INT REFERENCES roles(id),
  PRIMARY KEY (user_id, role_id)
);
```

### Index Strategy

| Query Pattern | Index Type |
|---------------|------------|
| Equality (=) | B-tree (default) |
| Range (<, >) | B-tree |
| Full text search | GIN or GiST |
| JSON fields | GIN |
| Time-series | BRIN |

When to index: Foreign keys, frequently filtered columns, ORDER BY columns, JOIN columns.

When NOT to index: Low cardinality columns (booleans), rarely queried columns, small tables.

### Migration Best Practices

| Practice | Why |
|----------|-----|
| Small migrations | Easy to review and rollback |
| Forward-only | Avoid data loss |
| Test in staging | Catch issues early |
| Backup before deploy | Safety net |
| Use CONCURRENTLY for indexes | Avoid table locks |

### Query Optimization

| Issue | Solution |
|-------|----------|
| N+1 queries | Use JOINs or batch loading |
| Missing index | Add index on filtered columns |
| Large scans | Add WHERE clauses, use pagination |
| SELECT * | Select only needed columns |
| Deep OFFSET | Use keyset (cursor) pagination |

```sql
-- Always analyze before optimizing
EXPLAIN (ANALYZE, BUFFERS) SELECT ...
```

### Connection Management

| Practice | Implementation |
|----------|----------------|
| Connection pooling | pgBouncer, built-in pools |
| Timeouts | Statement and connection timeouts |
| Max connections | Based on workload + pooler |
| Pool mode | Transaction mode for web apps |

## Quick Reference

| Task | Approach |
|------|----------|
| New project DB choice | Use SQL vs NoSQL decision framework |
| Slow queries | EXPLAIN ANALYZE, add indexes |
| High DB load | Add caching layer (cache-aside + TTL) |
| Schema evolution (SQL) | Small forward-only migrations |
| Schema evolution (NoSQL) | Schema versioning field |
| Connection issues | Connection pooling (pgBouncer) |
| Data consistency | SQL for ACID, event-based invalidation for cache |
| Horizontal scaling | NoSQL (MongoDB sharding, DynamoDB) |

## Checklist

### Database Design
- [ ] SQL vs NoSQL decision documented
- [ ] Schema normalized appropriately (SQL) or access-pattern-driven (NoSQL)
- [ ] Indexes on filtered/joined columns
- [ ] Foreign keys with constraints (SQL)

### Performance
- [ ] Connection pooling configured
- [ ] Queries analyzed with EXPLAIN
- [ ] Caching strategy selected and implemented
- [ ] TTL defined for all cached data
- [ ] Cache stampede prevention in place

### Operations
- [ ] Migrations tested in staging
- [ ] Backups verified and scheduled
- [ ] Monitoring configured (query stats, cache hit ratio)
- [ ] Fallback for cache failure defined

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting schema design findings with table/collection name, specific issue, and recommended fix (e.g., "users table: missing index on email column used in WHERE clause")
- Using severity model: CRITICAL = BLOCK (missing migration safety, data loss risk), HIGH = WARN (N+1 queries, missing indexes on hot paths), MEDIUM = INFO (denormalization opportunity, cache strategy gap)
- Providing migration safety assessments for schema changes (backward compatibility, lock risk, rollback plan)
- Including query optimization recommendations with EXPLAIN output interpretation where applicable

## When to Load References

- **For PostgreSQL specifics**: See `references/postgresql.md`
- **For migration patterns**: See `references/migrations.md`
- **For performance tuning**: See `references/tuning.md`
- **For NoSQL modeling (MongoDB, DynamoDB)**: See `references/nosql-patterns.md`
- **For caching patterns**: See `references/caching-patterns.md`
- **For MongoDB patterns**: See `references/mongodb-patterns.md`
- **For Redis patterns**: See `references/redis-patterns.md`
