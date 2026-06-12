---
name: operations-sre-operations
description: >
  Use when designing, implementing, or reviewing site reliability engineering practices:
  SLOs, error budgets, alerting, dashboards, runbooks, toil reduction, failover patterns,
  backup strategies, and capacity planning. Covers the full SRE lifecycle from service
  onboarding to steady-state reliability management.
  Do NOT use for active incident response (use operations-incident-response instead).
license: MIT
compatibility: >
  Always-on knowledge skill. Works with any agent that can read or write infrastructure
  configuration, dashboards, alert rules, or SRE documentation.
metadata:
  type: knowledge
  domain: operations
allowed-tools:
  - Read
  - Write
  - Bash
---

<!-- ported from mercure-plugin/skills/operations-sre-operations/ -->

# SRE Operations

**triggers**: Setting up SLOs for a new service, designing an alerting strategy, reducing toil,
reviewing reliability posture, implementing failover, planning backup strategy

## Core SRE Concepts

| Concept | Definition |
|---------|-----------|
| **SLI** (Service Level Indicator) | Quantitative measure of service behavior (e.g., request success rate) |
| **SLO** (Service Level Objective) | Target value for an SLI (e.g., 99.9% success rate over 30 days) |
| **SLA** (Service Level Agreement) | External commitment backed by consequences (business/legal) |
| **Error Budget** | 1 - SLO target = allowable failure rate (e.g., 0.1% for 99.9% SLO) |
| **Toil** | Manual, repetitive operational work that scales with service growth |

## SLO Framework

See [references/slo-framework.md](references/slo-framework.md) for the full SLO authoring guide.

### SLI Categories

| Category | Good SLIs | Bad SLIs |
|----------|----------|---------|
| Availability | HTTP 2xx/3xx / total requests | CPU utilization (cause, not symptom) |
| Latency | % requests under threshold | Average latency (hides tail latency) |
| Throughput | Requests processed per second | Queue depth (ambiguous) |
| Correctness | % responses with correct data | Lines of code (irrelevant) |

### SLO Authoring Template

```yaml
service: {name}
slo:
  name: {descriptive name, e.g., "API Availability"}
  sli:
    metric: {metric name}
    good_events: {numerator — e.g., http_requests_total{status=~"2..|3.."}}
    total_events: {denominator — e.g., http_requests_total}
  target: 99.9%
  window: 30d
  error_budget: 0.1%  # 43.2 minutes/month
  owner: {team}
  review_trigger: "When error budget burns >50% in 7 days"
```

### Error Budget Policy

When error budget is consumed:
- **>50% in 7 days**: Freeze non-critical feature work, focus on reliability
- **>75% in 30 days**: Feature freeze, reliability sprint begins
- **100% consumed**: All hands on reliability until budget recovers

## Alerting

See [references/alerting.md](references/alerting.md) for alert rule patterns and anti-patterns.

### Alert Hierarchy

| Level | Purpose | Response | Examples |
|-------|---------|---------|---------|
| Page | Immediate human action required | On-call woken immediately | SLO breach, complete outage |
| Ticket | Action within hours/days | Ticket created | Slow error budget burn, approaching threshold |
| Log | Historical record | Review in retrospective | Individual errors, non-critical anomalies |

### Alert Design Rules

1. **Alert on symptoms, not causes**: Alert on "high error rate" not "CPU > 80%"
2. **Alert must be actionable**: If no one can act on it, it should not page
3. **Burn rate alerts > threshold alerts**: Burn rate catches gradual SLO erosion; raw thresholds miss slow burns
4. **Every alert has a runbook**: Alert firing without a runbook is a gap (create the runbook as a priority)

### Burn Rate Alerting (recommended)

```
Fast burn (1h window):   if burn_rate > 14.4  → page immediately (2% budget in 1h)
Slow burn (6h window):   if burn_rate > 6     → ticket (5% budget in 6h)
Weekly trend (3d window): if burn_rate > 1    → review (100% burn pace)
```

## Dashboards

See [references/dashboards.md](references/dashboards.md) for dashboard design patterns.

### USE Method (Infrastructure)
- **U**tilization: % of resource used
- **S**aturation: queue depth, pending work
- **E**rrors: error count/rate

### RED Method (Services)
- **R**ate: requests per second
- **E**rrors: error rate
- **D**uration: latency distribution (p50, p95, p99)

### Golden Signals Dashboard Structure

Every service dashboard should have:
1. **Overview row**: SLO status, error budget remaining, RED metrics
2. **Latency row**: p50, p95, p99 latency over time
3. **Traffic row**: request rate, breakdown by endpoint/status
4. **Errors row**: error rate, error breakdown by type
5. **Saturation row**: CPU, memory, connection pool, queue depth

## Prometheus

See [references/prometheus.md](references/prometheus.md) for PromQL patterns and recording rules.

### Key PromQL Patterns

```promql
# Error rate (5-minute window)
rate(http_requests_total{status=~"5.."}[5m]) /
rate(http_requests_total[5m])

# p99 latency
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Availability SLI
sum(rate(http_requests_total{status=~"2..|3.."}[30d])) /
sum(rate(http_requests_total[30d]))

# Error budget burn rate
1 - (
  sum(rate(http_requests_total{status=~"2..|3.."}[1h])) /
  sum(rate(http_requests_total[1h]))
) / (1 - 0.999)  # 0.999 = SLO target
```

## Error Budgets

See [references/error-budgets.md](references/error-budgets.md) for error budget tracking and policies.

### Monthly Error Budget Reference

| SLO Target | Monthly Budget | Weekly Budget | Daily Budget |
|-----------|---------------|--------------|-------------|
| 99.9% | 43.2 min | 10.1 min | 1.44 min |
| 99.95% | 21.6 min | 5.0 min | 43.2 sec |
| 99.99% | 4.3 min | 1.0 min | 8.6 sec |
| 99.999% | 26 sec | 6 sec | <1 sec |

## Runbook Templates

See [references/runbook-templates.md](references/runbook-templates.md) for SRE-specific runbook patterns.

### Runbook Categories

| Type | When to use |
|------|------------|
| Alert runbook | Triggered by a specific alert — step-by-step response |
| Operational runbook | Regular maintenance procedures (e.g., certificate rotation) |
| Break-glass runbook | Emergency access procedures |
| Recovery runbook | Restoring service after failure (e.g., failover, restore from backup) |

## Escalation

See [references/escalation.md](references/escalation.md) for escalation path templates.

### Escalation Matrix Template

| Condition | First contact | If no response in | Escalate to |
|-----------|--------------|------------------|------------|
| SEV-1 alert fires | Primary on-call | 5 minutes | Secondary on-call |
| Secondary no response | Engineering lead | 10 minutes | Engineering manager |
| Data loss or security | On-call + Security | Immediate | CISO + Legal |

## Incident Templates

See [references/incident-templates.md](references/incident-templates.md) for post-mortem and blameless review templates.

## Toil Reduction

See [references/toil-reduction.md](references/toil-reduction.md) for toil identification and elimination patterns.

### Toil Definition

Toil is operational work that is:
- **Manual**: Requires human execution, not automated
- **Repetitive**: Done again and again for the same reason
- **Automatable**: Could be done by a machine
- **Tactical**: No permanent improvement results
- **Scales with service**: More traffic = more toil

### Toil Elimination Workflow

1. **Identify**: Track toil in a register (task, frequency, minutes per occurrence)
2. **Quantify**: Total toil hours per month per person
3. **Prioritize**: Highest frequency × time first
4. **Automate**: Build once, run forever
5. **Validate**: Confirm toil is actually gone (not just hidden)

**SRE principle**: Keep toil below 50% of engineering time. Above 50% = reliability debt.

## Failover Patterns

See [references/failover-patterns.md](references/failover-patterns.md) for failover design patterns.

### Failover Strategies

| Strategy | RTO | RPO | Complexity | Cost |
|---------|-----|-----|-----------|------|
| Active-Active | Seconds | Near-zero | High | High |
| Active-Passive (warm standby) | Minutes | Seconds-minutes | Medium | Medium |
| Cold standby | Hours | Minutes-hours | Low | Low |
| Backup restore | Hours-days | Hours | Low | Lowest |

**RTO** (Recovery Time Objective): Maximum acceptable downtime.
**RPO** (Recovery Point Objective): Maximum acceptable data loss (time).

### Failover Checklist

Before relying on a failover mechanism:
- [ ] Failover has been tested in production or a production-like environment
- [ ] Failover procedure is documented in a runbook
- [ ] DNS TTLs are set appropriately (low enough for fast failover)
- [ ] Database replication lag is monitored
- [ ] Failback procedure is documented and tested

## Backup Strategies

See [references/backup-strategies.md](references/backup-strategies.md) for backup design and testing.

### Backup Principles

1. **3-2-1 Rule**: 3 copies, 2 different media types, 1 offsite
2. **Test restores regularly**: An untested backup is not a backup
3. **Automate and verify**: Backups must be automated and verified complete
4. **Encrypt at rest**: All backups contain sensitive data

### Backup Testing Schedule

| Backup type | Test frequency | Test method |
|-------------|---------------|------------|
| Database full backup | Monthly | Full restore to test environment |
| Database incremental | Weekly | Point-in-time recovery test |
| File/object storage | Quarterly | Sample file restore |
| Infrastructure config | On change | Redeploy to staging |

## Post-Mortem

See [references/post-mortem.md](references/post-mortem.md) for the SRE post-mortem template.

## Quality Checklist

### Service Onboarding (SRE)

- [ ] SLOs defined with SLI, target, and window
- [ ] Error budget policy documented
- [ ] Burn rate alerts configured at 1h and 6h windows
- [ ] Dashboard created with all 4 golden signals
- [ ] At least one runbook per alert
- [ ] On-call rotation includes this service
- [ ] Escalation path defined
- [ ] Backup strategy documented and tested
- [ ] Failover tested (not just documented)

### Steady-State Reliability Review (monthly)

- [ ] Error budget consumed < 50%
- [ ] Toil register reviewed — no task >2h/month without automation plan
- [ ] Runbooks reviewed and updated
- [ ] Post-mortem action items completed
- [ ] Alert signal-to-noise ratio reviewed (>10% false positive rate = fix alerts)
