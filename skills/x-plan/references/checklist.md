# x-plan — Plan Structure Protocol

Follow these steps to produce a complete, actionable plan.

## Phase Start

- [ ] Read WORKFLOW.md if it exists (prior analysis + design context)
- [ ] Confirm scope: what exactly are we building or changing?
- [ ] Identify the source of truth: analysis report, ADR, or user description

## Step 1 — Task Breakdown

Break the work into atomic tasks (each completable in one focused session).

For each task:
- **Subject**: one action verb + one outcome (e.g. "Add input validation to UserService")
- **Acceptance criteria**: observable, machine-verifiable condition
  - Good: "All unit tests in user-service.test.ts pass"
  - Bad: "Validation works correctly"
- **Files affected**: list the files this task touches
- **Dependencies**: does this task depend on another task completing first?

## Step 2 — Dependency Mapping

- Draw the dependency chain (which tasks must complete before others can start)
- Identify tasks that can run in parallel (no shared file edits, no sequential dependency)
- Flag tasks with circular dependencies — this is a planning error, redesign the breakdown

## Step 3 — Risk Assessment

For each HIGH-complexity task:
- What could go wrong?
- What is the concrete mitigation?
- Vague mitigations ("be careful", "monitor") are not acceptable — name the specific action

## Step 4 — Codebase Conventions

List the conventions the implementation must follow:
- Error handling pattern (which class or function?)
- Test framework and test file location convention
- Import / module conventions
- Any other patterns established in the codebase

## Completion Check

Before presenting the plan:
- [ ] Every task has measurable acceptance criteria?
- [ ] Critical files exist on disk (verify with a quick lookup)?
- [ ] Dependencies are explicit and cycle-free?
- [ ] Risk mitigations are concrete actions, not vague phrases?
- [ ] Read `references/approval-gate.md`?
