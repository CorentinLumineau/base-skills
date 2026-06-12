---
name: operations-incident-response
description: >
  Use when an incident occurs in production or staging: detecting, triaging, coordinating, and
  resolving outages or degradations. Covers severity classification, on-call escalation,
  communication templates, runbook-driven response, and post-mortem facilitation.
  Do NOT use for routine deployments, capacity planning, or observability setup
  (use operations-sre-operations instead).
license: MIT
compatibility: >
  Always-on knowledge skill. Works with any agent that can read runbooks,
  coordinate communication, or produce post-mortem documents.
metadata:
  type: knowledge
  domain: operations
allowed-tools:
  - Read
  - Write
  - Bash
---

<!-- ported from mercure-plugin/skills/operations-incident-response/ -->

# Incident Response

**triggers**: Production alert fires, user-reported outage, degraded service SLO breach,
on-call page received

## Incident Lifecycle

```
DETECT → TRIAGE → RESPOND → RESOLVE → POST-MORTEM
```

Each phase has clear entry/exit criteria. Never skip phases — skipping triage leads to
mis-scoped response; skipping post-mortem means the same incident recurs.

## Severity Matrix

| Severity | Definition | Response SLA | Examples |
|----------|-----------|-------------|---------|
| SEV-1 | Complete outage or data loss in progress | Immediate (<5 min) | DB down, auth service unreachable, data corruption |
| SEV-2 | Major feature unavailable or >50% of users impacted | <15 min | Checkout broken, API >10% error rate, payments failing |
| SEV-3 | Degraded performance, partial feature unavailable, <50% users impacted | <1 hour | Slow queries, one region degraded, non-critical service down |
| SEV-4 | Minor issue, workaround available | Next business day | Cosmetic bug in production, logging gap, non-critical alert |

**Classification rules**:
- When in doubt, escalate severity (lower number) — easier to downgrade than to under-respond
- Data loss or security incidents default to SEV-1 regardless of scope
- User-reported + no internal alert = at minimum SEV-3

## Phase 1: Detect

Sources: monitoring alerts, customer reports, on-call notification, automated health checks.

**Entry checklist**:
- [ ] Alert acknowledged within SLA
- [ ] Initial symptom captured (what is broken, since when, observed error)
- [ ] Incident channel opened (e.g., `#incident-YYYYMMDD-NNN`)

## Phase 2: Triage

Goal: classify severity and identify blast radius before acting.

**Triage checklist**:
- [ ] Severity assigned (SEV-1..4)
- [ ] Affected systems/services identified
- [ ] User impact estimated (% affected, business impact)
- [ ] Incident commander assigned for SEV-1/SEV-2
- [ ] Relevant runbook located (or noted as missing)

**Decision tree**:
```
Is there data loss or security exposure?     → SEV-1, escalate to security team
Is a core user journey completely broken?    → SEV-1 or SEV-2
Is performance degraded >20% p99 latency?   → SEV-2 or SEV-3
Is a non-critical feature unavailable?       → SEV-3
Everything else                              → SEV-4
```

## Phase 3: Respond

**Roles** (scale to severity):
- **Incident Commander (IC)**: Coordinates, owns timeline, decides escalation (SEV-1/2 only)
- **Tech Lead**: Investigates root cause, applies fixes
- **Comms Lead**: Manages stakeholder/customer communication (SEV-1/2)
- **Scribe**: Keeps timeline in incident channel

**Respond checklist**:
- [ ] Runbook steps executed in order
- [ ] Timeline posted to incident channel every 15 min (SEV-1/2) or 30 min (SEV-3)
- [ ] Rollback evaluated before forward-fix (faster, lower risk)
- [ ] Fix deployed, verified with monitoring
- [ ] All actions documented with timestamps

## Phase 4: Resolve

**Resolution criteria**: All of the following must be true:
- Error rate back to baseline
- Latency SLOs met
- Affected users confirmed restored
- No further alerts firing
- On-call can safely stand down

**Resolve checklist**:
- [ ] Service metrics confirm recovery
- [ ] Customer communications sent (if applicable)
- [ ] Incident channel archived
- [ ] Post-mortem scheduled within 48 h (SEV-1/2) or 5 days (SEV-3)
- [ ] Any temporary mitigations (feature flags, traffic diversion) documented for cleanup

## Phase 5: Post-Mortem

See [references/post-mortem.md](references/post-mortem.md) for full template and facilitation guide.

**Blameless principle**: Post-mortems identify systemic factors, not individual fault. Focus on
"what conditions allowed this to happen" not "who made the mistake."

**Required sections**:
1. Executive summary (3 sentences: what, impact, fix)
2. Timeline (UTC timestamps, key events)
3. Root cause analysis (5-whys or fishbone)
4. Contributing factors
5. Action items (owner, due date, tracking ticket)
6. Detection gap (how long between start and alert)

## Communication Templates

See [references/communication-templates.md](references/communication-templates.md) for:
- Initial incident notification
- Status update (every 15/30 min)
- Resolution notice
- Customer-facing status page copy

### Quick Templates

**Initial notification** (post to incident channel immediately):
```
INCIDENT SEV-{N} | {Short title}
Started: {HH:MM UTC}
Impact: {what is broken, who is affected}
Status: Investigating
IC: @{name}
Runbook: {link or "searching"}
```

**Update**:
```
UPDATE {HH:MM UTC}
Status: {Investigating / Mitigating / Monitoring}
What we know: {1-2 sentences}
Current action: {what we're doing now}
ETA: {estimate or "unknown"}
```

**Resolution**:
```
RESOLVED {HH:MM UTC}
Duration: {N} minutes
Root cause: {1 sentence}
Fix applied: {1 sentence}
Post-mortem: scheduled for {date}
```

## Runbook Structure

See [references/runbook-templates.md](references/runbook-templates.md) for full authoring
standards and examples.

**Minimum viable runbook**:
```markdown
# Runbook: {Alert name}

## When this fires
{What condition triggers this alert}

## Impact
{What is broken, who is affected}

## Steps
1. Verify: {how to confirm the issue}
2. Diagnose: {commands/queries to run}
3. Mitigate: {fastest path to restore service}
4. Fix: {permanent fix steps}
5. Verify resolution: {how to confirm it is fixed}

## Escalate if
{Conditions that require escalation, and to whom}

## Related alerts
{Links to related runbooks/dashboards}
```

## Escalation Paths

| Scenario | Escalate to | How |
|---------|------------|-----|
| Data loss suspected | Security + Engineering lead | Direct page |
| Infrastructure (cloud provider issue) | Platform/infra team | Dedicated channel |
| No runbook found | Most senior on-call | Direct message |
| SEV-1 persists >30 min without progress | Engineering manager | Phone call |
| Customer data potentially exposed | Legal + Security | Immediate verbal + email |

## Anti-Patterns

- **Skipping severity classification**: Every incident gets a severity within 5 minutes
- **Silent debugging**: Post all findings to the incident channel, even dead ends
- **Blame in real-time**: Reserve root cause analysis for post-mortem, not during the incident
- **Hero culture**: One person debugging alone on SEV-1/2
- **Skipping post-mortem for "minor" incidents**: SEV-3+ incidents yield the most actionable learnings
- **Undated action items**: Every action item needs an owner and a due date

## Quality Gate

Before closing an incident:
- [ ] Root cause identified and documented
- [ ] Customer/stakeholder notifications sent
- [ ] Temporary mitigations documented for cleanup
- [ ] Post-mortem scheduled with a facilitator
- [ ] Action items have owners and due dates
