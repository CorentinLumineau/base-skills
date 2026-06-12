# Performance Baselines

<!-- ported from mercure-plugin/skills/quality-observability/ -->

Performance baselines establish expected behavior under known conditions. They enable regression detection, capacity planning, and SLO definition. Without baselines, performance testing produces data but no actionable insights.

## Quick Reference

| Baseline Type | What It Measures | Update Frequency |
|---------------|-----------------|------------------|
| Response time | p50, p95, p99 per endpoint | Per release |
| Throughput | Max RPS at acceptable latency | Monthly |
| Resource utilization | CPU, memory, disk at load | Per infra change |
| Error rate | Failures under normal load | Per release |
| Saturation point | Load level where SLOs break | Quarterly |

## Pattern 1: Capturing Baselines

```javascript
// baseline-capture.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Trend } from 'k6/metrics';

const endpoints = {
  listProducts: new Trend('baseline_list_products_duration'),
  getProduct: new Trend('baseline_get_product_duration'),
  createOrder: new Trend('baseline_create_order_duration'),
};

export const options = {
  scenarios: {
    baseline: {
      executor: 'constant-vus',
      vus: 20,
      duration: '10m',
    },
  },
  // No thresholds during capture — measuring, not asserting
};

export function handleSummary(data) {
  const baselines = {};
  for (const [name, metric] of Object.entries(data.metrics)) {
    if (name.startsWith('baseline_')) {
      baselines[name] = {
        p50: metric.values['p(50)'],
        p95: metric.values['p(95)'],
        p99: metric.values['p(99)'],
        avg: metric.values.avg,
        min: metric.values.min,
        max: metric.values.max,
      };
    }
  }
  return {
    'baselines.json': JSON.stringify(baselines, null, 2),
    stdout: textSummary(data),
  };
}
```

Example output:
```json
{
  "baseline_list_products_duration": { "p50": 45.2, "p95": 120.5, "p99": 250.3 },
  "baseline_create_order_duration": { "p50": 85.4, "p95": 210.7, "p99": 450.2 }
}
```

Anti-pattern: Capturing baselines during unusual conditions (deployments, maintenance, traffic spikes).

## Pattern 2: Regression Detection

```javascript
// regression-test.js
const baselines = JSON.parse(open('./baselines.json'));
const TOLERANCE = 1.2;  // Allow 20% degradation

export const options = {
  thresholds: {
    'http_req_duration{name:ListProducts}': [
      `p(95)<${baselines.baseline_list_products_duration.p95 * TOLERANCE}`,
    ],
    'http_req_duration{name:CreateOrder}': [
      `p(95)<${baselines.baseline_create_order_duration.p95 * TOLERANCE}`,
    ],
    http_req_failed: ['rate<0.01'],
  },
};
```

Anti-pattern: Using absolute thresholds that do not adapt as the system evolves.

## Pattern 3: Capacity Planning

```markdown
## Capacity Planning Template

| Metric | Value | Condition |
|--------|-------|-----------|
| Max sustainable RPS | 850 | p95 < 500ms |
| Breaking point RPS | 1,200 | Error rate > 1% |
| CPU at max RPS | 72% | 4 vCPU instances |
| Memory at max RPS | 3.2 GB | 4 GB allocated |

| Timeline | Expected RPS | Infrastructure Needed |
|----------|--------------|-----------------------|
| Current | 400 | 2x instances |
| +3 months | 600 | 3x instances |
| +6 months | 900 | 4x instances + DB upgrade |

| Trigger | Action |
|---------|--------|
| CPU > 70% sustained | Add instance |
| p95 > 400ms | Investigate bottleneck |
| DB connections > 80% pool | Increase pool or add read replica |
```

Anti-pattern: Planning capacity based on average metrics instead of percentiles.

## Pattern 4: SLO-Driven Baselines

```yaml
service: order-api
version: "2.1.0"

slos:
  availability:
    target: 99.9%
    error_budget_remaining: 50%

  latency:
    - name: fast-endpoints
      endpoints: ["/health", "/api/products"]
      p95_target: 200ms
      current_p95: 85ms
      headroom: 57%

    - name: write-endpoints
      endpoints: ["/api/orders"]
      p95_target: 500ms
      current_p95: 210ms
      headroom: 58%

  throughput:
    target_rps: 500
    current_max: 850
    headroom: 41%
```

Anti-pattern: Setting SLOs without measuring current baselines first.

## Pattern 5: Trend Tracking

```python
class BaselineTracker:
    def record(self, endpoint: str, version: str, metrics: dict):
        self.conn.execute(
            """INSERT INTO baselines
            (endpoint, version, captured_at, p50, p95, p99, error_rate)
            VALUES (?, ?, ?, ?, ?, ?, ?)""",
            (endpoint, version, datetime.now(),
             metrics["p50"], metrics["p95"], metrics["p99"],
             metrics.get("error_rate", 0)),
        )

    def detect_regression(self, endpoint: str, current: dict, tolerance: float = 0.2) -> dict:
        previous = self.get_trend(endpoint, limit=1)
        if not previous:
            return {"regression": False, "message": "No previous baseline"}
        prev = previous[0]
        degradation = (current["p95"] - prev["p95"]) / prev["p95"]
        return {
            "regression": degradation > tolerance,
            "degradation_pct": round(degradation * 100, 1),
            "previous_p95": prev["p95"],
            "current_p95": current["p95"],
        }
```

Anti-pattern: Tracking only averages, which hide latency spikes and tail behavior.

## Checklist

- [ ] Baselines captured under controlled conditions
- [ ] Same load profile used for comparison
- [ ] Percentiles tracked (p50, p95, p99), not just averages
- [ ] Baselines stored in version control or database
- [ ] Regression tolerance defined (e.g., 20%)
- [ ] Baselines updated after intentional changes
- [ ] Capacity projections reviewed quarterly
- [ ] SLOs informed by baseline data
- [ ] Trend dashboard accessible to team
- [ ] Alerting on baseline regression
