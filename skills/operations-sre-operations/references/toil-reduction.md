# Toil Reduction

Identifying, measuring, and eliminating operational toil.

## What Counts as Toil

Toil has ALL of these properties:

| Property | Description |
|----------|-------------|
| **Manual** | A human must perform it; cannot run unattended |
| **Repetitive** | Performed repeatedly, not a one-time task |
| **Automatable** | A computer could do it with sufficient investment |
| **Tactical** | No permanent improvement results from doing it |
| **Scales with load** | More traffic/users/services = more of this work |

Work that is NOT toil:
- Novel problem-solving and design
- Mentoring and knowledge sharing
- Strategic planning
- Automation work itself (even if repetitive, it eliminates future toil)
- Incident response (investigative/creative parts)

## Toil Register

Track toil in a team register. Review monthly.

```markdown
## Toil Register — {Team}

| Task | Frequency | Minutes/occurrence | Hours/month | Automatable? | Owner | Status |
|------|-----------|-------------------|-------------|-------------|-------|--------|
| Manual DB backup verification | Daily | 15 min | 7.5h | Yes | @{name} | Planned Q3 |
| Deployment approvals | 10/week | 5 min | 3.5h | Partial | @{name} | In progress |
| Certificate rotation | Monthly | 60 min | 1h | Yes | @{name} | Not started |
```

**Trigger**: If any single task exceeds 2h/month per engineer, it needs an automation plan.
**Target**: Toil should be <50% of each SRE's time. Above 50% = reliability debt accumulating.

## Toil Identification Methods

### Activity Logging (2-week sprint)
Each engineer tracks time spent on unplanned repetitive work.
Review at end of sprint: which tasks appeared more than twice?

### Incident Post-Mortem Mining
Review post-mortem action items: which ones recur across multiple incidents?
Recurring mitigations are toil.

### On-Call Shadow
A senior engineer shadows on-call for one shift focused on identifying toil:
- Which tasks did the on-call perform that could be automated?
- Which runbook steps are mechanical and predictable?

## Toil Elimination Workflow

```
MEASURE → PRIORITIZE → AUTOMATE → VALIDATE → CELEBRATE
```

### 1. Measure
Quantify before automating:
- Hours per month consumed
- Number of people affected
- Frequency of occurrence

### 2. Prioritize
Score by: `impact = (hours_per_month × people_affected) / automation_effort_days`
High impact = high hours, many people, low effort to automate. Start here.

### 3. Automate

Common automation targets:

| Toil task | Automation approach |
|-----------|-------------------|
| Manual deploy verification | Post-deploy smoke tests in CI |
| Certificate rotation | cert-manager / auto-renewal |
| Log analysis | Alert on patterns, not manual grep |
| Capacity scaling | Horizontal pod autoscaler |
| DB backup verification | Automated restore test on schedule |
| Dependency update PRs | Renovate / Dependabot |
| Status page updates | Integrate with alerting system |

### 4. Validate
After automation, verify:
- The toil task no longer appears in the register
- The automation handles edge cases (not just happy path)
- A human is alerted if the automation fails

### 5. Update the Register
Mark the task eliminated. Calculate time saved. This creates a feedback loop that
motivates continued automation investment.

## Toil vs. Overhead

Not all non-project work is toil. Some overhead is unavoidable:

| Category | Example | Eliminate? |
|----------|---------|------------|
| Toil | Manual certificate rotation | Yes — automate |
| Overhead | Required compliance review | No — minimize time |
| Investment | Writing automation | No — it eliminates toil |
| Learning | Reading post-mortems | No — it builds knowledge |

## Capacity Planning Connection

Tracking toil per service reveals which services have the highest operational burden per unit
of business value. This informs:
- Which services need reliability investment
- Whether a service is a candidate for decommissioning
- How much SRE capacity a new service will consume
