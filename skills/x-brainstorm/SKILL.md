<!-- ported from mercure-plugin/skills/x-brainstorm/ -->
---
name: x-brainstorm
description: >
  Structured exploration of a vague idea from multiple angles, producing a prioritized
  concept document. Use when starting from a vague idea before any design or planning.
  (x-brainstorm, brainstorm, explore, ideate, I have an idea, how should I approach,
  what should I build, discover requirements, think through options, early-stage exploration).
license: MIT
compatibility: >
  Designed for any AI agent that can follow multi-step procedural instructions.
  Requires file write access for the brainstorm output document and WORKFLOW.md.
  Compatible with all agentskills.io clients.
metadata:
  workflow: brainstorm
  phase: brainstorm
  position: "1/3"
allowed-tools: Read Write Grep Glob Bash
---

# x-brainstorm — Structured Exploration (BRAINSTORM Phase 1/3)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Capture the problem → explore multiple angles → prioritize ideas → produce concept document.

## Key Steps

1. If WORKFLOW.md exists, read it for prior context
2. Read `references/checklist.md` — follow the structured exploration protocol
3. Ask: "What problem are you trying to solve?" — wait for response before proceeding
4. Cover at least 3 distinct perspectives (user, implementor, operator)
5. Rank ideas by impact using Pareto 80/20 (Must Have / Should Have / Could Have / Won't Have)
6. Read `references/output-template.md` when writing the concept document

→ See `skill-design-challenge` for adversarial critique of proposals.
→ See `skill-pareto-focus` for prioritizing ideas by impact.

## Workflow Navigation

You just completed the **Brainstorm** phase (1/3). No user approval gate.

Copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:

- If evidence is needed for a specific question: "Invoke `x-research` to investigate [topic]."
- If the direction is already clear: "Invoke `x-design` to make the architectural decision."

## Gotchas

- Don't converge prematurely — output is a structured idea list, not a decision
- Don't mistake breadth for depth — cover at least 3 distinct perspectives before ranking
- Don't loop indefinitely — if evidence is needed for a specific question, route to x-research
- Do NOT write WORKFLOW.md until the concept document is complete and ideas are ranked
