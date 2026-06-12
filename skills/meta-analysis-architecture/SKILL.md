---
name: meta-analysis-architecture
description: >
  Use when making architectural decisions, prioritizing work, or creating ADRs/RFCs.
  Covers Pareto analysis, trade-off frameworks, priority matrix (P1–P4), ADR/RFC processes,
  and software architecture pattern selection.
  Do NOT use for architectural retrospectives and health audits (use meta-rearchitect)
  or persuasion/enforcement psychology (use meta-persuasion-principles).
  (architectural decision, ADR, RFC, trade-off analysis, Pareto prioritization, architecture
  pattern, modular monolith, microservices, CQRS, build vs buy, priority matrix, quick wins)
license: MIT
compatibility: >
  Always-on knowledge skill. No special agent primitives required. Works with any agent
  that can reason about architecture and prioritization decisions.
allowed-tools: Read Grep Glob
---

<!-- ported from mercure-plugin/skills/meta-analysis-architecture/ -->

# Analysis & Architecture

Prioritization frameworks, decision-making processes, and software architecture patterns.

## Quick Reference (80/20)

| Domain | Key Concepts | When to Apply |
|--------|-------------|---------------|
| Pareto 80/20 | Impact ranking, effort-to-value ratio, quick wins | Any planning, analysis, or prioritization task |
| Priority Matrix | P1-P4 classification by impact and effort | Backlog grooming, sprint planning |
| ADRs | Status, context, decision, consequences | Architecture changes, technology choices |
| RFCs | Problem, proposal, alternatives, risks | Large changes needing broad input (>2 weeks or cross-team) |
| Trade-off Analysis | Dimensions, options scoring, weighted criteria | Technology evaluation, build vs buy |

## Enforcement Criteria

Violations that agents should detect and flag:

| Violation | Severity | Example |
|-----------|----------|---------|
| Over-engineered solution | HIGH | >3x complexity for marginal improvement |
| Missing prioritization in output | MEDIUM | Analysis without impact ranking |
| Scope creep beyond 80/20 focus | MEDIUM | Implementing low-value items before high-value |

### Anti-Patterns
- Exhaustive analysis when focused analysis suffices
- Equal treatment of all items without impact ranking
- Building comprehensive solutions when targeted ones would deliver 80% of value

### Pareto-Compliant Output
Analysis and planning outputs SHOULD include:
- Impact ranking (Critical > High > Medium > Low)
- Effort-to-value ratio for each item
- Clear "Quick Wins" identification (high impact, low effort)
- Explicit deprioritization of low-value items

## Priority Matrix

| Priority | Impact | Effort | Action |
|----------|--------|--------|--------|
| P1 | High | Low | Do first |
| P2 | High | High | Plan carefully |
| P3 | Low | Low | Quick wins |
| P4 | Low | High | Deprioritize |

## Decision Frameworks

### When to Document Decisions

| Scenario | Documentation |
|----------|---------------|
| Architecture change | ADR required |
| Technology choice | ADR recommended |
| Large cross-team change | RFC required |
| Process change | RFC or ADR |
| Bug fix | None needed |
| Feature implementation | Context in PR |

### ADR (Architecture Decision Record)

```markdown
# ADR-001: [Title]

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
What is the issue motivating this decision?

## Decision
What is the change being proposed?

## Consequences
What becomes easier or harder?
```

**Best Practices**: One decision per ADR, number sequentially, keep in version control, link related ADRs.

### RFC (Request for Comments)

Use for larger changes needing broad input (>2 weeks work or cross-team impact).

**Timeline**: 1 week draft, 2 weeks review, 1 week final comment. Approval requires 2+ reviewers with no blocking concerns.

## Trade-off Analysis

| Dimension | Trade-off |
|-----------|-----------|
| Speed vs Quality | Ship fast vs polish |
| Build vs Buy | Control vs time-to-market |
| Flexibility vs Simplicity | Generic vs specific |
| Consistency vs Innovation | Standard vs new approach |

## Architecture Patterns (Summary)

| Pattern | Best For | Team Size |
|---------|----------|-----------|
| Modular Monolith | Most startups, small teams | 1-10 |
| Microservices | Large orgs, independent deployment | 10+ per service |
| Event-Driven | Async workflows, decoupling | 5+ |
| CQRS | Read/write asymmetry (>10:1 ratio) | 5+ |
| Hexagonal | Testability, port swapping | 3+ |
| Clean Architecture | Long-lived enterprise apps | 5+ |
| MCP 3-Primitive | AI agent tool/resource/prompt separation | Any |

**Default**: Start with Modular Monolith, extract later.

## Analysis Framework

1. **Define the Problem** — What exactly needs to be solved? Who is affected?
2. **Gather Data** — Current metrics, user feedback, technical constraints
3. **Identify Options** — List all approaches, include "do nothing"
4. **Evaluate Trade-offs** — Pros, cons, risk for each option
5. **Decide and Document** — Clear recommendation, reasoning, rollback plan

## Quick Wins Identification

Criteria for quick wins:
- [ ] Low implementation effort
- [ ] High user impact
- [ ] Low risk of regression
- [ ] Independent of other work
- [ ] Clear success criteria

## Gate

Before finalizing any architecture decision:
- [ ] Problem clearly defined
- [ ] Stakeholders identified
- [ ] Options listed (including "do nothing")
- [ ] Trade-offs evaluated with weighted criteria
- [ ] Decision documented (ADR/RFC as appropriate)
- [ ] Architecture matches team size and skills

## Output Format

When referenced during a workflow:
- Rank all findings by impact using the Priority Matrix (P1–P4) with effort-to-value ratios
- Severity model: CRITICAL = architecture decision without ADR; HIGH = over-engineered solution or missing prioritization; MEDIUM = scope creep risk or undocumented trade-off
- Identify Quick Wins explicitly (high impact, low effort items)
- Provide Pareto-compliant summaries: top 20% of findings delivering 80% of improvement value highlighted first

## Worked Example

**Input**: 6 audit findings: missing input validation (3 endpoints), outdated dependency (1 lib), no rate limiting, inconsistent error formats, missing API docs, unused imports.

**Output**:

| # | Finding | Impact | Effort | Priority | Action |
|---|---------|--------|--------|----------|--------|
| 1 | Missing input validation | High (security) | Low (3 endpoints) | **P1** | Fix immediately |
| 2 | No rate limiting | High (availability) | Medium | **P2** | Plan sprint |
| 3 | Outdated dependency | Medium (CVE risk) | Low (1 lib) | **P1** | Fix immediately |
| 4 | Inconsistent error formats | Low | Medium | **P4** | Deprioritize |
| 5 | Missing API docs | Low | High | **P4** | Deprioritize |
| 6 | Unused imports | Low | Low | **P3** | Quick win |

**Quick Wins** (P1): Items 1, 3 — high impact, low effort, deliver 80% of security improvement.
