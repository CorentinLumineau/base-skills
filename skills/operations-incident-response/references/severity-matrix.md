# Severity Matrix

Reference for classifying incident severity and applying the correct response protocol.

## Severity Levels

| Level | Name | Description | Response SLA | On-call Escalation |
|-------|------|-------------|-------------|-------------------|
| SEV-1 | Critical | Complete service outage or data loss in progress | Acknowledge <5 min, IC on bridge <15 min | Immediate page to on-call + engineering lead |
| SEV-2 | Major | Core feature broken, >50% user impact, payment failures | Acknowledge <15 min, working <30 min | Page on-call, notify manager |
| SEV-3 | Minor | Degraded performance, partial feature loss, <50% impact | Acknowledge <1 hour, working <2 hours | Notify on-call via channel |
| SEV-4 | Low | Non-critical issue, workaround available | Next business day | Ticket in backlog |

## Classification Decision Tree

```
Step 1: Is there active data loss or security breach?
  YES → SEV-1 (automatic, no discussion)
  NO  → Continue

Step 2: Is a primary user journey completely unavailable?
  YES → SEV-1 if >75% users, SEV-2 if <75% users
  NO  → Continue

Step 3: Is error rate >5% on any production service?
  YES → SEV-2
  NO  → Continue

Step 4: Is p99 latency >3x baseline?
  YES → SEV-2 (if core service) or SEV-3 (if secondary service)
  NO  → Continue

Step 5: Is any feature partially degraded?
  YES → SEV-3
  NO  → SEV-4
```

## Response Time SLAs

| Severity | Acknowledge | Incident Channel | First Update | Post-mortem |
|----------|-------------|-----------------|-------------|-------------|
| SEV-1 | 5 min | Immediate | 15 min | 48 hours |
| SEV-2 | 15 min | Within 30 min | 30 min | 48 hours |
| SEV-3 | 1 hour | Within 2 hours | 2 hours | 5 business days |
| SEV-4 | Next business day | Optional | N/A | Optional |

## Communication Requirements

| Severity | Stakeholders | Customer Notice | Status Page |
|----------|-------------|----------------|-------------|
| SEV-1 | Engineering + Product + Exec | Required within 30 min | Update immediately |
| SEV-2 | Engineering + Product | Required within 1 hour | Update within 30 min |
| SEV-3 | Engineering team | If user-visible | Update if user-facing |
| SEV-4 | Engineering team | No | No |

## Special Classification Rules

### Auto-escalate to SEV-1
- Any confirmed data loss (even small scope)
- Security breach or unauthorized access
- PII exposure
- Compliance-regulated service outage (payment processor, auth, data storage)

### Downgrade from SEV-1 to SEV-2
Allowed only when IC confirms:
- No data loss
- Impact contained to <50% of users
- Mitigation already in place

Document the downgrade in the incident channel with rationale.

## Severity vs. Priority

Severity (this matrix) = technical impact scope.
Priority = business criticality of the fix.

A SEV-3 issue during Black Friday checkout may have Priority 1. A SEV-1 in a demo environment
may have lower business priority. Severity drives response speed; priority drives fix order.
