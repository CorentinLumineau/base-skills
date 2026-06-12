# PostgreSQL

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

PostgreSQL configuration, query optimization, and operational patterns for production workloads.

## Quick Reference

| Aspect | Key Practice | Impact |
|--------|--------------|--------|
| Connections | Use pgBouncer pooling | 10x connection efficiency |
| Indexing | Composite indexes, INCLUDE columns | 100x query speedup |
| JSON | JSONB with GIN indexes | Flexible schema + performance |
| Partitioning | Range partition large tables | Manageable table sizes |
| Replication | Streaming + logical for read replicas | High availability |

## Connection Pooling (pgBouncer)

```ini
# pgbouncer.ini
[databases]
myapp = host=postgres.internal port=5432 dbname=production

[pgbouncer]
pool_mode = transaction  # Best for web apps
default_pool_size = 20
min_pool_size = 5
max_client_conn = 1000
max_db_connections = 100
server_idle_timeout = 60
query_timeout = 30
```

```typescript
const pool = new Pool({
  host: process.env.PGBOUNCER_HOST,
  port: 6432,
  max: 10,  // pgBouncer handles actual pooling
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
  statement_timeout: 30000,
  application_name: 'myapp-api',
});
```

Anti-patterns: Opening new connection per request, session pool mode with prepared statements, not setting statement timeouts.

## Indexing Strategies

```sql
-- Composite index for multi-column WHERE + ORDER BY
CREATE INDEX CONCURRENTLY idx_orders_user_status_created
ON orders (user_id, status, created_at DESC);

-- Covering index (INCLUDE) to avoid table lookup
CREATE INDEX CONCURRENTLY idx_orders_user_completed_covering
ON orders (user_id)
INCLUDE (id, total, created_at)
WHERE status = 'completed';

-- Partial index for common filter
CREATE INDEX CONCURRENTLY idx_orders_pending_recent
ON orders (created_at DESC)
WHERE status = 'pending';

-- GIN index for JSONB containment
CREATE INDEX CONCURRENTLY idx_events_metadata
ON events USING GIN (metadata jsonb_path_ops);

-- Expression index for case-insensitive search
CREATE INDEX CONCURRENTLY idx_users_email_lower
ON users (LOWER(email));

-- BRIN index for time-series (much smaller than B-tree)
CREATE INDEX CONCURRENTLY idx_logs_created_brin
ON logs USING BRIN (created_at);
```

```sql
-- Find unused indexes (removal candidates)
SELECT relname AS table, indexrelname AS index,
       pg_size_pretty(pg_relation_size(i.indexrelid)) AS size, idx_scan AS scans
FROM pg_stat_user_indexes ui
JOIN pg_index i ON ui.indexrelid = i.indexrelid
WHERE idx_scan < 50 AND NOT indisunique AND NOT indisprimary
ORDER BY pg_relation_size(i.indexrelid) DESC;

-- Find tables needing indexes (high seq scans)
SELECT relname AS table, seq_scan, idx_scan,
       seq_tup_read / GREATEST(seq_scan, 1) AS avg_rows_per_seq_scan
FROM pg_stat_user_tables
WHERE seq_scan > 100 AND seq_tup_read / GREATEST(seq_scan, 1) > 1000
ORDER BY seq_tup_read DESC;
```

Anti-patterns: Index on every column, missing composite indexes for multi-column WHERE, not using CONCURRENTLY.

## JSONB Operations

```sql
CREATE TABLE events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    payload JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_events_type ON events (event_type);
CREATE INDEX idx_events_payload ON events USING GIN (payload jsonb_path_ops);

-- Queries
SELECT * FROM events WHERE payload @> '{"user_id": "123"}';
SELECT payload->>'user_id' AS user_id FROM events;
SELECT * FROM events WHERE payload ? 'transaction_id';

-- Update JSONB
UPDATE events SET payload = payload || '{"processed": true}' WHERE id = 123;
UPDATE events SET payload = payload - 'temp_field' WHERE id = 123;
```

## Query Analysis

```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, o.total, u.email
FROM orders o
JOIN users u ON u.id = o.user_id
WHERE o.status = 'pending'
  AND o.created_at > NOW() - INTERVAL '24 hours'
ORDER BY o.created_at DESC
LIMIT 100;

-- Interpretation:
-- Seq Scan: Full table scan (bad for large tables)
-- Index Scan: Using index (good)
-- Index Only Scan: All data from index (best)
-- Buffers: shared hit (cache) vs read (disk)
-- Rows estimated vs actual: stale stats if wildly off, run ANALYZE
```

## Memory Configuration

```ini
# postgresql.conf for 32GB RAM server
shared_buffers = 8GB           # 25% of RAM
effective_cache_size = 24GB    # 75% of RAM
work_mem = 256MB               # Per sort/hash operation
maintenance_work_mem = 2GB     # For VACUUM, CREATE INDEX
max_connections = 200          # Use pgBouncer for more
```

## Checkpoint Tuning

```ini
# Spread checkpoints to smooth I/O
checkpoint_completion_target = 0.9
wal_buffers = 64MB
min_wal_size = 1GB
max_wal_size = 4GB
```

## Monitoring Queries

```sql
-- Slow queries
SELECT query, mean_exec_time, calls, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Table bloat
SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) AS size,
       n_dead_tup, n_live_tup
FROM pg_stat_user_tables
WHERE n_dead_tup > 10000
ORDER BY n_dead_tup DESC;

-- Cache hit ratio (target > 99%)
SELECT sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) AS cache_hit_ratio
FROM pg_statio_user_tables;
```

## High Availability

```yaml
# Streaming replication (postgresql.conf on primary)
wal_level = replica
max_wal_senders = 10
wal_keep_size = 1GB
synchronous_commit = on

# Recovery configuration (on replica)
primary_conninfo = 'host=primary port=5432 user=replication password=secret'
hot_standby = on
```
