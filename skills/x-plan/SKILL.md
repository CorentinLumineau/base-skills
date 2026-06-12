---
name: x-plan
description: >
  Create an implementation plan with task breakdown, acceptance criteria, and dependency
  mapping before writing any code. Use when the analysis and design phases are complete
  (x-plan, plan, roadmap, task breakdown, before implement, what are the steps,
  implementation plan, how to build this, plan the implementation).
compatibility: >
  Designed for any AI agent that can follow multi-step procedural instructions.
  Requires file write access for WORKFLOW.md and the plan artifact.
  Compatible with all agentskills.io clients.
metadata:
  workflow: apex
  phase: plan
  position: "3/6"
  approval_required: before-implement
license: MIT
---

# x-plan — Implementation Plan (APEX Phase 3/6)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Gather requirements → structure tasks → present plan → gate before implementation.

## Key Steps

1. If WORKFLOW.md exists, read it for analysis and design context
2. Read `references/checklist.md` — follow the plan structure protocol
3. Break the work into atomic tasks with measurable acceptance criteria
4. Map task dependencies and identify parallel work
5. Read `references/output-template.md` when writing the plan artifact
6. **Read `references/approval-gate.md` before presenting the plan to the user**

## Workflow Navigation

You just completed the **Plan** phase (3/6).

**STOP — APPROVAL REQUIRED before proceeding to Implement.**
Read [references/approval-gate.md](references/approval-gate.md) for the exact
user message and gate conditions.

On approval: copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:
> "Plan approved. Invoke `x-implement` to begin implementation."

## Gotchas

- Don't plan more than the user asked for — scope the plan to the current task only
- Every task must have measurable acceptance criteria, not just a title ("tests pass" is good;
  "works correctly" is not)
- Don't start implementation during planning — planning is read-only except for the plan artifact
- If the plan reveals design gaps, return to x-design rather than resolving them in the plan
