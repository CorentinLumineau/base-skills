# Refactoring Decision Tree

<!-- ported from mercure-plugin/skills/meta-rearchitect/references/refactoring-decision-tree.md -->

Decision framework for choosing between refactoring strategies, incremental migration, and rewrite.

## The Core Decision

```
Is the current architecture causing measurable pain?
│
├─ No → STOP — Don't refactor (YAGNI)
│
├─ Yes → Can the pain be fixed incrementally?
│   │
│   ├─ Yes → INCREMENTAL REFACTORING
│   │   │
│   │   ├─ Single component → Extract + Replace
│   │   ├─ Cross-cutting concern → Strangler Fig
│   │   └─ Interface change → Branch by Abstraction
│   │
│   └─ No → Is a full rewrite justified?
│       │
│       ├─ Team can maintain 2 systems during migration?
│       │   ├─ Yes, < 6 months → Parallel Rewrite
│       │   └─ Yes, > 6 months → Incremental with Feature Toggles
│       │
│       └─ No → Incremental Migration (forced)
```

## Strategy Catalog

### Strategy 1: Extract + Replace

**When**: Single component needs restructuring, boundaries are clear.

**Process**:
1. Write tests for the component's public interface
2. Create new component with desired structure
3. Route traffic to new component
4. Verify behavior matches
5. Remove old component

**Risk**: Low — isolated scope, easy rollback.
**Duration**: Days to weeks.

### Strategy 2: Strangler Fig

**When**: Cross-cutting concern needs replacement, system must stay running.

**Process**:
1. Build new implementation alongside the old one
2. Route new requests to new implementation
3. Gradually migrate existing request paths
4. Old implementation "strangled" as traffic routes away
5. Remove old implementation when traffic reaches 0

**Risk**: Medium — requires routing infrastructure and monitoring.
**Duration**: Weeks to months.

### Strategy 3: Branch by Abstraction

**When**: Interface change needed, many consumers to migrate.

**Process**:
1. Create an abstraction layer over the current implementation
2. Migrate all consumers to use the abstraction
3. Create new implementation behind the abstraction
4. Switch the abstraction to use new implementation
5. Remove old implementation

**Risk**: Medium — abstraction must be right, or it becomes tech debt.
**Duration**: Weeks to months.

### Strategy 4: Feature Toggle Migration

**When**: Gradual rollout needed, risk tolerance is low.

**Process**:
1. Implement new behavior behind feature toggle (disabled)
2. Enable for internal testing
3. Enable for percentage of users (canary)
4. Gradually increase percentage to 100%
5. Remove toggle and old code path

**Risk**: Low — instant rollback via toggle.
**Duration**: Weeks to months.

### Strategy 5: Parallel Rewrite

**When**: Architecture is fundamentally unsalvageable, team capacity exists.

**Process**:
1. Freeze feature development on old system (maintenance only)
2. Build new system from scratch using lessons learned
3. Migrate data from old to new
4. Switch traffic to new system
5. Decommission old system

**Risk**: HIGH — "second system effect", feature parity gaps, data migration bugs.
**Duration**: Months to years.

## Decision Inputs

### Pain Measurement

Before deciding, quantify the pain:

| Pain Signal | Measurement | Threshold for Action |
|-------------|-------------|---------------------|
| Developer velocity | Features per sprint | < 50% of historical average |
| Bug rate | Bugs per release | > 2x historical average |
| Onboarding time | Days to first PR | > 2 weeks |
| Change amplification | Files per logical change | > 8 files |
| Deployment frequency | Deploys per week | < 1 (when target is daily) |
| Mean time to recovery | Hours from incident to fix | > 4 hours |

### Refactor vs Rewrite Criteria

| Factor | Favors Refactor | Favors Rewrite |
|--------|----------------|----------------|
| Codebase age | < 5 years | > 10 years |
| Test coverage | > 60% | < 20% |
| Documentation | Exists | None |
| Team familiarity | High | Low (new team) |
| Business urgency | Can wait months | Needs it now |
| Feature parity | Must maintain 100% | Can accept gaps |
| Technology | Still supported | End of life |

## Risk Mitigation Checklist

Before starting any refactoring strategy:

- [ ] **Tests exist** for the code being refactored (or write them first)
- [ ] **Rollback plan** is documented and tested
- [ ] **Metrics baseline** captured (latency, error rate, throughput)
- [ ] **Feature freeze** communicated (if applicable)
- [ ] **Migration path** for data is defined
- [ ] **Team capacity** confirmed for duration
- [ ] **Success criteria** defined (what does "done" look like?)

## Anti-Patterns in Refactoring

| Anti-Pattern | Description | Prevention |
|-------------|-------------|-----------|
| **Big Bang Rewrite** | Rewrite everything at once, deploy in one go | Always prefer incremental strategies |
| **Refactor and Add Features** | Combining structural changes with behavior changes | One concern at a time — refactor OR add features, never both |
| **Gold Plating** | Refactoring beyond what the pain requires | Define success criteria before starting |
| **Incomplete Migration** | Old and new systems both maintained indefinitely | Set hard deadline for decommissioning old system |
| **Missing Tests** | Refactoring without safety net | Write characterization tests before any changes |
