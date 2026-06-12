# x-implement — Implementation Checklist

Load trigger: Read this file at the start of each implementation task.

## Per-Task TDD Cycle

For each task in the plan:

### Red Phase — Write the failing test first
- [ ] Identify the acceptance criterion for this task
- [ ] Write a test that FAILS because the code does not exist yet
- [ ] Confirm the test fails before writing any production code
- [ ] → See skill-test-discipline for TDD mandate and pyramid shape

### Green Phase — Write minimum code to pass
- [ ] Write the minimum implementation to make the test pass
- [ ] Do not over-engineer — just satisfy the acceptance criterion
- [ ] Run the test: confirm it passes

### Refactor Phase — Clean up
- [ ] Remove duplication introduced during Green phase
- [ ] Apply naming improvements
- [ ] Run the full test suite: all tests pass
- [ ] → See skill-error-handling for how to handle tool failures during implementation

## After All Tasks Complete

### Full Verification
- [ ] Run full test suite (not just the new tests)
- [ ] Run lint if configured (`eslint .`, `ruff check .`, `golint ./...`, or equivalent)
- [ ] Run type checker if configured (`tsc --noEmit`, `mypy`, or equivalent)
- [ ] All checks green — no regressions

### Plan Compliance
- [ ] Every task acceptance criterion observable and met
- [ ] All files listed in plan's "Files Affected" section created or modified
- [ ] No extra files created beyond plan scope (YAGNI)
- [ ] Codebase conventions from plan followed

## Completion Gate

Before writing WORKFLOW.md and chaining to x-review:

- [ ] Tests: full suite green (quote the test runner output)
- [ ] Lint: clean or known pre-existing warnings only
- [ ] Typecheck: no new type errors
- [ ] Acceptance criteria: every task criterion met
- [ ] No TODOs left in delivered code

If any check fails: fix the failure before proceeding.

See `references/output-template.md` for the evidence format to produce at completion.
