---
name: x-fix
description: >
  Quick targeted fix for an identified bug, followed by a commit approval gate.
  Verifies the root cause before writing code and presents a fix summary for approval.
  Use when you have a specific known bug to fix
  (x-fix, fix bug, oneshot fix, targeted patch, quick fix, fix this error,
  repair, correct the bug, there is a bug in, fix the issue).
compatibility: >
  Designed for any AI agent with file read/write and command execution access.
  Requires test runner access. Compatible with all agentskills.io clients.
metadata:
  workflow: oneshot
  phase: fix
  position: "1/2"
  approval_required: before-commit
---

# x-fix — Targeted Fix (ONESHOT Phase 1/2)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Identify root cause → write fix → add regression test → present for approval.

## Key Steps

1. Read `references/checklist.md` — verify root cause before writing any code
2. **State the root cause in one sentence** before writing the first line of code
3. Write the minimum fix that corrects the root cause (no scope creep)
4. Add a regression test that would have caught this bug
5. Run the full test suite — all must pass
6. **Read `references/approval-gate.md` before presenting the fix to the user**

→ See skill-root-cause for root cause analysis protocol.
→ See skill-error-handling for tool failure classification during the fix.

## Workflow Navigation

You just completed the **Fix** phase (1/2).

**STOP — APPROVAL REQUIRED before committing.**
Read [references/approval-gate.md](references/approval-gate.md) for the exact
user message and gate conditions.

On approval: copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:
> "Fix approved. Invoke `git-commit` to commit."

## Gotchas

- Don't fix the symptom — state the root cause before writing the first line of code
- Don't fix unrelated issues in the same commit (ONESHOT scope discipline)
- If the fix requires >3 files or architectural changes, upgrade to APEX instead
- Do not skip the regression test — it proves the bug is fixed and prevents recurrence
