# Database Migrations

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

Database schema migration patterns for safe, reversible, and zero-downtime deployments.

## Migration Safety Reference

| Migration Type | Safety Level | Approach |
|----------------|--------------|----------|
| Add column (nullable) | Safe | Direct apply |
| Add column (NOT NULL) | Requires planning | Add nullable, backfill, add constraint |
| Drop column | Dangerous | Stop reading first, then drop |
| Rename column | Dangerous | Add new, copy, drop old |
| Add index | Safe | CONCURRENTLY in production |
| Change data type | Dangerous | New column approach |

## Migration File Structure

```
migrations/
  20240301_001_create_users_table.sql
  20240301_002_add_users_email_index.sql
  20240315_001_create_orders_table.sql
  20240401_001_add_users_phone_column.sql
  README.md
```

```sql
-- migrations/20240301_001_create_users_table.sql

-- +migrate Up
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_users_email ON users (email);

-- +migrate Down
DROP TABLE IF EXISTS users CASCADE;
```

Anti-patterns: no down migration defined, missing transaction wrapping, no checksum validation.

## Zero-Downtime Migrations

Use the expand-contract pattern for NOT NULL columns:

```sql
-- DANGEROUS: Adding NOT NULL column directly causes table lock
-- ALTER TABLE orders ADD COLUMN shipping_address_id BIGINT NOT NULL;

-- SAFE: Multi-step approach

-- Step 1: Add nullable column (instant, no lock)
ALTER TABLE orders ADD COLUMN shipping_address_id BIGINT;

-- Step 2: Backfill data in batches (application still running)
UPDATE orders
SET shipping_address_id = (
    SELECT id FROM addresses
    WHERE addresses.user_id = orders.user_id
    AND addresses.is_default = true
    LIMIT 1
)
WHERE shipping_address_id IS NULL
  AND id BETWEEN 1 AND 10000;
-- Repeat for all batches...

-- Step 3: Add NOT NULL constraint after all data populated
ALTER TABLE orders ALTER COLUMN shipping_address_id SET NOT NULL;

-- Step 4: Add foreign key with NOT VALID (fast), validate separately (slow but non-blocking)
ALTER TABLE orders
ADD CONSTRAINT fk_orders_shipping_address
FOREIGN KEY (shipping_address_id) REFERENCES addresses(id) NOT VALID;

ALTER TABLE orders VALIDATE CONSTRAINT fk_orders_shipping_address;
```

## Column Rename (Expand-Contract)

```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN full_name VARCHAR(255);

-- Step 2: Deploy code that writes to both old and new columns
-- Step 3: Backfill new column from old
UPDATE users SET full_name = name WHERE full_name IS NULL;

-- Step 4: Deploy code that reads from new column only
-- Step 5: Drop old column (separate migration after deploy)
ALTER TABLE users DROP COLUMN name;
```

## Adding Indexes Safely

```sql
-- Creates index without blocking writes
CREATE INDEX CONCURRENTLY idx_orders_user_id ON orders (user_id);

-- Check progress
SELECT phase, blocks_done, blocks_total
FROM pg_stat_progress_create_index
WHERE relid = 'orders'::regclass;
```

## Data Migrations

Separate data migrations from schema migrations:

```typescript
// data-migration-runner.ts
async function backfillInBatches(pool: Pool, batchSize = 10000): Promise<void> {
  let processed = 0;
  let hasMore = true;

  while (hasMore) {
    const result = await pool.query(`
      UPDATE orders
      SET new_column = compute(old_column)
      WHERE new_column IS NULL
        AND id IN (
          SELECT id FROM orders
          WHERE new_column IS NULL
          LIMIT $1
          FOR UPDATE SKIP LOCKED
        )
      RETURNING id
    `, [batchSize]);

    processed += result.rowCount;
    hasMore = result.rowCount === batchSize;

    console.log(`Backfilled ${processed} rows`);
    await sleep(100); // Rate-limit to avoid overwhelming DB
  }
}
```

## Rollback Strategy

| Scenario | Rollback Strategy |
|----------|------------------|
| Schema migration failed | Apply down migration |
| Data migration partial | Resume from checkpoint |
| Cannot rollback (data deleted) | Restore from backup |
| Forward-only migration | Blue-green deploy |

## Migration Checklist

- [ ] Both up and down migrations written
- [ ] Tested against production-like data volume
- [ ] No table-level locks expected
- [ ] Indexes created CONCURRENTLY
- [ ] NOT NULL columns added in phases
- [ ] Data migrations use batching
- [ ] Rollback plan documented
- [ ] Backup taken before applying
- [ ] Staging validation complete
