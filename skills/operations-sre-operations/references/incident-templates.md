# Incident Templates

Templates for SRE-specific incident documentation and post-incident reviews.

## Incident Declaration Template

```markdown
## Incident: {short title}

**ID**: INC-{YYYYMMDD}-{NNN}
**Severity**: SEV-{1|2|3|4}
**Declared**: {YYYY-MM-DD HH:MM UTC}
**Resolved**: {YYYY-MM-DD HH:MM UTC | OPEN}
**Duration**: {N hours N minutes | ONGOING}

**Incident Commander**: @{name}
**Tech Lead**: @{name}
**Comms Lead**: @{name} (SEV-1/2 only)

### Impact
- Users affected: {N users or % of traffic}
- Features affected: {list}
- SLO impact: {% of error budget consumed}
- Revenue impact: {estimate or "not calculated"}

### Summary
{3 sentences: what failed, user impact, how resolved}
```

## SRE Incident Review Checklist

Use this during or immediately after an incident to ensure completeness.

### Detection
- [ ] How was the incident detected? (alert / customer / manual)
- [ ] What was the time between symptom start and detection?
- [ ] Was the alert actionable? Did the runbook help?

### Response
- [ ] Was the correct severity assigned promptly?
- [ ] Were the right people notified?
- [ ] Was the runbook followed? Any steps missing or wrong?
- [ ] Were customer communications sent on time?

### Resolution
- [ ] Was the root cause identified before closing?
- [ ] Was rollback evaluated before forward-fix?
- [ ] Are all temporary mitigations documented for cleanup?

### Follow-up
- [ ] Post-mortem scheduled?
- [ ] Action items have owners and due dates?
- [ ] SLO and error budget impact calculated?

## SRE Post-Incident Review Template

Lighter-weight alternative to full post-mortem for SEV-3 incidents:

```markdown
## Post-Incident Review: {title}

**Date**: {YYYY-MM-DD}
**Severity**: SEV-3
**Duration**: {N min}
**Reviewer**: @{name}

### What happened
{2-3 sentences}

### Timeline
| Time (UTC) | Event |
|------------|-------|
| HH:MM | Alert fired |
| HH:MM | Investigation started |
| HH:MM | Root cause identified |
| HH:MM | Fix applied |
| HH:MM | Resolved |

### Root cause
{1-2 sentences}

### What we will change
| Action | Owner | Due |
|--------|-------|-----|
| {specific action} | @{name} | {YYYY-MM-DD} |
```

## Error Budget Impact Report

Generate after every SEV-1/2 incident:

```markdown
## Error Budget Impact — {Service} — {incident ID}

**SLO target**: {99.9%}
**Window**: 30 days
**Monthly budget**: {43.2 minutes}

### This incident
- Duration of SLO impact: {N minutes}
- Budget consumed by this incident: {N%} ({N min} of {N min})
- Cumulative budget consumed this month: {N%}
- Budget remaining: {N%} ({N min})

### Trend
- Budget consumed last 7 days: {N%}
- At this burn rate, budget exhausts in: {N days | "Will not exhaust"}

### Recommendation
{Green / Yellow / Orange / Red — with action based on error budget policy}
```

## Oncall Friction Log

Track on-call friction weekly. Use in quarterly on-call reviews.

```markdown
## On-Call Friction Log — Week of {YYYY-MM-DD}

**On-call**: @{name}

| Date | Alert | Actionable? | Runbook exists? | Resolution time | Notes |
|------|-------|------------|----------------|----------------|-------|
| Mon | {alert name} | Yes / No | Yes / No | {N min} | |

### Summary
- Total pages: {N}
- False positives (no action needed): {N} ({%})
- Missing runbooks: {N}
- Average time to resolve: {N min}

### Improvements needed
1. {Alert name}: {suggested improvement}
```
