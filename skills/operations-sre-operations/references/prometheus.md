# Prometheus

PromQL patterns, recording rules, and configuration for SRE metrics.

## PromQL Fundamentals

### Metric Types

| Type | Description | When to use |
|------|-------------|------------|
| Counter | Always increasing | Request counts, error counts, bytes transferred |
| Gauge | Can increase or decrease | Memory usage, queue depth, active connections |
| Histogram | Sampled observations in buckets | Latency, request sizes |
| Summary | Pre-computed quantiles | Same as histogram but less flexible for aggregation |

### Key Functions

```promql
# Rate: per-second average over window (for counters)
rate(http_requests_total[5m])

# Increase: total increase over window (for counters)
increase(http_requests_total[1h])

# Delta: change over window (for gauges)
delta(queue_depth[5m])

# Histogram quantile
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Aggregation
sum by (status) (rate(http_requests_total[5m]))
avg without (pod) (rate(cpu_usage_seconds[5m]))
```

## Core SRE Queries

### Error Rate

```promql
# HTTP error rate (5xx)
sum(rate(http_requests_total{status=~"5.."}[5m])) /
sum(rate(http_requests_total[5m]))

# Error rate by service
sum by (service) (rate(http_requests_total{status=~"5.."}[5m])) /
sum by (service) (rate(http_requests_total[5m]))
```

### Latency

```promql
# p99 latency across all endpoints
histogram_quantile(0.99,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
)

# p99 latency by endpoint
histogram_quantile(0.99,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le, handler)
)

# % of requests under 300ms
sum(rate(http_request_duration_seconds_bucket{le="0.3"}[5m])) /
sum(rate(http_request_duration_seconds_count[5m]))
```

### Availability SLI

```promql
# Availability over last 30 days (rolling window)
sum(increase(http_requests_total{status=~"2..|3.."}[30d])) /
sum(increase(http_requests_total[30d]))
```

### Error Budget Burn Rate

```promql
# Current burn rate (1h window) for 99.9% SLO
(
  sum(rate(http_requests_total{status=~"5.."}[1h])) /
  sum(rate(http_requests_total[1h]))
) / (1 - 0.999)
```

## Recording Rules

Recording rules pre-compute expensive queries for dashboard performance and burn rate alerts.

```yaml
groups:
  - name: {service}.recording
    interval: 60s
    rules:
      # Error rate (1-minute resolution)
      - record: job:http_errors:rate5m
        expr: |
          sum by (job) (
            rate(http_requests_total{status=~"5.."}[5m])
          ) / sum by (job) (
            rate(http_requests_total[5m])
          )

      # p99 latency
      - record: job:http_latency_p99:rate5m
        expr: |
          histogram_quantile(0.99,
            sum by (job, le) (
              rate(http_request_duration_seconds_bucket[5m])
            )
          )

      # Request rate
      - record: job:http_requests:rate5m
        expr: |
          sum by (job) (rate(http_requests_total[5m]))
```

## Instrumentation Conventions

### HTTP Service Instrumentation (Go)

```go
var (
    requestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds",
            Help:    "HTTP request duration in seconds",
            Buckets: []float64{0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5},
        },
        []string{"handler", "method", "status"},
    )
    requestTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total HTTP requests",
        },
        []string{"handler", "method", "status"},
    )
)
```

### Label Conventions

| Label | Values | Notes |
|-------|--------|-------|
| `job` | Service name | Set by Prometheus scrape config |
| `instance` | `host:port` | Set by Prometheus |
| `status` | HTTP status code | Use string ("200", "500") |
| `method` | HTTP method | Uppercase ("GET", "POST") |
| `handler` | Route pattern | Use template not actual URL |

**Avoid high-cardinality labels**: Never use user IDs, request IDs, or session tokens as labels.
Each unique label combination creates a new time series. High cardinality causes memory exhaustion.

## Prometheus Configuration

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: '{service}'
    static_configs:
      - targets: ['{host}:{port}']
    metrics_path: /metrics
    scrape_timeout: 10s
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
```

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Using average latency | Hides tail latency; p99 may be 10x worse | Use histogram_quantile(0.99, ...) |
| `increase()` on gauge | Nonsensical result | Use `delta()` for gauges |
| High-cardinality labels | Memory exhaustion, slow queries | Keep label values bounded |
| Querying 30d windows without recording rules | Dashboard query times out | Pre-compute with recording rules |
| Absolute error counts in alerts | Traffic-sensitive, noisy | Alert on rates, not counts |
