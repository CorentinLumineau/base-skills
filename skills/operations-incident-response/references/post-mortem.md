# Post-Mortem

Template and facilitation guide for blameless post-mortems.

## When to Write a Post-Mortem

| Severity | Requirement | Deadline |
|----------|------------|---------|
| SEV-1 | Mandatory | 48 hours after resolution |
| SEV-2 | Mandatory | 48 hours after resolution |
| SEV-3 | Required | 5 business days |
| SEV-4 | Optional | If recurrence risk is high |

## Blameless Principle

Post-mortems attribute failures to systems and conditions, not individuals. The goal is to
understand what made the failure possible and to make the system more resilient.

**Blameless does not mean consequence-free**: If a process was not followed, investigate why
the process was not followed — not who failed to follow it.

## Facilitator Responsibilities

- Schedule within the deadline (48h / 5 days)
- Prepare the timeline before the meeting
- Ensure all voices are heard, especially those closest to the failure
- Keep discussion focused on "what happened" not "who did it"
- Drive to concrete, actionable follow-ups
- Publish the final document within 24 h of the meeting

## Post-Mortem Template

```markdown
# Post-Mortem: {Incident title}

**Date of incident**: {YYYY-MM-DD}
**Duration**: {N hours N minutes}
**Severity**: SEV-{N}
**Facilitator**: {name}
**Participants**: {names}
**Status**: Draft | Final

---

## Executive Summary

{3 sentences: what failed, who was affected, how it was resolved}

---

## Impact

| Metric | Value |
|--------|-------|
| User impact | {% affected or absolute number} |
| Duration | {N min} |
| Revenue impact | {estimate or "not calculated"} |
| SLO burn | {% of error budget consumed} |

---

## Timeline

All times in UTC.

| Time | Event |
|------|-------|
| HH:MM | {Earliest observable symptom — may predate the alert} |
| HH:MM | {Alert fired / user report received} |
| HH:MM | {Incident declared, IC assigned} |
| HH:MM | {Key diagnostic finding} |
| HH:MM | {Mitigation applied} |
| HH:MM | {Resolution confirmed} |

---

## Root Cause

{1-3 paragraphs describing the technical root cause.}

**5-Whys analysis**:

1. Why did the service fail?  
   → {answer}
2. Why did {answer}?  
   → {answer}
3. Why did {answer}?  
   → {answer}
4. Why did {answer}?  
   → {answer}
5. Why did {answer}?  
   → {root cause}

---

## Contributing Factors

{Factors that made the incident worse or harder to detect. These are not the root cause but
they amplified impact.}

- {Factor 1}
- {Factor 2}

---

## Detection

**Time to detect**: {N minutes from first symptom to alert/notice}

**How it was detected**: {alert | customer report | manual discovery}

**Detection gap**: {Was there a period where the issue existed but was not detected?
If yes, by how long, and what would have caught it earlier?}

---

## What Went Well

- {Something that worked: runbook was accurate, fast escalation, good communication}

---

## What Went Poorly

- {Something that made the incident worse: missing runbook, slow alert, unclear ownership}

---

## Action Items

| # | Description | Owner | Due | Ticket |
|---|-------------|-------|-----|--------|
| 1 | {Specific, measurable action} | @{name} | {YYYY-MM-DD} | {link} |
| 2 | | | | |

---

## Lessons Learned

{1-3 sentences on the key takeaway for the team}
```

## Action Item Quality Criteria

Good action items are:
- **Specific**: "Add alerting for DB connection pool exhaustion at >80%" not "improve monitoring"
- **Measurable**: Has a clear done state
- **Owned**: One named person, not a team
- **Dated**: Real deadline, not "soon"
- **Tracked**: Linked to a ticket in the work tracker

## Common Action Item Categories

| Category | Examples |
|----------|---------|
| **Detection** | Add alert, lower threshold, add synthetic monitor |
| **Prevention** | Add circuit breaker, improve input validation, add rate limiting |
| **Runbook** | Create missing runbook, update stale runbook step |
| **Process** | Add step to deployment checklist, improve on-call handoff |
| **Architecture** | Add redundancy, remove single point of failure |
| **Tooling** | Improve deployment rollback speed, add feature flag |

## Facilitation Guide

### Before the meeting
- Collect the timeline from incident channel (extract timestamps)
- Share the draft 24 h in advance so participants can add details
- Prepare the "5 whys" starting point

### During the meeting (60 min max)
1. (5 min) Review timeline — fill gaps, correct errors
2. (15 min) Root cause walk-through — use 5-whys
3. (10 min) Contributing factors
4. (10 min) What went well / what went poorly
5. (20 min) Action items — assign owner + deadline for each
- End with: "Is there anything we missed?"

### After the meeting
- Finalize and publish the document within 24 h
- Ensure all action items are in the ticket tracker
- Send summary to stakeholders

## Anti-Patterns

- **Blame language**: Replace "X forgot to" with "the process did not prevent"
- **Vague actions**: "Improve alerting" with no specifics goes nowhere
- **Missing owner**: Shared ownership = no ownership
- **Scheduling too late**: >1 week post-incident means context is lost
- **No follow-up**: Action items that never get checked are worse than not writing them
