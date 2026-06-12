# A/B Testing

<!-- ported from mercure-plugin/skills/delivery-infrastructure/references/ab-testing.md -->

## Key Statistical Concepts

| Metric | Purpose | Typical Value |
|--------|---------|---------------|
| Sample Size | Users needed per variant | Calculate from MDE, power, alpha |
| p-value | Probability result is due to chance | < 0.05 for significance |
| Statistical Power | Probability of detecting real effect | 80% minimum |
| MDE | Minimum Detectable Effect | Smallest meaningful difference |
| Confidence Level | Certainty level | 95% (alpha = 0.05) |

## Experiment Configuration

```yaml
experiment:
  name: checkout-redesign
  hypothesis: "Simplified checkout increases conversion by 5%+"
  variants:
    - name: control
      weight: 50
    - name: treatment
      weight: 50
  primary_metric: conversion_rate
  guardrail_metrics: [error_rate, latency_p99, bounce_rate]
  audience:
    include: { country: [US, CA], platform: [web] }
    exclude: { user_type: [internal, beta] }
  duration:
    min_days: 14
    max_days: 30
  sample_size:
    per_variant: 10000
    confidence: 0.95
    power: 0.80
    mde: 0.05
```

## Sample Size Calculation

```python
from scipy import stats
import math

def required_sample_size(baseline_rate, mde, alpha=0.05, power=0.80):
    """Calculate minimum sample size per variant."""
    z_alpha = stats.norm.ppf(1 - alpha / 2)  # Two-tailed
    z_beta = stats.norm.ppf(power)
    p1 = baseline_rate
    p2 = baseline_rate * (1 + mde)
    pooled_p = (p1 + p2) / 2
    n = ((z_alpha * math.sqrt(2 * pooled_p * (1 - pooled_p))
         + z_beta * math.sqrt(p1 * (1 - p1) + p2 * (1 - p2))) ** 2) / (p2 - p1) ** 2
    return math.ceil(n)

# Example: 3% baseline conversion, detect 5% relative lift
# required_sample_size(0.03, 0.05) -> ~100k per variant
```

## Statistical Analysis

### Chi-Square Test (for proportions)

```python
from scipy.stats import chi2_contingency

def analyze_conversion(control_visitors, control_conversions, treatment_visitors, treatment_conversions):
    table = [[control_conversions, control_visitors - control_conversions],
             [treatment_conversions, treatment_visitors - treatment_conversions]]
    chi2, p_value, dof, expected = chi2_contingency(table)
    control_rate = control_conversions / control_visitors
    treatment_rate = treatment_conversions / treatment_visitors
    relative_lift = (treatment_rate - control_rate) / control_rate
    return { "p_value": p_value, "significant": p_value < 0.05,
             "relative_lift": relative_lift, "control_rate": control_rate,
             "treatment_rate": treatment_rate }
```

### When to Use Which Test

| Data Type | Test |
|-----------|------|
| Conversion (binary) | Chi-square or Fisher's exact |
| Continuous (revenue, time) | Welch's t-test or Mann-Whitney U |
| Multiple comparisons | Bonferroni or Holm correction |

## Multi-Armed Bandit

Alternative to fixed A/B tests for optimization:

| Approach | When to Use |
|----------|-------------|
| Epsilon-greedy | Simple, good baseline (exploit best, explore epsilon% of time) |
| Thompson Sampling | Best general-purpose (Bayesian probability matching) |
| UCB | Optimistic exploration (upper confidence bound) |

**Trade-off**: Bandits optimize faster but provide less statistical rigor than fixed-split tests.

## Guardrail Metrics

Monitor guardrails to catch negative side effects:

| Metric | Threshold | Action if Breached |
|--------|-----------|-------------------|
| Error rate | >2x baseline | Halt experiment |
| P99 latency | >50% increase | Investigate |
| Bounce rate | >10% increase | Review UX |
| Revenue per user | >5% decrease | Halt experiment |

### Auto-Halt Criteria

Stop the experiment automatically if:
- Guardrail metric breached for >1 hour
- Error rate exceeds safety threshold
- Data quality issues detected (>5% missing events)

## Common Pitfalls

| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Peeking at results | Inflated false positive rate | Pre-define analysis schedule |
| Under-powered test | Cannot detect real effects | Calculate sample size upfront |
| Multiple comparisons | False discoveries | Apply correction (Bonferroni) |
| Selection bias | Skewed results | Randomize assignment properly |
| Novelty effect | Short-term lift fades | Run for 2+ weeks minimum |
| Sample ratio mismatch | Invalid results | Monitor assignment ratios daily |

## Checklist

- [ ] Hypothesis documented before starting
- [ ] Sample size calculated based on MDE
- [ ] Guardrail metrics defined
- [ ] Randomization verified (check ratio)
- [ ] Minimum duration defined (2+ weeks)
- [ ] Analysis plan pre-registered
- [ ] Auto-halt criteria configured
- [ ] Results reviewed for practical significance, not just statistical
