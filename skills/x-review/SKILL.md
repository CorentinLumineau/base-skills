---
name: x-review
description: >
  Post-implementation quality gate. Reviews changed code for SOLID violations, DRY,
  KISS, test coverage, and security red flags. Blocks on CRITICAL and HIGH findings.
  Use after implementation is complete and before committing
  (x-review, review, quality check, code review, before commit, gate, quality gate,
  verify implementation, review the changes).
compatibility: >
  Designed for any AI agent with file read access and diff context.
  Compatible with all agentskills.io clients.
metadata:
  workflow: apex
  phase: review
  position: "5/6"
---

# x-review — Quality Gate (APEX Phase 5/6)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Review changed files → collect findings → apply the completion gate → proceed or loop.

## Key Steps

1. If WORKFLOW.md exists, read it for implementation context (what changed)
2. Read `references/checklist.md` — follow the quality audit protocol for each changed file
3. Collect findings with severity (CRITICAL / HIGH / MEDIUM / LOW)
4. Read `references/output-template.md` when writing the review report
5. **Read `references/approval-gate.md` — apply the completion gate before chaining**

→ See skill-solid-gate for SOLID violation severity definitions.
→ See skill-anti-slop for boilerplate and anti-pattern detection.
→ See skill-verification-evidence for evidence-based completion claims.

## Workflow Navigation

No user approval gate. Proceed directly when the completion gate passes.

Copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:
> "Review complete. Invoke `git-commit` to commit the changes."

If CRITICAL or HIGH findings are found: loop back to x-implement to fix them.
Re-run x-review after fixes are applied.

## Gotchas

- Don't approve code with CRITICAL violations "because the change is small"
- Scope: only review the changed files, not the entire codebase
- "Overall the code looks good" is not a review — the checklist is the review
- If you loop back to x-implement, create a new review report for the second pass
