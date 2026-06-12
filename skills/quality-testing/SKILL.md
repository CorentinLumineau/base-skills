---
name: quality-testing
description: >
  Use when writing tests, improving coverage, or setting up quality gates. Covers
  testing pyramid, TDD patterns, and quality gate checks for comprehensive
  validation. Do NOT use for debugging (use quality-debugging-performance) or
  observability setup (use quality-observability).
allowed-tools: Read Grep Glob
metadata:
  type: knowledge
  license: MIT
  compatibility: always-on
---

<!-- ported from mercure-plugin/skills/quality-testing/ -->

# Testing

Comprehensive test strategy following the testing pyramid, with integrated quality gate validation.

## Enforcement Definitions

Violation categories used by workflow skills to enforce testing standards.

**Severity model**: CRITICAL/HIGH = BLOCK (must fix), MEDIUM = WARN (flag to user), LOW = INFO (note).

### Testing Violations

| Violation | Severity | Detection |
|-----------|----------|-----------|
| No tests for new production code | CRITICAL | New functions/classes/modules without corresponding test files |
| Tests written after production code (TDD violation) | HIGH | Production code committed before test code in same changeset |
| Coverage below 80% on changed files | HIGH | Line coverage on modified/new files under threshold |
| Pyramid imbalance (unit tests <60% of new tests) | MEDIUM | Disproportionate integration/E2E tests vs unit tests |
| Test without assertions | CRITICAL | Test functions with no assert/expect/verify calls |
| Flaky test introduced | CRITICAL | Non-deterministic test (passes/fails inconsistently) |
| Mocking internal implementation details | MEDIUM | Mocking private methods, testing implementation not behavior |
| No eval definition before AI-assisted implementation | MEDIUM | AI-generated code without corresponding .claude/evals/ entry |
| Test coverage tool misconfigured (false pass) | HIGH | Coverage report shows >80% but excludes generated or test files |

### TDD Mandate

**TDD is MANDATORY.** The Red-Green-Refactor cycle is non-negotiable for all new code.

```
RED -> GREEN -> REFACTOR
```

Skipping TDD is a HIGH (BLOCK) violation. Author the failing test FIRST, then make it pass.

## Testing Pyramid (70/20/10)

| Type | Percentage | Focus | Speed |
|------|------------|-------|-------|
| Unit | 70% | Business logic, pure functions | Fast |
| Integration | 20% | Service interactions, APIs | Medium |
| E2E | 10% | Critical user flows | Slow |

## Unit Tests (70%)

**What to test**: Pure functions, business logic, data transformations, edge cases, error handling.

**Characteristics**:
- Fast (<10ms each)
- Isolated (no external dependencies)
- Deterministic (same input = same output)

## Integration Tests (20%)

**What to test**: API endpoints, database operations, service interactions, external integrations (mocked).

**Characteristics**:
- Test real component interactions
- Use test databases
- Mock external services

## E2E Tests (10%)

**What to test**: Critical user journeys, happy paths, payment flows, authentication.

**Characteristics**:
- Slow but high confidence
- Cover complete flows
- Real browser/environment

## TDD Cycle (Red-Green-Refactor)

```
1. RED: Write failing test
2. GREEN: Write minimal code to pass
3. REFACTOR: Improve code, keep tests green
4. REPEAT
```

## Eval-Driven Development (EDD)

EDD extends TDD for AI-assisted workflows. Create eval definitions before AI generates code.

```
1. DEFINE: Write eval criteria (.claude/evals/)
2. RED: Write failing test (TDD)
3. GREEN: AI implements, run evals + tests
4. REFACTOR: Improve while keeping evals green
```

Skipping EDD for AI-assisted code is a MEDIUM (WARN) violation.

## Iterative Fix Loop

When tests fail:
1. Run test suite
2. Classify errors by type/root cause
3. Fix error group (start with root cause)
4. Re-run tests
5. Repeat until 100% passing

## Quality Gates

See `references/quality-gates.md` for gate categories and `references/quality-gate-protocol.md` for the enforcement protocol.

## Test Quality Checklist

- [ ] Tests follow 70/20/10 distribution
- [ ] Each test has single assertion focus
- [ ] Tests are independent (no shared state)
- [ ] Test names describe behavior
- [ ] No test.skip() in codebase
- [ ] Regression tests for fixed bugs
- [ ] Coverage targets met (80%+)
- [ ] Type check passes
- [ ] No lint errors
- [ ] Build succeeds

## Anti-Patterns

| Anti-pattern | Fix |
|--------------|-----|
| Testing implementation | Test behavior |
| Skipping tests | Fix or remove |
| Shared test state | Isolate tests |
| Testing trivial code | Focus on logic |
| No assertions | Add meaningful checks |

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting test violations with file path, test name, and specific evidence
- Using severity model: CRITICAL = BLOCK (no tests for new code, test without assertions, flaky test), HIGH = BLOCK (TDD violation, coverage below 80%), MEDIUM = WARN (pyramid imbalance, mocking implementation details)
- Providing TDD compliance assessment: Red-Green-Refactor cycle adherence per changeset
- Summarizing coverage metrics per file with pyramid distribution (target: 70% unit / 20% integration / 10% E2E)

## When to Load References

- **For TDD patterns**: See `references/tdd-patterns.md`
- **For coverage strategies**: See `references/coverage.md`
- **For mocking patterns**: See `references/mocking.md`
- **For testing pyramid details**: See `references/pyramid.md`
- **For quality gates**: See `references/quality-gates.md`
- **For quality gate protocol**: See `references/quality-gate-protocol.md`
- **For eval-driven development patterns**: See `references/eval-driven-development.md`
