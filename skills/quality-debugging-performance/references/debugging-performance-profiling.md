# Performance Debugging & Profiling

<!-- ported from mercure-plugin/skills/quality-debugging-performance/ -->

## Overview

Performance debugging identifies and resolves bottlenecks that cause slow response times, high resource usage, or degraded user experience. Covers profiling techniques, common performance issues, and optimization strategies.

## 80/20 Quick Reference

**Performance Issue Types:**

| Issue | Symptoms | Primary Tool |
|-------|----------|--------------|
| CPU-bound | High CPU, slow execution | CPU profiler |
| Memory-bound | High memory, GC pauses | Heap profiler |
| I/O-bound | Waiting on disk/network | Async profiler |
| Concurrency | Deadlocks, contention | Thread profiler |
| N+1 queries | Slow DB operations | Query analyzer |

**Performance Debugging Flow:**

| Step | Action | Goal |
|------|--------|------|
| 1. Measure | Establish baseline | Know starting point |
| 2. Profile | Identify hotspots | Find bottlenecks |
| 3. Analyze | Understand root cause | Determine fix |
| 4. Optimize | Implement improvement | Improve performance |
| 5. Verify | Compare to baseline | Confirm improvement |

## CPU Profiling

**Node.js:**
```bash
node --prof app.js
node --prof-process isolate-*.log > profile.txt
```

Look for the `[Bottom up]` section — the most expensive functions.

**Common CPU issues:**
- O(n²) algorithms where O(n) is possible
- Excessive object creation in loops
- Sequential async operations that can be parallelized

**Anti-Pattern**: Optimizing without profiling first.

## Memory Profiling

**Heap snapshot analysis** (Node.js):
```typescript
import { writeHeapSnapshot } from 'v8';
// Take snapshot before/after to detect growth
const filename = writeHeapSnapshot();
```

**Common memory leaks:**
- Event listener accumulation (add without remove)
- Closures holding large references unnecessarily
- Unbounded cache growth (no LRU/max-size)
- Timer references never cleared

**Anti-Pattern**: Ignoring memory growth in long-running services.

## I/O and Async Profiling

**Request timing breakdown** — instrument each phase:
```
auth:           50ms  (20%)
validation:     10ms   (4%)
database:      150ms  (61%)  ← BOTTLENECK
processing:     20ms   (8%)
serialization:  15ms   (6%)
```

**Database query profiling:** track slow queries (>100ms), detect N+1 patterns by counting repeated normalized queries.

**Anti-Pattern**: Not measuring actual I/O time, guessing at bottlenecks.

## Application Performance Monitoring (APM)

Use transactions + spans to capture production performance:

```typescript
const transaction = apm.startTransaction(`${req.method} ${req.path}`, 'request');
const dbSpan = apm.startSpan('fetch_customer', 'db');
const customer = await db.findCustomer(id);
apm.endSpan(dbSpan);
apm.endTransaction(transaction);
```

**Anti-Pattern**: No production monitoring, only discovering issues from user complaints.

## Checklist

- [ ] Baseline performance measured before optimization
- [ ] CPU profiler used for computation-heavy code
- [ ] Memory profiler used for long-running services
- [ ] I/O operations timed and analyzed
- [ ] Database queries profiled for N+1 patterns
- [ ] Async operations tracked for bottlenecks
- [ ] Performance regression tests in place
- [ ] APM monitoring in production
- [ ] Performance budgets defined
- [ ] Optimizations verified with benchmarks
