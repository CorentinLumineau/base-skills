---
name: meta-rearchitect
description: >
  Use when evaluating architectural health, identifying structural anti-patterns,
  or assessing scalability. Covers coupling taxonomy (Ca/Ce/instability metrics),
  SOLID at scale, architectural anti-pattern catalog, scalability heuristics
  (O(n) analysis, growth scenarios), and refactoring decision frameworks
  (Strangler Fig, Branch by Abstraction, Feature Toggle migration).
  Do NOT use for initial architecture decisions (use meta-analysis-architecture)
  or enforcement psychology (use meta-persuasion-principles).
license: MIT
compatibility: >
  Always-on knowledge skill. No special agent primitives required. Works with any
  agent that performs architectural health assessments or migration planning.
metadata:
  type: knowledge
  domain: meta
allowed-tools: Read Grep Glob
---

<!-- ported from mercure-plugin/skills/meta-rearchitect/ -->

# Rearchitect Knowledge

Architectural health assessment patterns, coupling analysis frameworks, and refactoring decision methodology.

## Quick Reference (80/20)

| Domain | Key Concepts | When to Apply |
|--------|-------------|---------------|
| Coupling Taxonomy | Afferent/efferent coupling, instability index, abstractness, distance from main sequence | Dependency analysis, module health assessment |
| SOLID at Scale | SRP for modules, OCP for extension points, LSP for service contracts, ISP for API surfaces, DIP for layer boundaries | System-level architecture evaluation |
| Anti-Pattern Catalog | God Object, Distributed Monolith, Big Ball of Mud, Vendor Lock-in, Premature Abstraction, Circular Dependency | Architecture audit, health check, retrospective |
| Scalability Heuristics | O(n) analysis, growth scenario modeling (component x3, team x3, traffic x10, data x10) | Capacity planning, architecture comparison |
| Refactoring Decisions | Strangler Fig, Branch by Abstraction, Feature Toggle — refactor vs rewrite | Migration strategy, architectural evolution |

## Coupling Analysis Framework

### Package Metrics (Robert C. Martin)

| Metric | Formula | Healthy | Alarm | Meaning |
|--------|---------|---------|-------|---------|
| Afferent coupling (Ca) | Incoming dependencies | < 10 | > 20 | How many modules depend on this one |
| Efferent coupling (Ce) | Outgoing dependencies | < 8 | > 15 | How many modules this one depends on |
| Instability (I) | Ce / (Ca + Ce) | 0.3–0.7 | 0 or 1 | 0 = maximally stable, 1 = maximally unstable |
| Abstractness (A) | Abstract types / total types | 0.2–0.8 | 0 or 1 | Ratio of interfaces to implementations |
| Distance (D) | \|A + I - 1\| | < 0.3 | > 0.5 | Distance from the Main Sequence |
| Change Amplification | Files changed per logical change | < 3 | > 8 | Cross-cutting coupling indicator |

### Coupling Collection (grep-based)

```bash
# Count imports per file (JavaScript/TypeScript)
grep -rn "^import " src/ | awk -F: '{print $1}' | sort | uniq -c | sort -rn | head -20

# Detect circular dependencies
npx madge --circular src/

# Count cross-module references
grep -rn "from '\.\./\.\." src/ | awk -F: '{print $1}' | sort | uniq -c | sort -rn
```

## SOLID at Scale

Principles applied at the **system/module level**, not just class level:

| Principle | Class Level | System Level | Violation Signal |
|-----------|------------|-------------|------------------|
| **SRP** | One reason to change | One module = one bounded context | Module changes for unrelated features |
| **OCP** | Closed for modification | Plugin/extension architecture | Core module modified for every new feature |
| **LSP** | Subtypes substitutable | Service contracts honored | Breaking API changes, version incompatibilities |
| **ISP** | No unused interfaces | Lean API surfaces | Clients importing large packages for 1 function |
| **DIP** | Depend on abstractions | Layer boundaries use interfaces | Direct imports across architectural layers |

## Anti-Pattern Catalog

| Anti-Pattern | Detection Signal | Root Cause | Severity | Fix Strategy |
|-------------|-----------------|------------|----------|-------------|
| **God Object** | >500 LOC, >10 public methods, >8 imports | Missing SRP decomposition | HIGH | Extract focused modules |
| **Distributed Monolith** | All services deploy together, shared DB | Premature microservices | CRITICAL | Consolidate or define boundaries |
| **Big Ball of Mud** | No clear module boundaries, everything imports everything | No architecture governance | CRITICAL | Introduce layered architecture |
| **Vendor Lock-in** | Platform constructs throughout | Missing abstraction layer | MEDIUM | Hexagonal ports + adapters |
| **Premature Abstraction** | Interfaces with 1 implementation, generic frameworks used once | YAGNI violation | MEDIUM | Inline until Rule of Three |
| **Circular Dependency** | A imports B imports C imports A | Missing dependency inversion | HIGH | DIP refactoring |

## Scalability Heuristics

| Scenario | What to Measure | Red Flag | Green Flag |
|----------|----------------|----------|------------|
| Component count x3 | Build time, validation time | O(n^2) or worse | O(n) or O(n log n) |
| Team size x3 | Merge conflicts, code ownership | Shared ownership, high contention | Clear boundaries, low overlap |
| Traffic x10 | Latency, throughput, failure modes | Single point of failure | Horizontal scaling points |
| Data volume x10 | Query performance, storage costs | Full table scans, no partitioning | Indexed, partitioned, cacheable |
| Feature count x3 | Cognitive load, onboarding time | Every feature touches every module | Feature isolation, bounded contexts |

## Refactoring Decision Tree

```
Is the current architecture causing measurable pain?
├─ No → Don't refactor (YAGNI)
├─ Yes → Can the pain be fixed incrementally?
│   ├─ Yes → Which strategy?
│   │   ├─ Single component → Extract + Replace
│   │   ├─ Cross-cutting concern → Strangler Fig
│   │   └─ Interface change → Branch by Abstraction
│   └─ No → Is a full rewrite justified?
│       ├─ < 6 months of effort → Consider rewrite
│       └─ > 6 months → Incremental migration with Feature Toggles
```

## Architecture Pattern Selection

| Pattern | Best For | Trade-off | Avoid When |
|---------|----------|-----------|------------|
| Modular Monolith | Default starting point | Deployment coupling | Proven independent scaling needs |
| Microservices | Independent deployment + scaling | Distributed complexity | < 3 teams, unclear boundaries |
| Event-Driven | Temporal decoupling | Eventual consistency | Strong consistency required |
| Hexagonal | Testability, port swapping | More interfaces | Short-lived prototypes |
| Plugin Architecture | Extension without modification | Plugin API maintenance | No extension use case |
| Pipe-and-Filter | Sequential data transformation | Linear only | Non-linear data flows |

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting architectural health signals with metric values against thresholds (e.g., "payment-service: Instability I=0.92, ALARM threshold >0.85 - maximally unstable")
- Using severity model: CRITICAL = BLOCK (Distributed Monolith, Big Ball of Mud detected), HIGH = WARN (God Object, circular dependency, coupling alarm), MEDIUM = INFO (premature abstraction, vendor lock-in risk)
- Providing evolution recommendations using the Refactoring Decision Tree (Strangler Fig, Branch by Abstraction, or inline fix)
- Including scalability heuristic assessments for growth scenarios (component x3, team x3, traffic x10) with O(n) analysis

## Worked Examples

### Example: Coupling Analysis Diagnosis

**Input**: `payment-service` module — 14 outgoing imports (Ce=14), 3 incoming dependencies (Ca=3).

**Analysis**: Compute instability: I = Ce/(Ca+Ce) = 14/17 = 0.82. This exceeds the healthy range upper bound (0.7), approaching the alarm zone (>0.85). High efferent coupling means this module depends on too many others — changes ripple outward.

**Output**: `payment-service: Instability I=0.82 (WARNING, healthy ≤0.7, alarm >0.85). Ce=14 approaching alarm (>15). Root cause: direct imports from 6 different domain modules. Fix: Apply DIP — introduce payment port interfaces, inject adapters. Expected Ce reduction: 14→5.`

### Example: Anti-Pattern Detection

**Input**: Three microservices (`orders`, `inventory`, `billing`) that must deploy together — shared database, synchronous calls between all three, single CI pipeline.

**Analysis**: Check anti-pattern catalog: shared DB + synchronous coupling + joint deployment = Distributed Monolith (CRITICAL severity).

**Output**: `CRITICAL: Distributed Monolith detected. Signals: shared DB (3 services), synchronous inter-service calls, single deployment pipeline. Root cause: premature microservices extraction without boundary definition. Fix strategy: Strangler Fig — consolidate into modular monolith first, then extract with clean API boundaries when independent scaling is proven necessary.`

## When to Load References

- **For full coupling metrics methodology with worked examples**: See `references/coupling-taxonomy.md`
- **For expanded anti-pattern detection with remediation playbooks**: See `references/anti-pattern-catalog.md`
- **For growth scenario templates and O(n) analysis**: See `references/scalability-heuristics.md`
- **For SOLID principles applied at module/system level**: See `references/solid-at-scale.md`
- **For refactor vs rewrite decision framework**: See `references/refactoring-decision-tree.md`
