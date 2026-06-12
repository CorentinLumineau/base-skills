# SLO Framework

Guide for authoring, calibrating, and maintaining Service Level Objectives.

## SLO Authoring Process

### Step 1: Choose SLIs that reflect user experience

Ask: "What does a user experience when the service is working correctly?"

Good SLIs:
- Request success rate (non-5xx responses / all responses)
- Latency: % of requests completing under threshold (e.g., <300ms)
- Correctness: % of responses with expected data
- Freshness: % of data items updated within SLA window

Bad SLIs (causes, not symptoms):
- CPU utilization
- Memory usage
- Deployment frequency
- Number of errors in absolute terms (use rate instead)

### Step 2: Set the SLO target

**Start conservative**: It is easier to tighten an SLO than to explain why you missed it.

| Service type | Starting SLO target |
|-------------|-------------------|
| Internal tool (low criticality) | 99% |
| Internal tool (high criticality) | 99.5% |
| Customer-facing (non-payment) | 99.9% |
| Customer-facing (payment/auth) | 99.95% |
| Core platform dependency | 99.99% |

**Calibrate from history**: Calculate your actual reliability over the past 90 days.
Set the SLO target slightly below your historical performance to give room to improve.

### Step 3: Define the measurement window

| Window | Use case |
|--------|---------|
| 7 days (rolling) | Fast feedback, small error budget |
| 30 days (rolling) | Standard — recommended for most services |
| 90 days (rolling) | Stable services with long-term commitments |
| Calendar month | Aligns with billing/SLA contracts |

### Step 4: Document the SLO

```yaml
slo:
  service: {service name}
  name: {human-readable name, e.g., "API Request Success Rate"}
  description: >
    {1-2 sentences explaining what this SLO measures and why it matters}

  sli:
    type: {availability | latency | correctness | freshness}
    good_events_query: |
      {PromQL or equivalent for numerator}
    total_events_query: |
      {PromQL or equivalent for denominator}

  target: {99.9%}
  window: {30d}
  error_budget: {0.1%}  # auto-calculated as 1 - target

  thresholds:
    latency_p99: {300ms}  # for latency SLOs

  owner: {team}
  stakeholders: [{list of teams that depend on this SLO}]
  review_date: {YYYY-MM-DD}  # quarterly review
  sla_backed: {true | false}  # whether there is an external SLA
```

## Multi-Window SLO Alerts

Use multiple burn rate windows to catch both fast and slow SLO erosion:

| Window | Burn rate threshold | Alert type | Ticket or Page |
|--------|-------------------|-----------|---------------|
| 1 hour | >14.4x | Very fast burn (2% budget/hr) | Page |
| 6 hours | >6x | Fast burn (5% budget/6h) | Page |
| 1 day | >3x | Medium burn | Ticket |
| 3 days | >1x | On track to exhaust budget | Ticket |

Formula: `burn_rate = error_rate / (1 - slo_target)`

## Error Budget Policy

The error budget policy defines how the team responds when the budget is consumed.

### Policy Template

```markdown
## Error Budget Policy for {service}

### Green (>50% budget remaining)
- Normal feature development continues
- Reliability work prioritized alongside features

### Yellow (25-50% budget remaining)
- Reliability improvements get priority over new features
- Root cause analysis for all SEV-2+ incidents required
- Weekly error budget review with team lead

### Red (<25% budget remaining)
- Feature freeze: only reliability and bug fixes
- Daily error budget review
- Engineering manager informed

### Exhausted (0% budget)
- Full team on reliability until budget recovers to 50%
- External escalation if budget does not recover within 2 weeks
```

## SLO Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| SLO set to 100% | No room for maintenance, always failing | Set realistic target |
| SLO tighter than historical performance | Constantly breached, alert fatigue | Calibrate from 90d history |
| SLO with no alert | No one knows when it is being consumed | Add burn rate alerts |
| Multiple SLOs measuring the same thing | Confusion about which one matters | Consolidate |
| SLO with no owner | Never reviewed, drifts out of date | Assign a team |

## SLO Review Cadence

| Review | Frequency | Participants | Output |
|--------|-----------|-------------|--------|
| Error budget review | Weekly (if <50% remaining) | On-call team | Action items |
| SLO health review | Monthly | SRE + service team | Calibration decisions |
| SLO target review | Quarterly | SRE + product | Target updates |
| SLA alignment review | Annually | SRE + legal + product | SLA updates |
