# k6 Patterns

<!-- ported from mercure-plugin/skills/quality-observability/ -->

k6 is a modern load testing tool written in Go with a JavaScript scripting API. It excels at CI integration, low resource usage, and developer-friendly scripting.

## Quick Reference

| Concept | Purpose |
|---------|---------|
| VUs (Virtual Users) | Simulated concurrent users |
| Scenarios | Named execution configurations |
| Thresholds | Pass/fail criteria |
| Checks | In-script assertions |
| Tags | Custom metric labels |

## Pattern 1: Basic Load Test

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const apiDuration = new Trend('api_duration');

export const options = {
  stages: [
    { duration: '2m', target: 50 },
    { duration: '5m', target: 50 },
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'],
    http_req_failed: ['rate<0.01'],
    errors: ['rate<0.05'],
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';

export default function () {
  const listRes = http.get(`${BASE_URL}/api/products`, {
    tags: { name: 'ListProducts' },
  });

  check(listRes, {
    'list status 200': (r) => r.status === 200,
    'list has products': (r) => JSON.parse(r.body).length > 0,
  }) || errorRate.add(1);

  apiDuration.add(listRes.timings.duration);
  sleep(1);

  const createRes = http.post(
    `${BASE_URL}/api/orders`,
    JSON.stringify({ product_id: 'prod_001', quantity: 1 }),
    { headers: { 'Content-Type': 'application/json' }, tags: { name: 'CreateOrder' } }
  );

  check(createRes, {
    'create status 201': (r) => r.status === 201,
    'create has id': (r) => JSON.parse(r.body).id !== undefined,
  }) || errorRate.add(1);

  sleep(Math.random() * 3 + 1);
}
```

Anti-pattern: No think time between requests (unrealistic traffic pattern).

## Pattern 2: Scenario-Based Testing

Multiple user flows with different load profiles:

```javascript
export const options = {
  scenarios: {
    browsers: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '2m', target: 200 },
        { duration: '10m', target: 200 },
        { duration: '2m', target: 0 },
      ],
      exec: 'browseProducts',
    },
    buyers: {
      executor: 'constant-arrival-rate',
      rate: 50,
      timeUnit: '1m',
      duration: '14m',
      preAllocatedVUs: 20,
      maxVUs: 50,
      exec: 'purchaseFlow',
    },
  },
  thresholds: {
    'http_req_duration{scenario:browsers}': ['p(95)<300'],
    'http_req_duration{scenario:buyers}': ['p(95)<1000'],
    http_req_failed: ['rate<0.01'],
  },
};
```

Anti-pattern: Testing only a single endpoint instead of realistic user flows.

## Pattern 3: Stress Test (Finding Breaking Point)

```javascript
export const options = {
  scenarios: {
    breakpoint: {
      executor: 'ramping-arrival-rate',
      startRate: 10,
      timeUnit: '1s',
      preAllocatedVUs: 500,
      maxVUs: 2000,
      stages: [
        { duration: '2m', target: 10 },
        { duration: '5m', target: 50 },
        { duration: '5m', target: 100 },
        { duration: '5m', target: 200 },
        { duration: '5m', target: 500 },
        { duration: '5m', target: 1000 },
        { duration: '3m', target: 0 },
      ],
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<2000'],
    http_req_failed: ['rate<0.10'],  // 10% acceptable during stress
  },
};
```

Anti-pattern: Running stress tests against shared or production environments.

## Pattern 4: CI Integration

```yaml
# .github/workflows/load-test.yml
jobs:
  smoke-test:
    steps:
      - name: Run k6 smoke test
        uses: grafana/k6-action@v0.3.1
        with:
          filename: tests/load/smoke.js
        env:
          BASE_URL: http://localhost:3000

  load-test:
    if: github.ref == 'refs/heads/main'
    needs: smoke-test
    steps:
      - name: Run k6 load test
        uses: grafana/k6-action@v0.3.1
        with:
          filename: tests/load/load-test.js
          flags: --out json=results.json
        env:
          BASE_URL: ${{ secrets.STAGING_URL }}
```

Anti-pattern: Running load tests without threshold gates that can fail the pipeline.

## Pattern 5: Authenticated Endpoints

```javascript
import { SharedArray } from 'k6/data';

const users = new SharedArray('users', function () {
  return JSON.parse(open('./test-users.json'));
});

export default function () {
  const user = users[__VU % users.length];

  const loginRes = http.post(`${BASE}/api/auth/login`, JSON.stringify({
    email: user.email,
    password: user.password,
  }), { headers: { 'Content-Type': 'application/json' } });

  if (!check(loginRes, { 'login ok': (r) => r.status === 200 })) return;

  const token = JSON.parse(loginRes.body).token;
  const authHeaders = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  };

  http.get(`${BASE}/api/me`, { headers: authHeaders });
  sleep(1);
}
```

Anti-pattern: All VUs sharing a single auth token (not realistic, may hit rate limits).

## Checklist

- [ ] Smoke test passes before load test
- [ ] Realistic think times between requests
- [ ] Multiple user scenarios defined
- [ ] Thresholds set for p95, error rate
- [ ] Test data prepared (no shared state conflicts)
- [ ] CI integration with pass/fail gates
- [ ] Results stored for trend analysis
- [ ] Environment isolated from production
