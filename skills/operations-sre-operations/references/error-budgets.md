# Error Budgets

Error budget calculation, tracking, and policy enforcement.

## What Is an Error Budget

The error budget is the amount of unreliability a service is allowed within the SLO window.

```
Error budget = 1 - SLO target

For 99.9% SLO over 30 days:
  Error budget = 0.1% = 43.2 minutes of allowed downtime per month
```

Error budgets make reliability a shared concern between SRE and product teams: spending the
budget on risky deployments is a choice with a visible cost.

## Error Budget Reference Table

| SLO Target | Monthly budget | Weekly budget | Daily budget | Hourly budget |
|-----------|---------------|--------------|-------------|--------------|
| 99% | 7h 18m | 1h 41m | 14.4 min | 36 sec |
| 99.5% | 3h 39m | 50.4 min | 7.2 min | 18 sec |
| 99.9% | 43.2 min | 10.1 min | 1.44 min | 2.16 sec |
| 99.95% | 21.6 min | 5.0 min | 43.2 sec | 1.08 sec |
| 99.99% | 4.3 min | 1.0 min | 8.64 sec | 0.22 sec |
| 99.999% | 26 sec | 6 sec | 0.86 sec | — |

## Burn Rate

Burn rate indicates how fast the error budget is being consumed relative to the normal rate.

```
burn_rate = actual_error_rate / (1 - SLO_target)

burn_rate = 1   → consuming budget at exactly the SLO pace (will exhaust at month end)
burn_rate = 10  → consuming 10x faster (will exhaust in 3 days at this rate)
burn_rate = 0   → no errors (budget recovering)
```

## Error Budget Tracking

### Prometheus Query

```promql
# Current error budget consumed (last 30 days)
1 - (
  sum(increase(http_requests_total{status=~"2..|3.."}[30d])) /
  sum(increase(http_requests_total[30d]))
) / (1 - 0.999)

# Error budget remaining (as percentage)
(
  sum(increase(http_requests_total{status=~"2..|3.."}[30d])) /
  sum(increase(http_requests_total[30d]))
  - 0.999
) / (1 - 0.999) * 100

# Current burn rate (1h window)
(
  sum(rate(http_requests_total{status=~"5.."}[1h])) /
  sum(rate(http_requests_total[1h]))
) / (1 - 0.999)
```

## Error Budget Policy

### Policy States

| State | Budget remaining | Actions required |
|-------|-----------------|-----------------|
| Green | >50% | Normal operations, features and reliability in balance |
| Yellow | 25-50% | Reliability tasks get priority, weekly review required |
| Orange | 10-25% | Feature freeze for risky work, daily review, manager informed |
| Red | <10% | All risky deployments blocked, full reliability focus |
| Exhausted | 0% | Full team on reliability, external escalation if no recovery in 2 weeks |

### Policy Enforcement

The error budget policy must be documented, agreed upon by product and SRE, and enforced
automatically where possible (e.g., block deploys when budget is exhausted).

```markdown
## Error Budget Policy — {Service Name}

**Owner**: {team}
**SLO**: {target}% over {window}
**Budget**: {minutes} per month

### Deployment gates
- Green: All deployments allowed
- Yellow: High-risk deployments require SRE review
- Orange: Only hotfixes and reliability improvements
- Red: Deployments blocked except emergency hotfixes (require VP approval)
- Exhausted: No deployments until budget recovers to 10%

### Incident contribution
- Incidents consuming >10% of monthly budget trigger mandatory post-mortem
- Incidents consuming >50% of budget trigger reliability sprint in next cycle
```

## Budget vs. Maintenance Windows

Planned maintenance and deployments consume error budget. Account for planned downtime
when setting SLO targets.

| Activity | Budget consumption | Mitigation |
|----------|--------------------|-----------|
| Database migration (5 min downtime) | 5 min of 43 min budget = 11.6% | Announce, schedule, minimize window |
| Rolling deployment (no downtime) | 0 (if done correctly) | Canary + health checks |
| Dependency upgrade (1% error rate, 30 min) | 0.3 min effective budget = 0.7% | Test in staging, roll back fast |

## Error Budget Recovery

When the budget is exhausted:
1. Stop consuming budget: freeze risky work, revert recent changes if causally linked
2. Identify largest budget consumers from incident history
3. Fix root causes, not symptoms
4. Monitor burn rate daily until budget recovers to >25%
5. Retrospective: why did the budget exhaust? What process change prevents recurrence?
