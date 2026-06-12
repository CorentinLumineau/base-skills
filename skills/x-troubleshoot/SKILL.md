---
name: x-troubleshoot
description: >
  Systematically investigate errors with unclear root causes using hypothesis-driven
  diagnostics. Use when facing an error where the root cause is unknown and needs
  investigation before any fix can be applied.
  (x-troubleshoot, troubleshoot, debug, investigate, unknown error, why is this happening,
  trace the bug, diagnose, something is broken and I don't know why, root cause unknown).
license: MIT
compatibility: >
  Designed for any AI agent with file read access and command execution for reproduction.
  Compatible with all agentskills.io clients.
metadata:
  workflow: debug
  phase: troubleshoot
  position: "1/2"
allowed-tools: Read Grep Glob Bash
---

<!-- ported from mercure-plugin/skills/x-troubleshoot/ -->

# x-troubleshoot — Hypothesis-Driven Diagnosis (DEBUG Phase 1/2)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Reproduce the issue → form hypotheses → test each → confirm root cause → hand off to fix.

## Key Steps

1. If WORKFLOW.md exists, read it for prior context
2. Read `references/checklist.md` — follow the hypothesis testing protocol
3. Gather symptoms: exact error message, stack trace, reproduction steps, recent changes
4. Generate at least 3 hypotheses ranked by probability
5. Test each hypothesis with a minimal targeted test — confirm or refute with evidence
6. **State the confirmed root cause in one sentence before writing anything else**
7. Read `references/output-template.md` when writing the diagnosis report

→ See `skill-root-cause` for hypothesis validation protocol.
→ See `skill-error-handling` for tool failure classification during investigation.

## Workflow Navigation

You just completed the **Troubleshoot** phase (1/2). No user approval gate.

After confirming root cause, copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:

- If root cause is clear and fix is small (1–3 files): "Invoke `x-fix` to apply the fix."
- If fix requires multi-file changes or architectural decisions: "Invoke `x-plan` then
  `x-implement` for a structured implementation (APEX workflow)."

## Gotchas

- Don't write any fix code before stating the confirmed root cause — symptom chasing produces recurrence
- Don't skip reproduction — a fix without a reproducible test case cannot be verified as correct
- Don't upgrade to APEX prematurely — complete diagnosis first; only escalate if the fix is truly multi-file
- Do NOT write WORKFLOW.md before the root cause is confirmed with evidence cited
