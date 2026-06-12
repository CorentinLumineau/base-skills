# Runbook Templates

Standards for authoring runbooks that are useful during high-stress incidents.

## Runbook Principles

1. **Runbooks are for humans under stress** — write for someone who has never seen this alert
2. **Steps are sequential and verifiable** — each step has a clear completion signal
3. **Commands are copy-paste ready** — no "fill in the right value" without explicit instructions
4. **Kept up to date** — stale runbooks are worse than no runbook (false confidence)

## Standard Runbook Template

```markdown
# Runbook: {Alert or scenario name}

**Alert**: {alert rule name or "manual trigger"}
**Last verified**: {YYYY-MM-DD}
**Owner**: {team or individual}
**Severity**: SEV-{N} typical

---

## When This Fires

{1-2 sentences: what condition triggers this alert and what it means.}

**Do not use this runbook for**:
{Any similar-looking but different scenarios this runbook does not cover}

---

## Impact

- **Users affected**: {who, how many}
- **Features broken**: {which features stop working}
- **Data risk**: {yes/no — describe if yes}

---

## Verify

Before acting, confirm the issue is real and this runbook applies.

```bash
# Example: check error rate
curl -s https://{service}/health | jq .status

# Example: check database connectivity
psql -h {host} -U {user} -c "SELECT 1"
```

Expected output: {what normal looks like}
Abnormal output: {what confirms the issue}

---

## Diagnose

Find the specific cause within the category.

```bash
# Example: check recent logs
kubectl logs -l app={service} --since=5m | grep -i error

# Example: check DB connection pool
SELECT count(*), state FROM pg_stat_activity GROUP BY state;
```

Common causes:
- **{Cause A}**: Identified by {indicator} → go to Step 3a
- **{Cause B}**: Identified by {indicator} → go to Step 3b

---

## Mitigate

Fastest path to restore service, even if not a permanent fix.

### Option A: {Cause A mitigation}

```bash
# Commands to mitigate
kubectl rollout undo deployment/{name}
```

Verify: {command to confirm mitigation worked}

### Option B: {Cause B mitigation}

```bash
# Commands to mitigate
```

---

## Fix (Permanent)

Only after mitigation confirms service is stable.

1. {Step 1}
2. {Step 2}
3. {Step 3}

---

## Verify Resolution

```bash
# Confirm service is healthy
{command}
```

Expected: {what normal looks like}

Also check:
- [ ] Error rate back to baseline on {dashboard link}
- [ ] No new alerts firing
- [ ] {Any other verification}

---

## Escalate If

- Mitigation does not work after {N} minutes
- {Condition that indicates a deeper problem}
- {Condition that requires another team}

Escalate to: {person/team} via {channel/page}

---

## Related

- Runbook: {related runbook name}
- Dashboard: {link}
- Alert rule: {link}
- Post-mortems: {link to past post-mortems for similar issues}
```

## Runbook Quality Checklist

- [ ] "When this fires" section is unambiguous
- [ ] All commands are copy-paste ready with no placeholder guessing
- [ ] Verify step comes before Mitigate step
- [ ] Each mitigation option states how to verify it worked
- [ ] "Escalate if" section has concrete conditions, not "if it gets worse"
- [ ] Last verified date is within 6 months
- [ ] Dashboard links are live and point to the right service

## Quick Reference Runbook (1-page format)

For well-understood, simple failures:

```markdown
# Quick Runbook: {Alert name}

**Symptom**: {What users see or what the alert says}
**Cause**: {Almost always: X}

**Fix**:
```bash
{Single command or 2-3 step sequence}
```

**Verify**: `{command}` returns `{expected output}`

**Escalate if**: {Condition}
```

## Runbook Lifecycle

| Trigger | Action |
|---------|--------|
| New alert created | Write runbook before enabling alert in production |
| Incident occurs with no runbook | Create draft runbook within 48 h as post-mortem action |
| Runbook used during incident | Review for accuracy immediately after incident |
| >6 months since last verification | Re-verify commands and update "Last verified" date |
| Service changes (migration, rename) | Update runbook before or as part of change |

## Anti-Patterns

- **"Check the logs"** with no guidance on what to look for — specify the grep pattern
- **Missing verify steps** — operators follow steps but cannot tell if they worked
- **Runbook assumes context** — always write as if the reader has never seen this service
- **Commands with hardcoded credentials** — use environment variable references instead
- **Branching without decision criteria** — "if X, do Y; else do Z" without explaining how to determine X
