<!-- ported from mercure-plugin/skills/x-design/ -->
---
name: x-design
description: >
  Produce an Architectural Decision Record (ADR) with trade-off analysis for significant
  design choices. Use before planning when an architectural decision is needed — choosing
  between approaches, evaluating trade-offs, or documenting design rationale.
  (x-design, design, architecture, ADR, trade-offs, decide approach, architectural decision,
  choose between options, design the system, what architecture should I use).
license: MIT
compatibility: >
  Designed for any AI agent that can follow multi-step procedural instructions.
  Requires file write access for the ADR artifact and WORKFLOW.md.
  Compatible with all agentskills.io clients.
metadata:
  workflow: apex
  phase: design
  position: "2/6"
  approval_required: before-plan
allowed-tools: Read Write Grep Glob Bash
---

# x-design — Architectural Decision (APEX Phase 2/6)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Explore options → produce trade-off matrix → write ADR → gate before planning.

## Key Steps

1. If WORKFLOW.md exists, read it for analyze-phase findings
2. Read `references/checklist.md` — follow the ADR construction protocol
3. Enumerate 2+ alternatives; never present only the chosen option
4. Score alternatives on a trade-off matrix (read `references/output-template.md`)
5. Write the ADR to `documentation/decisions/ADR-{NNN}-{slug}.md`
6. **Read `references/approval-gate.md` before presenting the decision to the user**

→ See `skill-hard-choice` for the decision record format.
→ See `skill-design-challenge` for adversarial critique of proposals.

## Workflow Navigation

You just completed the **Design** phase (2/6).

**STOP — APPROVAL REQUIRED before proceeding to Plan.**
Read [references/approval-gate.md](references/approval-gate.md) for the exact
user message and gate conditions.

On approval: copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:
> "Architecture decided. Invoke `x-plan` to break down the implementation."

## Gotchas

- Don't design before reading WORKFLOW.md — x-analyze findings determine what to design
- Don't write an ADR with only the chosen option — a trade-off table with 1 row is not an ADR
- Don't let scope creep into planning — the ADR captures *what* and *why*, not *how* (tasks)
- Do NOT write WORKFLOW.md before the user approves the architectural direction
