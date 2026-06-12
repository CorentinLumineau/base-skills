# Quality Gates Protocol

<!-- ported from mercure-plugin/skills/quality-testing/ -->

Quality gates are mandatory validation checkpoints ensuring code meets quality standards before proceeding to the next phase.

## Gate Categories

### Standard Gates (All Validation Commands)

| Gate | Tool/Command | Threshold | Blocking |
|------|--------------|-----------|----------|
| Type Checking | `tsc --noEmit` / `mypy` / `go vet` | 0 errors | Yes |
| Linting | `eslint` / `golint` / `ruff` | 0 errors | Yes |
| Build | `make build` / `npm run build` | Success | Yes |

### Extended Gates (Implementation Commands)

| Gate | Tool/Command | Threshold | Blocking |
|------|--------------|-----------|----------|
| Unit Tests | `jest` / `pytest` / `go test` | All pass | Yes |
| Coverage | Coverage tool | 80%+ changed files | Yes |
| SOLID Validation | Code review | No critical violations | Yes |

### Testing Pyramid Gates

| Gate | Distribution | Target |
|------|--------------|--------|
| Unit Tests | 70% ±10% | Fast, isolated tests |
| Integration Tests | 20% ±10% | Service interaction tests |
| E2E Tests | 10% ±5% | Full workflow tests |

### Documentation Gates

| Gate | Check | Threshold | Blocking |
|------|-------|-----------|----------|
| API Sync | reference/ updated for public API changes | Matches code | Warning |
| Architecture Sync | implementation/ updated for arch changes | Matches changes | Warning |
| CHANGELOG | Updated for breaking changes | Entry exists | Warning |

## Execution Order (Fail Fast)

```
1. Type Checking (fast — catches obvious issues)
   FAIL -> Stop, report type errors
   PASS
2. Linting (fast — style/quality)
   FAIL -> Stop, report lint errors
   PASS
3. Build (medium — integration)
   FAIL -> Stop, report build errors
   PASS
4. Unit Tests (medium — correctness)
   FAIL -> Stop, report test failures
   PASS
5. Coverage (medium — completeness)
   FAIL -> Warning if below threshold, continue
   PASS
6. SOLID Validation (slower — design quality)
   FAIL -> Warning for non-critical, stop for critical
   PASS
7. Documentation Sync (fast — check only)
   WARNING -> Log warning, continue
   COMPLETE
```

## Gate Configuration Per Command

| Command | Standard | Extended | Testing | Documentation |
|---------|----------|----------|---------|---------------|
| verify | All | All | All | Check only |
| review | All | Skip | Assumes passed | Check only |
| commit | All | Skip | Assumes passed | Check only |
| implement | All | All | All | Generate |
| fix | All | Related | Related | Skip |

## Output Format

### Success

```
Quality Gates: ALL PASSED

[1/6] Type Checking.......... PASS (0 errors)
[2/6] Linting................ PASS (0 errors, 2 warnings)
[3/6] Build.................. PASS (12.3s)
[4/6] Unit Tests (127)....... PASS
[5/6] Coverage............... PASS (96.2%)
[6/6] SOLID Validation....... PASS (no violations)

Duration: 45.2s
```

### Failure

```
Quality Gates: FAILED

[1/6] Type Checking.......... FAIL (2 errors)
      src/services/UserService.ts:45
         Type 'string' is not assignable to type 'User'
[2/6] Linting................ SKIPPED (blocked by type errors)
[3/6] Build.................. SKIPPED
...

Fix the 2 type errors and re-run validation.
```

## SOLID Validation Checklist

| Principle | Check |
|-----------|-------|
| SRP | Each class has ONE reason to change, <300 lines, <15 methods |
| OCP | Extension via interfaces, not modification |
| LSP | Subclasses can replace parents |
| ISP | Interfaces have <5 methods, no empty implementations |
| DIP | Dependencies injected, not instantiated |

## Failure Handling

| Failure Type | Action |
|--------------|--------|
| Type errors | Stop, require fix |
| Lint errors | Stop, require fix |
| Build failure | Stop, require fix |
| Test failures | Stop, require fix |
| Coverage below threshold | Warning, allow continue |
| SOLID violation (critical) | Stop, require fix |
| SOLID violation (warning) | Warning, allow continue |
| Doc sync needed | Warning, suggest doc update |

Gates should NEVER be skipped except when the user explicitly requests it with a clear reason.
