# Audit Trail Patterns

Patterns for implementing immutable, searchable audit trails.

## Audit Event Design

### What to Audit

| Category | Events to log |
|----------|--------------|
| Authentication | Login success/failure, MFA use, password change, token issue |
| Authorization | Permission grants/revocations, role changes, access denied |
| Data access | Read/export of sensitive data (not every query — PII/PHI/PCI fields) |
| Data modification | Create, update, delete of records (especially irreversible changes) |
| Administration | User creation/deletion, config changes, settings updates |
| Security | Suspicious activity, policy violations, failed bulk operations |

### What NOT to Audit

- Every SELECT query on non-sensitive data (noise, performance cost)
- Health check endpoint calls
- Static asset requests
- Internal system heartbeats

### Event Naming Convention

```
{resource}.{action}

Examples:
user.create          user.delete          user.login
user.login.failed    user.mfa.enable      user.role.assign
document.view        document.export      document.delete
config.update        api_key.create       api_key.revoke
```

## Audit Log Schema

```typescript
interface AuditEvent {
  // Required fields
  timestamp: string;       // ISO 8601 UTC, e.g. "2024-01-15T10:23:11.456Z"
  event_id: string;        // UUID v4 — unique per event
  event_type: string;      // e.g. "user.role.assign"

  actor: {
    id: string;            // "user:12345" or "service:payment-api"
    type: "user" | "service" | "system";
    email?: string;        // for user actors
    ip_address?: string;   // for user actions from HTTP requests
    user_agent?: string;   // for web clients
  };

  resource: {
    id: string;            // ID of the affected resource
    type: string;          // e.g. "user", "document", "payment"
    name?: string;         // human-readable name
  };

  outcome: "success" | "failure";
  error?: string;          // if outcome is failure

  request_id?: string;     // correlation ID from the HTTP request
  session_id?: string;     // session identifier

  // Conditional fields
  before?: Record<string, unknown>;   // state before the change
  after?: Record<string, unknown>;    // state after the change
  reason?: string;                    // justification for privileged actions

  // Metadata
  service: string;         // name of the service emitting the event
  environment: string;     // "production" | "staging"
}
```

## Implementation Patterns

### Pattern 1: Database Audit Table

Simple approach: dedicated `audit_log` table that only allows INSERT.

```sql
CREATE TABLE audit_log (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  event_type  TEXT        NOT NULL,
  actor_id    TEXT        NOT NULL,
  actor_type  TEXT        NOT NULL,
  actor_email TEXT,
  actor_ip    INET,
  resource_id TEXT        NOT NULL,
  resource_type TEXT      NOT NULL,
  outcome     TEXT        NOT NULL CHECK (outcome IN ('success', 'failure')),
  request_id  TEXT,
  before_state JSONB,
  after_state JSONB,
  reason      TEXT,
  service     TEXT        NOT NULL,
  raw_event   JSONB       NOT NULL
);

-- Append-only: revoke DELETE and UPDATE
REVOKE UPDATE, DELETE, TRUNCATE ON audit_log FROM app_role;

-- Index for common query patterns
CREATE INDEX idx_audit_actor    ON audit_log(actor_id, timestamp DESC);
CREATE INDEX idx_audit_resource ON audit_log(resource_id, timestamp DESC);
CREATE INDEX idx_audit_type     ON audit_log(event_type, timestamp DESC);
```

### Pattern 2: Dedicated Audit Service

For higher compliance requirements, separate audit log from application data:

```typescript
// Audit client library
class AuditLogger {
  async log(event: AuditEvent): Promise<void> {
    await this.auditService.emit(event);  // fire-and-forget
    // Never await in request path — audit failure must not affect user action
  }

  async logOrFail(event: AuditEvent): Promise<void> {
    await this.auditService.emitOrThrow(event);  // for cases where audit is mandatory
  }
}

// Usage
await auditLogger.log({
  event_type: "user.role.assign",
  actor: { id: `user:${ctx.userId}`, type: "user", email: ctx.email },
  resource: { id: `user:${targetUserId}`, type: "user" },
  outcome: "success",
  before: { role: "viewer" },
  after: { role: "admin" },
  reason: ticketRef,
  ...baseFields
});
```

### Pattern 3: Append-Only Object Storage (S3 / GCS)

For very high retention requirements or compliance mandates:

```bash
# Write audit events as NDJSON to S3 with WORM (Object Lock)
event=$(jq -c '.' <<< "$AUDIT_EVENT_JSON")
aws s3 cp - "s3://${AUDIT_BUCKET}/logs/${DATE}/${REQUEST_ID}.ndjson" \
  --object-lock-mode COMPLIANCE \
  --object-lock-retain-until-date "$(date -d '+7 years' --utc +%Y-%m-%dT%H:%M:%SZ)"
  <<< "$event"
```

## Integrity Verification

Prevent tampering by chaining event hashes:

```typescript
function computeEventHash(event: AuditEvent, previousHash: string): string {
  const content = JSON.stringify(event) + previousHash;
  return crypto.createHash('sha256').update(content).digest('hex');
}

// Verify chain integrity
async function verifyChain(events: (AuditEvent & { hash: string; prev_hash: string })[]) {
  for (let i = 1; i < events.length; i++) {
    const expected = computeEventHash(events[i], events[i-1].hash);
    if (expected !== events[i].hash) {
      throw new Error(`Chain broken at event ${events[i].event_id}`);
    }
  }
}
```

## Querying Audit Logs

### Common Query Patterns

```sql
-- All actions by a user in the last 30 days
SELECT * FROM audit_log
WHERE actor_id = 'user:12345'
  AND timestamp > NOW() - INTERVAL '30 days'
ORDER BY timestamp DESC;

-- All role changes (for access review)
SELECT timestamp, actor_email, resource_id, before_state, after_state
FROM audit_log
WHERE event_type = 'user.role.assign'
  AND timestamp BETWEEN :start AND :end
ORDER BY timestamp;

-- Failed login attempts (security investigation)
SELECT timestamp, actor_ip, actor_email
FROM audit_log
WHERE event_type = 'user.login.failed'
  AND actor_ip = :suspicious_ip
ORDER BY timestamp;

-- Exports of sensitive documents (data breach investigation)
SELECT timestamp, actor_email, resource_id
FROM audit_log
WHERE event_type IN ('document.export', 'document.bulk_export')
  AND timestamp BETWEEN :incident_start AND :incident_end;
```

## Retention and Archival

| Framework | Minimum retention | Immediately available | Archived |
|-----------|------------------|----------------------|---------|
| SOC 2 | 1 year | 3 months | 9 months |
| PCI-DSS | 1 year | 3 months | 9 months |
| GDPR | Duration of processing + legal hold | N/A | Per legal requirement |
| HIPAA | 6 years from creation | 1 year | 5 years |

```bash
# Archive logs older than 90 days to cold storage
aws s3 sync s3://{hot-bucket}/logs/ s3://{cold-bucket}/archive/ \
  --exclude "*" \
  --include "*/$(date -d '90 days ago' +%Y-%m-*)/*" \
  --storage-class GLACIER
```
