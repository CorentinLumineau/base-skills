---
name: x-implement
description: >
  Implement the planned changes following test-driven development (TDD).
  Runs red-green-refactor cycles and verifies all tests pass before marking complete.
  Use when the plan is approved and you are ready to write code
  (x-implement, implement, build, code, write the code, start coding, execute the plan,
  build the feature, begin implementation).
compatibility: >
  Designed for any AI agent with file read/write and command execution access.
  Requires test runner access for TDD verification. Compatible with all agentskills.io clients.
metadata:
  workflow: apex
  phase: implement
  position: "4/6"
license: MIT
---

# x-implement — TDD Implementation (APEX Phase 4/6)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Read the plan → implement task-by-task using TDD → verify all acceptance criteria.

## Key Steps

1. If WORKFLOW.md exists, read it for plan context and prior summaries
2. Read `references/checklist.md` — follow the TDD protocol
3. For each task in the plan:
   a. Write the failing test first (red)
   b. Write minimum code to make it pass (green)
   c. Refactor if needed (refactor) — re-run test to confirm still green
4. After all tasks: read `references/output-template.md`, verify completion criteria
5. Read `references/approval-gate.md` — pass the completion gate before chaining

→ See skill-test-discipline for TDD mandate and testing pyramid (70/20/10).
→ See skill-error-handling for tool failure classification during implementation.

## Workflow Navigation

You just completed the **Implement** phase (4/6). No user approval gate — proceed directly
once the completion gate passes.

Copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:
> "Implementation complete. Invoke `x-review` for the quality gate."

## Gotchas

- Do not skip TDD because the change seems small — write the test first, always
- Do not mark implementation complete without running the full test suite
- If a task reveals a design gap, stop and return to x-plan — do not invent design decisions
- Read WORKFLOW.md at start — don't re-derive context from the conversation history
