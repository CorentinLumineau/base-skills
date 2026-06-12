# Database Tuning

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

Database performance optimization patterns covering query analysis, resource configuration, and monitoring. Focus on PostgreSQL with applicable patterns for other relational databases.

## Quick Reference

| Tuning Area | Key Parameter | Impact |
|-------------|---------------|--------|
| Memory | shared_buffers = 25% RAM | Buffer cache efficiency |
| Memory | effective_cache_size = 75% RAM | Query planner decisions |
| Work Memory | work_mem = RAM / (2 * max_connections) | Sort/hash operations |
| Connections | max_connections = reasonable limit | Memory overhead |
| Checkpoints | checkpoint_completion_target = 0.9 | I/O smoothing |
| WAL | wal_buffers = 64MB | Write throughput |

## Memory Configuration

```ini
# postgresql.conf for 32GB RAM dedicated server
shared_buffers = 8GB           # 25% of RAM
effective_cache_size = 24GB    # 75% of RAM (planner hint)
work_mem = 256MB               # Per sort/hash/join; be conservative
maintenance_work_mem = 2GB     # VACUUM, CREATE INDEX
huge_pages = try               # Reduce TLB pressure for large shared_buffers
max_connections = 200          # Use pgBouncer for more
bgwriter_delay = 200ms         # Background writer spreading
```

Formula for work_mem: `(RAM - shared_buffers) / (max_connections * 3)`

Anti-patterns: shared_buffers > 40% RAM (diminishing returns), very high work_mem with many connections (OOM risk), not setting effective_cache_size (bad query plans).

## Checkpoint Tuning

```ini
checkpoint_completion_target = 0.9    # Spread checkpoint writes
wal_buffers = 64MB                    # WAL write buffer
min_wal_size = 1GB
max_wal_size = 4GB
```

Higher checkpoint_completion_target spreads I/O more evenly; lower causes I/O spikes.

## Autovacuum Tuning

```ini
# More aggressive autovacuum for high-churn tables
autovacuum_vacuum_scale_factor = 0.05       # 5% dead tuples triggers vacuum (default 20%)
autovacuum_analyze_scale_factor = 0.02      # 2% changes triggers analyze (default 10%)
autovacuum_vacuum_cost_delay = 2ms          # Speed up vacuuming
autovacuum_max_workers = 5                  # More workers for busy databases
```

Per-table override for critical tables:
```sql
ALTER TABLE orders SET (
    autovacuum_vacuum_scale_factor = 0.01,
    autovacuum_analyze_scale_factor = 0.005
);
```

## Query Plan Analysis

```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, o.total FROM orders o
WHERE o.status = 'pending' AND o.created_at > NOW() - INTERVAL '24 hours';

-- Key signals:
-- Seq Scan on large table  -> missing index
-- Rows estimated vs actual > 10x -> stale statistics, run ANALYZE
-- Shared Read Blocks high  -> low cache hit, data not in memory
-- Sort on disk (spill)     -> work_mem too low
-- Nested Loop + large scan -> missing index, consider Hash Join
```

## Monitoring Queries

```sql
-- Slow queries (requires pg_stat_statements extension)
SELECT query, mean_exec_time, calls, total_exec_time
FROM pg_stat_statements
WHERE mean_exec_time > 100  -- >100ms average
ORDER BY total_exec_time DESC
LIMIT 20;

-- Table bloat (dead tuples needing VACUUM)
SELECT relname, n_dead_tup, n_live_tup,
       ROUND(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 1) AS dead_pct
FROM pg_stat_user_tables
WHERE n_dead_tup > 10000
ORDER BY dead_tup DESC;

-- Cache hit ratio (target > 99%)
SELECT
    sum(heap_blks_hit) AS cache_hits,
    sum(heap_blks_read) AS disk_reads,
    ROUND(100.0 * sum(heap_blks_hit) / NULLIF(sum(heap_blks_hit) + sum(heap_blks_read), 0), 2) AS cache_hit_ratio
FROM pg_statio_user_tables;

-- Connection usage
SELECT count(*), state, wait_event_type, wait_event
FROM pg_stat_activity
WHERE datname = current_database()
GROUP BY state, wait_event_type, wait_event;

-- Lock waits
SELECT pid, query, pg_blocking_pids(pid) AS blocking_pids
FROM pg_stat_activity
WHERE cardinality(pg_blocking_pids(pid)) > 0;
```

## Index Maintenance

```sql
-- Find index bloat
SELECT relname AS table, indexrelname AS index,
       pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_stat_user_indexes
WHERE pg_relation_size(indexrelid) > 100 * 1024 * 1024  -- >100MB
ORDER BY pg_relation_size(indexrelid) DESC;

-- Rebuild bloated index
REINDEX INDEX CONCURRENTLY idx_orders_user_id;
```

## Performance Optimization Checklist

- [ ] shared_buffers = 25% of available RAM
- [ ] effective_cache_size = 75% of available RAM
- [ ] work_mem calculated from max_connections
- [ ] autovacuum tuned for table churn rates
- [ ] pg_stat_statements enabled for query profiling
- [ ] Cache hit ratio > 99% (check with monitoring query)
- [ ] No tables with dead_pct > 10%
- [ ] Slow query log reviewed weekly
- [ ] Index bloat checked monthly
