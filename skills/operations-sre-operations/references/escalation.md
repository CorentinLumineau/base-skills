# Escalation

Escalation path templates and on-call management standards.

## Escalation Principles

1. **Escalate early, not late**: Pride in "handling it yourself" causes longer TTR
2. **Escalate with context**: Include what you tried and what you know, not just "help me"
3. **Escalation is not failure**: It is the correct response to conditions that exceed your information or authority
4. **Clear ownership**: Every escalation has one person who owns the response

## Escalation Path Template

Document this per service during service onboarding:

```markdown
## Escalation Paths — {Service Name}

### Tier 1: On-call engineer
- **Who**: Current on-call rotation
- **How**: PagerDuty / OpsGenie alert or direct message
- **For**: All production alerts, SEV-3+

### Tier 2: Secondary on-call / team lead
- **Who**: {Name or role}
- **How**: Direct message + phone
- **Escalate if**: No response from Tier 1 in 10 min, or problem outside Tier 1 expertise
- **For**: Complex infrastructure issues, SEV-2

### Tier 3: Engineering manager / domain expert
- **Who**: {Name or role}
- **How**: Phone call
- **Escalate if**: SEV-1 with no resolution in 30 min
- **For**: Business decisions, customer communication approval, SEV-1

### Tier 4: Executive (CTO / VP Engineering)
- **Who**: {Name}
- **How**: Phone call + text
- **Escalate if**: Data loss, security breach, SEV-1 with customer-visible impact >1 hour
- **For**: Major incidents requiring business decisions or public communication

### Specialized teams
| Scenario | Team | Contact |
|---------|------|--------|
| Database issues | Platform / DBA team | #{channel} |
| Network / CDN | Infrastructure team | #{channel} |
| Security / breach | Security team | #{channel} (private) |
| Payment processing | Payments team | #{channel} |
| Customer data / GDPR | Legal + DPO | Email: {address} |
```

## Escalation Message Template

When escalating, always include:

```
ESCALATION — {what} — {severity}

Requesting help from: @{person/team}

What is happening:
{1-3 sentences: symptom, affected service, user impact}

What I know:
{Diagnostic findings so far}

What I tried:
{Steps taken, results}

What I need:
{Specific ask: expertise, access, decision, backup}

Urgency: {immediate / within N hours}
Incident channel: #{channel}
```

## On-Call Rotation Standards

### Rotation Structure

| Component | Recommendation |
|-----------|---------------|
| Primary rotation | 1 week shifts, minimum 2 engineers |
| Secondary rotation | 1 week shifts, offset from primary |
| Handoff | Live handoff or written summary required |
| Maximum hours paged | Alert if >4 pages/night on average (burnout signal) |

### On-Call Handoff Template

```markdown
## On-Call Handoff — {Date}

**Outgoing**: {name}
**Incoming**: {name}

### Active Issues
{List of open incidents or degradations — or "None"}

### Recent Incidents (last 7 days)
| Date | Incident | Status | Post-mortem |
|------|---------|--------|------------|
| {date} | {title} | Resolved / Action items open | {link or "In progress"} |

### Things to Watch
{Any conditions that are elevated but not alerting — high burn rate, approaching capacity, etc.}

### Runbook gaps
{Any alerts that fired without runbooks, or runbooks found to be inaccurate}

### Contact changes
{Any team member unavailable this week, backup contacts}
```

## Escalation Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Escalating without context | Wastes the escalation target's time | Always include what you tried |
| Waiting too long to escalate | Pride extends TTR; users suffer longer | Escalate at first sign of stall |
| Escalating without ownership | "Someone should handle this" | Name the owner before escalating |
| Escalating past on-call directly to manager | Bypasses expertise, undermines on-call | Follow tier structure |
| No response acknowledgement | Escalation chain breaks | Require acknowledgement at each tier |

## After-Hours Escalation Guidelines

**Page immediately (any hour)**:
- SEV-1: Complete outage, data loss, security breach
- SEV-2: Core feature broken for >50% of users

**Wait for business hours**:
- SEV-3: Degraded performance with workaround
- SEV-4: Non-critical issue

**Never wake for**:
- Failed batch jobs with no user impact (unless RPO violation)
- Capacity alerts below threshold (ticket, don't page)
- Duplicate alerts for already-acknowledged incidents
