# V-Code Index — Unified Violation System

Merged from Mercure + Blackhole. Complete reference for agent compliance checking.

## Severity Model

| Severity | Action | Meaning |
|----------|--------|---------|
| **CRITICAL** | BLOCK | Must fix immediately. Cannot proceed. |
| **HIGH** | BLOCK | Must fix OR escalate with justification |
| **MEDIUM** | WARN | Flag to user. Document if deferring. |
| **LOW** | INFO | Note for awareness. No action required. |

---

## SOLID

| Code | Violation | Severity |
|------|-----------|----------|
| V-SOLID-01 | Single Responsibility: class with >1 reason to change | BLOCK |
| V-SOLID-02 | Open/Closed: modifying existing class for new behavior | BLOCK |
| V-SOLID-03 | Liskov Substitution: subclass breaks parent contract | BLOCK |
| V-SOLID-04 | Interface Segregation: fat interface forcing unused methods | WARN |
| V-SOLID-05 | Dependency Inversion: high-level depends on low-level | BLOCK |

## DRY

| Code | Violation | Severity |
|------|-----------|----------|
| V-DRY-01 | >10 line duplication | BLOCK |
| V-DRY-02 | 3-10 line duplication | WARN |
| V-DRY-03 | Magic values / literals left unnamed | WARN |
| V-DRY-04 | Copy-paste templates with trivial renames | WARN |

## KISS

| Code | Violation | Severity |
|------|-----------|----------|
| V-KISS-01 | Unnecessary abstraction | BLOCK |
| V-KISS-02 | Deep nesting (>4 levels) | WARN |
| V-KISS-03 | Empty scaffolding (no business logic) | WARN |

## YAGNI

| Code | Violation | Severity |
|------|-----------|----------|
| V-YAGNI-01 | Speculative features not in requirements | BLOCK |
| V-YAGNI-02 | Premature optimization without evidence | WARN |
| V-YAGNI-03 | Single-consumer abstraction | WARN |

## Design Patterns

| Code | Violation | Severity |
|------|-----------|----------|
| V-PAT-01 | God Object (7+ responsibilities or >300 lines) | BLOCK |
| V-PAT-02 | Circular dependency | BLOCK |
| V-PAT-03 | Missing error-handling / bare catch | BLOCK |
| V-PAT-04 | Anti-pattern usage (singleton abuse, service locator) | WARN |

## Testing

| Code | Violation | Severity |
|------|-----------|----------|
| V-TEST-01 | New logic without tests | BLOCK |
| V-TEST-02 | Production code before test (TDD violation) | BLOCK |
| V-TEST-05 | Meaningless assertions | WARN |
| V-TEST-09 | Coverage regression on changed files | BLOCK |
| V-TEST-10 | Test integrity (skip markers, removed assertions) | BLOCK |

## Security

| Code | Violation | Severity |
|------|-----------|----------|
| V-SEC-01 | Injection vulnerability | BLOCK |
| V-SEC-02 | Auth bypass | BLOCK |
| V-SEC-03 | Hardcoded secrets / API keys | BLOCK |
| V-SEC-04 | XSS vulnerability | BLOCK |
| V-SEC-06 | Security finding without concrete attack scenario | BLOCK |
| V-SEC-07 | Adversarial re-verification needed | WARN |
| V-SEC-08 | Security artifact must validate | BLOCK |
| V-SEC-09 | Local-analyze confidence-boost raise-only | BLOCK |
| V-SEC-10 | False-positive verification for grep matches | WARN |
| V-SEC-11 | Sensitive-filename staged before commit | BLOCK |

## Integration

| Code | Violation | Severity |
|------|-----------|----------|
| V-INT-01 | Convention divergence from codebase | WARN |
| V-INT-02 | Reimplements existing utility | BLOCK |
| V-INT-03 | Third variant of same pattern | WARN |
| V-INT-04 | Pattern inconsistency | WARN |

## Fix Quality

| Code | Violation | Severity |
|------|-----------|----------|
| V-FIX-01 | Fix addresses symptom, not root cause | BLOCK |

## Pareto

| Code | Violation | Severity |
|------|-----------|----------|
| V-PARETO-01 | >3× complexity for marginal gain | WARN |
| V-PARETO-02 | Improvement discovery label needed | WARN |
| V-PARETO-03 | Filing gate: Priority < 30 | BLOCK |

## Documentation

| Code | Violation | Severity |
|------|-----------|----------|
| V-DOC-01 | Missing docstring on public symbol | WARN |
| V-DOC-03 | Broken internal doc link | WARN |
| V-DOC-04 | Doc-tree structural staleness | BLOCK |
| V-DOC-05 | Rationale duplicated across copies | WARN |
| V-DOC-06 | Issue/PR numbers in source comments | WARN |
| V-DOC-07 | Comment-to-code ratio >40% | WARN |
| V-DOCFACT-01 | Documentation factual accuracy | WARN |
| V-DOCSYNC-01 | Public-API and design docs in same PR | BLOCK |

## Doc Governance

| Code | Violation | Severity |
|------|-----------|----------|
| V-DOC-GOV-01 | Duplicate doc creation | WARN |
| V-DOC-GOV-02 | Missing lifecycle frontmatter | WARN |
| V-DOC-GOV-03 | Date-stamped filename | WARN |
| V-DOC-GOV-04 | Supersede-on-overwrite skipped | WARN |

## Companion Files

| Code | Violation | Severity |
|------|-----------|----------|
| V-ADA-01 | ARCHITECTURE.md absent for architectural changes | BLOCK |
| V-ADA-02 | ADR INDEX row missing | WARN |
| V-ADA-03 | DESIGN.md absent for frontend | WARN |
| V-ADA-04 | DESIGN.md token staleness | WARN |
| V-ADA-05 | AGENTS.md absent | WARN |
| V-ADA-06 | AGENTS.md unindexed | WARN |
| V-ADA-07 | Superseded ADR lifecycle gap | WARN |

## Scope

| Code | Violation | Severity |
|------|-----------|----------|
| V-SCOPE-01 | Refactoring untouched code | WARN |
| V-SCOPE-02 | Touch-paths violation | WARN |
| V-SCOPE-03 | Missing blast-radius section | WARN |

## Branch & Git

| Code | Violation | Severity |
|------|-----------|----------|
| V-BRANCH-01 | Force-push to protected branch | BLOCK |
| V-BRANCH-02 | Direct commit to main | BLOCK |
| V-BRANCH-03 | Wrong branch name | WARN |
| V-WORKTREE-01 | Worktree leak | BLOCK |
| V-GIT-01 | PR without Closes #N | BLOCK |
| V-GITFIX-01 | Delegating fix to external bot | BLOCK |

## API & Architecture

| Code | Violation | Severity |
|------|-----------|----------|
| V-API-01 | API contract drift | BLOCK |
| V-ARCH-01 | Architecture decision without ADR | BLOCK |

## Performance

| Code | Violation | Severity |
|------|-----------|----------|
| V-PERF-01 | N+1 queries, unindexed sorts, sync I/O | BLOCK |
| V-PERF-02 | Performance regression | WARN |

## Config

| Code | Violation | Severity |
|------|-----------|----------|
| V-CONFIG-01 | Config key naming convention violation | WARN |
| V-CONFIG-02 | Config key registration missing | WARN |

## Threat Model

| Code | Violation | Severity |
|------|-----------|----------|
| V-THREAT-01 | Quick-track without threat screen | BLOCK |
| V-THREAT-02 | High/Critical threat not mitigated | BLOCK |
| V-THREAT-03 | Missing STRIDE categories | WARN |

## CI & Merge

| Code | Violation | Severity |
|------|-----------|----------|
| V-CI-01 | Required CI check failed | BLOCK |
| V-MERGE-01 | Merge gate violation | BLOCK |
| V-MERGE-02 | Semantic merge conflict | WARN |

## Hunt (Proactive Discovery)

| Code | Violation | Severity |
|------|-----------|----------|
| V-HUNT-01 | Filed without CONFIRMED verification | BLOCK |
| V-HUNT-02 | Exceeded per-wave cap | WARN |

## Owner Rulings

| Code | Violation | Severity |
|------|-----------|----------|
| V-RULE-01 | Diff violates active owner ruling | BLOCK |

## Extension Tax

| Trigger | Requirement |
|---------|-------------|
| New `##` section in skill | PR must include `## Extension Tax Declaration` |
| New argument-hint or V-code reference | PR must include `## Extension Tax Declaration` |
| Step >80 LOC | PR must include `## Extension Tax Declaration` |
| Step grows >50% LOC in PR | PR must include `## Extension Tax Declaration` |
| Step contains 4+ conceptual gate patterns | PR must include `## Extension Tax Declaration` |

---

**Review Approval Hard Gate**: Zero CRITICAL violations. Zero HIGH without explicit exception. All MEDIUM flagged.
