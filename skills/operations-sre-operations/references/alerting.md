# Alerting

Alert design patterns, anti-patterns, and configuration standards.

## Alert Design Principles

1. **Alert on symptoms, not causes**: High error rate alerts; CPU spike logs.
2. **Every alert is actionable**: If no one knows what to do, it should not page.
3. **Alerts have runbooks**: Every alert that pages must link to a runbook.
4. **Avoid alert fatigue**: >5% false positive rate means the alert needs recalibration.
5. **Burn rate > threshold**: Burn rate alerts catch gradual erosion; raw thresholds miss slow burns.

## Alert Levels

| Level | When to use | Response channel | SLA |
|-------|------------|----------------|-----|
| **Page** | Immediate action required to prevent or stop user impact | PagerDuty / OpsGenie | Acknowledge <5 min |
| **Ticket** | Action needed within hours or days, not urgent | Jira / GitHub Issues | Resolve within SLA |
| **Log** | Historical record, no action required | Logging system | Review in retrospective |

## Burn Rate Alert Configuration

Recommended multi-window burn rate alert setup for a 99.9% SLO (30d window):

```yaml
# Alert 1: Fast burn — pages immediately
- alert: SLOFastBurn
  expr: |
    (
      sum(rate(http_requests_total{status=~"5.."}[1h])) /
      sum(rate(http_requests_total[1h]))
    ) / (1 - 0.999) > 14.4
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "Fast SLO burn rate — consuming >2% error budget per hour"
    runbook: "{runbook link}"

# Alert 2: Medium burn — pages with lower urgency
- alert: SLOMediumBurn
  expr: |
    (
      sum(rate(http_requests_total{status=~"5.."}[6h])) /
      sum(rate(http_requests_total[6h]))
    ) / (1 - 0.999) > 6
  for: 15m
  labels:
    severity: warning
  annotations:
    summary: "SLO burn rate elevated — consuming >5% error budget in 6 hours"
    runbook: "{runbook link}"
```

## Alert Rule Template (Prometheus / AlertManager)

```yaml
groups:
  - name: {service}.slo
    rules:
      - alert: {ServiceName}HighErrorRate
        expr: |
          sum(rate(http_requests_total{job="{service}", status=~"5.."}[5m])) /
          sum(rate(http_requests_total{job="{service}"}[5m])) > 0.05
        for: 5m
        labels:
          severity: critical
          team: {owning-team}
        annotations:
          summary: "{{ $labels.job }} error rate > 5%"
          description: "Error rate is {{ $value | humanizePercentage }} over the last 5 minutes"
          runbook: "https://{docs}/runbooks/{service}-high-error-rate"

      - alert: {ServiceName}HighLatency
        expr: |
          histogram_quantile(0.99,
            sum(rate(http_request_duration_seconds_bucket{job="{service}"}[5m])) by (le)
          ) > 1.0
        for: 5m
        labels:
          severity: warning
          team: {owning-team}
        annotations:
          summary: "{{ $labels.job }} p99 latency > 1s"
          description: "p99 latency is {{ $value }}s"
          runbook: "https://{docs}/runbooks/{service}-high-latency"
```

## Alert Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Alert on CPU > 80% | CPU is a cause; the symptom is latency or errors | Replace with latency/error rate alert |
| Alert with no `for` duration | Flaps on transient spikes, generates noise | Add `for: 5m` to require sustained condition |
| Alert without runbook | On-call has no guidance, slow response | Add runbook link to every paging alert |
| Too many critical alerts | Alert fatigue, critical loses meaning | Reserve critical for SLO-impacting conditions |
| Static thresholds on seasonal traffic | Constant false positives at peak | Use percentage/rate thresholds not absolute counts |
| Alert fires but metric is normal | Alert condition is wrong | Audit: would this alert have fired during last incident? |

## Alert Noise Management

Track alert quality metrics monthly:
- **False positive rate**: Alerts that fired but required no action (target: <5%)
- **Mean time to acknowledge**: How long before on-call responds (target: <SLA per severity)
- **Alert-to-incident ratio**: Alerts that became real incidents vs total alerts

High false positive rate remediation:
1. Add `for:` duration to filter transient spikes
2. Raise threshold if current threshold is too sensitive
3. Move to burn rate alerting instead of raw rate
4. Demote from page to ticket

## Deadman / Heartbeat Alerts

For detecting silent failures (jobs that stop running without error):

```yaml
- alert: BatchJobMissing
  expr: absent(batch_job_last_success_timestamp{job="{name}"}) or
        time() - batch_job_last_success_timestamp{job="{name}"} > 3600
  for: 10m
  labels:
    severity: critical
  annotations:
    summary: "Batch job {name} has not run in over 1 hour"
    runbook: "{runbook link}"
```
