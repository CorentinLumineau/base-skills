# Runbook Templates (SRE)

SRE-specific runbook patterns for alert response and operational procedures.

## Runbook Categories

| Type | Purpose | Trigger |
|------|---------|--------|
| Alert runbook | Step-by-step response to a specific alert | Alert fires |
| Operational procedure | Regular maintenance task | Scheduled |
| Break-glass | Emergency access to restricted systems | SEV-1 / security incident |
| Recovery runbook | Restoring from failure (failover, restore) | Disaster recovery |

## Alert Runbook Template

```markdown
# Runbook: {Alert name}

**Alert rule**: {rule name}
**Severity**: SEV-{N}
**Owner**: {team}
**Last verified**: {YYYY-MM-DD}

---

## When this fires

{Condition: what threshold was crossed and what that means for users.}

**This runbook does NOT cover**: {similar but different scenarios}

---

## User impact

{What users experience when this alert is firing.}
**Data risk**: {yes/no — describe if yes}

---

## Step 1: Verify

Confirm the alert is real (not a flap or false positive):

```bash
{command to verify}
```

Expected (healthy): {output}
Confirmed (problem): {output}

If the service looks healthy → wait 5 minutes and re-check. If resolved, this was a transient spike.

---

## Step 2: Diagnose

Identify the specific cause:

```bash
# Check recent errors
{command}

# Check resource usage
{command}

# Check dependencies
{command}
```

**Common causes**:
| Cause | How to identify | Next step |
|-------|----------------|---------|
| {Cause A} | {indicator} | Go to Step 3a |
| {Cause B} | {indicator} | Go to Step 3b |

---

## Step 3a: Mitigate — {Cause A}

```bash
{mitigation commands}
```

Verify mitigation: `{command}` should return `{expected}`

---

## Step 3b: Mitigate — {Cause B}

```bash
{mitigation commands}
```

---

## Step 4: Verify resolution

```bash
{command to confirm service is healthy}
```

Expected: {output}

Dashboard: {link — confirm metrics returning to baseline}
SLO: {link — confirm error rate recovery}

---

## Step 5: Escalate if

- Mitigation in Step 3a/3b did not resolve within {N minutes}
- Cause does not match any option in Step 2
- Data loss suspected

Escalate to: {team} via {channel / page}

---

## Related

- Dashboard: {link}
- Alert rule source: {link}
- Similar runbook: {link}
- Past post-mortems: {link}
```

## Operational Procedure Template

```markdown
# Procedure: {Task name}

**Type**: Scheduled maintenance
**Frequency**: {daily / weekly / monthly / as-needed}
**Owner**: {team}
**Last updated**: {YYYY-MM-DD}
**Estimated time**: {N minutes}

---

## Prerequisites

- [ ] {Access or tool required}
- [ ] {Condition that must be true before starting}

---

## Steps

1. {Step 1 with exact commands}

```bash
{command}
```

Expected output: {output}

2. {Step 2}

---

## Verify completion

{How to confirm the procedure completed successfully}

---

## Rollback

If the procedure causes issues:
{How to reverse the changes}
```

## Runbook Quality Checklist

- [ ] "When this fires" is unambiguous — no room for interpretation
- [ ] All commands are copy-paste ready
- [ ] Verify step precedes Mitigate step
- [ ] Each mitigation confirms it worked before moving on
- [ ] "Escalate if" has concrete, observable conditions
- [ ] Last verified date is within 6 months
- [ ] Links (dashboard, alert, post-mortems) are live

## Runbook Lifecycle

| Event | Action |
|-------|--------|
| New alert added to production | Write runbook before enabling alert |
| Alert fires without runbook | Write draft within 48 h |
| Runbook used in incident | Review for accuracy, update if steps were wrong |
| 6 months since last verification | Re-verify all commands |
| Service migrated or renamed | Update runbook before or as part of migration |
