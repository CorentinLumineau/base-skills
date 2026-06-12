# Scalability Heuristics

<!-- ported from mercure-plugin/skills/meta-rearchitect/references/scalability-heuristics.md -->

Growth scenario templates and O(n) analysis methodology for architectural assessment.

## Growth Scenario Framework

Each scenario asks: "What happens when dimension X grows by factor Y?"

### Scenario 1: Component Count x3

| Metric | How to Measure | O(n) Target | Red Flag |
|--------|---------------|-------------|----------|
| Build time | `time make build` | O(n) | O(n^2) — every component tests against every other |
| Validation time | `time make verify` | O(n) | O(n^2) — cross-component checks scale with skill count |
| Configuration size | `wc -l config files` | O(n) | O(n^2) — config grows faster than components |
| Cognitive load | New developer onboarding time | O(log n) | O(n) — must understand all components |

### Scenario 2: Team Size x3

| Metric | How to Measure | O(n) Target | Red Flag |
|--------|---------------|-------------|----------|
| Merge conflicts | `git log --merges --oneline -100` | O(1) per developer | O(n) — everyone touching same files |
| PR review time | Average time from open to merge | O(1) per PR | O(n) — every PR needs everyone's review |
| Code ownership | `git log --format='%an' -- path/ \| sort -u \| wc -l` | 1–2 owners per module | > 5 owners (shared ownership) |
| Communication overhead | Meetings per week | O(log n) | O(n^2) — everyone needs to sync with everyone |

### Scenario 3: Traffic x10

| Metric | How to Measure | O(n) Target | Red Flag |
|--------|---------------|-------------|----------|
| Response latency | p50/p95/p99 percentiles | O(1) — constant | O(n) — linear degradation |
| Throughput | Requests per second | O(n) — scales with resources | Plateau (saturation point) |
| Error rate | 5xx / total requests | O(1) — constant | O(n) — errors increase with load |
| Resource utilization | CPU, memory, connections | O(n) — linear scaling | O(n^2) — superlinear (connection pools, GC) |

### Scenario 4: Data Volume x10

| Metric | How to Measure | O(n) Target | Red Flag |
|--------|---------------|-------------|----------|
| Query time | `EXPLAIN ANALYZE` on key queries | O(log n) — indexed | O(n) — full table scans |
| Storage cost | Total DB size | O(n) — linear | O(n^2) — denormalization bloat |
| Migration time | Schema migration duration | O(1) — index-only | O(n) — full table rewrite |
| Backup/restore | Time to backup and restore | O(n) — linear | O(n^2) — cross-table consistency |

### Scenario 5: Feature Count x3

| Metric | How to Measure | O(n) Target | Red Flag |
|--------|---------------|-------------|----------|
| Files per feature | Average files changed for new feature | O(1) — isolated | O(n) — every feature touches core |
| Regression risk | Test failures from unrelated changes | O(1) — independent | O(n) — features interfere |
| Onboarding time | Time for new dev to be productive | O(log n) — bounded | O(n) — must understand everything |
| Documentation size | Docs pages per feature | O(1) — self-contained | O(n) — cross-references everywhere |

## O(n) Analysis Methodology

### Step 1: Identify Growth Dimensions

For the target system, determine which dimensions are expected to grow:
- Component count (modules, services, skills)
- Team size (developers, teams, organizations)
- Traffic (requests, events, messages)
- Data volume (records, storage, history)
- Feature count (capabilities, modes, options)

### Step 2: Measure Current Baseline

For each relevant dimension, measure the key metrics at current scale:
```bash
# Component count
find src/ -maxdepth 1 -type d | wc -l

# Current build time
time make build 2>&1 | tail -1

# Average files per commit (proxy for coupling)
git log --oneline -50 --stat | grep "files changed" | awk '{sum+=$1; n++} END{print sum/n}'
```

### Step 3: Extrapolate to Growth Factor

For each metric, predict the value at 3x/10x the current dimension:
- **O(1)**: Same value regardless of growth — ideal
- **O(log n)**: Grows slowly — good
- **O(n)**: Grows linearly — acceptable for most metrics
- **O(n log n)**: Grows faster than linear — watch carefully
- **O(n^2)**: Grows quadratically — will become a bottleneck
- **O(2^n)**: Exponential — architectural redesign needed

### Step 4: Identify Bottlenecks

Any metric that is O(n^2) or worse at 3x growth is a **scalability bottleneck** that should be addressed before growth occurs.

## Bottleneck Classification

| Complexity | Urgency | Action |
|-----------|---------|--------|
| O(1) to O(n) | None | Architecture supports growth |
| O(n log n) | Low | Monitor, plan for optimization |
| O(n^2) | Medium | Address before next growth phase |
| O(2^n) | Critical | Architectural redesign required now |

## Report Template

```markdown
### Scalability Assessment for {system}

#### Growth Dimensions
- Primary: {dimension} (expected {factor}x growth in {timeframe})
- Secondary: {dimension} (expected {factor}x growth)

#### Bottleneck Summary
| Metric | Current | At {factor}x | Complexity | Urgency |
|--------|---------|-------------|-----------|---------|
| {metric} | {value} | {projected} | O({class}) | {level} |

#### Recommendations
1. [P1] {bottleneck} — {mitigation strategy}
2. [P2] {bottleneck} — {mitigation strategy}
```
