---
name: x-auto
description: >
  Entry point and workflow classifier for APEX, ONESHOT, DEBUG, and BRAINSTORM chains.
  Detects intent from the user's request and routes to the correct first skill.
  Use when starting any coding task, unsure which workflow applies, or given a
  high-level request (x-auto, start workflow, what should I do, new feature, fix bug,
  debug, brainstorm, analyze, plan, implement, explore, where do I start).
compatibility: >
  Designed for any AI agent that can follow multi-step procedural instructions.
  Compatible with Claude Code, Gemini CLI, OpenCode, Copilot, Codex, and any
  agentskills.io client. Requires file write access for WORKFLOW.md.
metadata:
  workflow: all
  phase: entry
  position: "0/0"
---

# x-auto — Workflow Entry Point

Read `references/chains/{workflow}.md` after classifying intent for the full chain.
The repo root has `references/chain-overview.md` for a quick overview of all 4 chains.

## Classify Intent

| User wants to...                              | Workflow    | Start with      |
|-----------------------------------------------|------------|-----------------|
| Build a feature, add functionality, improve   | APEX        | x-analyze       |
| Fix a specific known bug                      | ONESHOT     | x-fix           |
| Debug an unknown problem, investigate         | DEBUG       | x-troubleshoot  |
| Explore ideas, brainstorm, research options   | BRAINSTORM  | x-brainstorm    |

## Key Steps

1. Read the user's request and classify intent using the table above
2. If ambiguous: ask one clarifying question before proceeding
3. State the chosen workflow: "Routing to the {WORKFLOW} chain, starting with `{skill}`."
4. Read `references/chains/{workflow}.md` for gate positions and next skills
5. Create `WORKFLOW.md` from `assets/WORKFLOW.md.template` — fill `workflow` and `started`

## Workflow Navigation

x-auto has no approval gate — it is a pure classifier.

After classifying and creating WORKFLOW.md, tell the user:
> "Workflow started. Invoke `{first-skill}` to begin."

## Gotchas

- "Improve the API" → APEX, not ONESHOT. Enhancements are always APEX, not quick fixes
- "Something is broken" with no known root cause → DEBUG, not ONESHOT
- If the user directly invokes a phase skill (e.g. `x-analyze`), skip x-auto — the chain
  is already started; read WORKFLOW.md if it exists for prior context
- Don't ask for confirmation before classifying an unambiguous request
