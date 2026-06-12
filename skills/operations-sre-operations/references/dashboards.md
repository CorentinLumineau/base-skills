# Dashboards

Dashboard design standards using the RED method, USE method, and golden signals.

## Dashboard Design Principles

1. **Top-down flow**: Status → Symptoms → Causes — highest-level health at the top
2. **Consistent time ranges**: All panels on the same time range
3. **Actionable panels only**: If a panel never informs a decision, remove it
4. **Use rates, not totals**: `rate(errors[5m])` is more useful than `sum(errors)` over time

## Standard Service Dashboard

### Row 1: Service Health Overview

| Panel | Metric | Visualization |
|-------|--------|--------------|
| SLO Status | error_budget_remaining_percent | Gauge (green/yellow/red) |
| Error Budget Remaining | % remaining this month | Stat |
| Availability (30d) | 1 - error_rate (30d) | Stat |
| Request Rate | rate(requests[5m]) | Stat |

### Row 2: RED Metrics (Rate / Errors / Duration)

| Panel | Metric | Visualization |
|-------|--------|--------------|
| Request Rate | rate(http_requests_total[5m]) | Time series |
| Error Rate | rate(http_requests_total{status=~"5.."}[5m]) / rate(total[5m]) | Time series |
| p50 / p95 / p99 Latency | histogram_quantile(0.5/0.95/0.99, ...) | Time series |

### Row 3: Traffic Breakdown

| Panel | Metric | Visualization |
|-------|--------|--------------|
| Requests by Status Code | rate by status | Stacked bar |
| Requests by Endpoint | rate by route | Table |
| Geographic Distribution | by region (if applicable) | Geo map |

### Row 4: Saturation / Resource

| Panel | Metric | Visualization |
|-------|--------|--------------|
| CPU Usage | container_cpu_usage_seconds_total | Time series |
| Memory Usage | container_memory_working_set_bytes | Time series |
| Connection Pool | db_connections_in_use / max | Gauge |
| Queue Depth | queue_length | Time series |

## Grafana Panel Configuration

### Time Series Panel (recommended defaults)

```json
{
  "type": "timeseries",
  "options": {
    "legend": { "displayMode": "table", "placement": "bottom" },
    "tooltip": { "mode": "multi" }
  },
  "fieldConfig": {
    "defaults": {
      "custom": {
        "fillOpacity": 10,
        "lineInterpolation": "smooth"
      },
      "thresholds": {
        "mode": "absolute",
        "steps": [
          { "color": "green", "value": null },
          { "color": "yellow", "value": 0.01 },
          { "color": "red", "value": 0.05 }
        ]
      }
    }
  }
}
```

### SLO Gauge Panel

```json
{
  "type": "gauge",
  "options": {
    "reduceOptions": { "calcs": ["lastNotNull"] },
    "showThresholdMarkers": true
  },
  "fieldConfig": {
    "defaults": {
      "min": 0, "max": 100, "unit": "percent",
      "thresholds": {
        "steps": [
          { "color": "red", "value": null },
          { "color": "yellow", "value": 25 },
          { "color": "green", "value": 50 }
        ]
      }
    }
  }
}
```

## Dashboard Naming Convention

```
{service-name} — Overview
{service-name} — Latency Detail
{service-name} — Error Analysis
{service-name} — Infrastructure
{service-name} — Business Metrics
```

Prefixing with service name enables folder grouping and search.

## Dashboard Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Average latency only | Hides tail latency (p99 may be 10x worse) | Always show p50 + p99 |
| Absolute error counts | Not comparable across traffic levels | Use rates or percentages |
| Too many panels per row | Unreadable on standard screens | Max 4 panels per row |
| No time range selector | Fixed time range misses context | Enable Grafana time range picker |
| Stale/broken panels | Erodes trust in the dashboard | Remove or fix immediately |
| No links to runbooks | Dashboard shows problem but no path forward | Add annotation or panel links |

## USE Method (Infrastructure Resources)

For each infrastructure resource (CPU, memory, network, disk):

| Signal | Description | PromQL example |
|--------|-------------|---------------|
| Utilization | % of resource used | `rate(cpu_seconds_total[5m])` |
| Saturation | Work queue / pending | `node_load1 / count(node_cpu_info)` |
| Errors | Error count or rate | `rate(disk_io_errors_total[5m])` |

## Alert Annotations on Dashboards

Add alert rule annotations to dashboard time series panels to see when alerts fired:

```json
{
  "datasource": "-- Grafana --",
  "enable": true,
  "iconColor": "red",
  "name": "Alerts",
  "type": "alert"
}
```

This overlays alert events on metric graphs — essential for post-mortem timeline reconstruction.
