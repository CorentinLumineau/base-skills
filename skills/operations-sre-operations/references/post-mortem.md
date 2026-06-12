# Post-Mortem (SRE)

SRE-focused post-mortem template with error budget impact analysis.

## When to Write a Post-Mortem

| Severity | Requirement | Deadline |
|----------|------------|---------|
| SEV-1 | Mandatory | 48 hours after resolution |
| SEV-2 | Mandatory | 48 hours after resolution |
| SEV-3 | Required | 5 business days |
| SEV-4 | Optional | If recurrence risk is elevated |

## Post-Mortem Template

```markdown
# Post-Mortem: {Incident title}

**Date of incident**: {YYYY-MM-DD}
**Severity**: SEV-{N}
**Duration**: {N hours N minutes}
**Facilitator**: @{name}
**Authors**: @{names}
**Status**: Draft | Review | Final

---

## Executive Summary

{3 sentences: what failed, who was affected (users + SLO impact), how it was resolved.}

---

## Impact

| Metric | Value |
|--------|-------|
| User impact | {N users or % of traffic} |
| Duration | {N minutes} |
| SLO impact | {% of error budget consumed} |
| Revenue impact | {estimate or "not calculated"} |
| Error budget remaining | {%} |

---

## Timeline (all times UTC)

| Time | Event | Source |
|------|-------|--------|
| HH:MM | {First observable symptom — may predate alert} | {alert / logs / user} |
| HH:MM | {Alert fired / incident declared} | {PD / Slack} |
| HH:MM | {IC assigned} | |
| HH:MM | {Root cause identified} | |
| HH:MM | {Mitigation applied} | |
| HH:MM | {Resolution confirmed} | |

Detection gap: {time between first symptom and alert/detection}

---

## Root Cause

{1-3 paragraphs describing the technical root cause.}

**5-Whys**:
1. Why did the service fail? → {answer}
2. Why? → {answer}
3. Why? → {answer}
4. Why? → {answer}
5. Root cause: {answer}

---

## Contributing Factors

- {Factor that made the incident worse or harder to detect}

---

## What Went Well

- {Runbook was accurate}
- {Fast escalation}

---

## What Went Poorly

- {Missing alert for early symptom}
- {Runbook step was wrong}

---

## Action Items

| # | Action | Owner | Due | Ticket | Category |
|---|--------|-------|-----|--------|---------|
| 1 | {Specific, measurable action} | @{name} | {date} | {link} | detection / prevention / runbook |

---

## SLO and Error Budget Analysis

**SLO**: {service} — {target}% availability
**Budget consumed by this incident**: {N min} = {N%} of monthly budget
**Cumulative budget consumed this month**: {N%}
**Budget remaining**: {N%} ({N min})

**If this burn rate continues**: budget exhausts in {N days / "will not exhaust"}

**Policy state**: {Green / Yellow / Orange / Red} → {action required per error budget policy}

---

## Lessons Learned

{1-3 sentences on the key systemic takeaway}
```

## Action Item Checklist

Good action items are SMART:
- **Specific**: "Add PagerDuty alert for connection pool >80%" not "improve monitoring"
- **Measurable**: Clear done state
- **Assignable**: One named owner, not "the team"
- **Realistic**: Achievable by the due date
- **Time-bound**: Specific date, not "soon"

## Facilitation Protocol

### 48-hour timeline

```
T+0   Incident resolved
T+4h  IC sends draft timeline to incident channel
T+24h Facilitator sends meeting invite + draft to participants
T+36h Meeting: review, root cause, action items
T+48h Final document published, tickets created
```

### Meeting agenda (60 min)

1. (5 min) Ground rules: blameless, psychological safety
2. (10 min) Review timeline for accuracy
3. (15 min) Root cause: walk the 5-whys
4. (10 min) Contributing factors
5. (5 min) What went well
6. (15 min) Action items: assign owner + date for each
7. (0 min) Close: "Is there anything we missed?"

### After the meeting

- Publish final document within 24 h
- Create all action item tickets immediately
- Share summary with stakeholders
- Update SLO dashboard if error budget was significantly consumed
