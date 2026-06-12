# Workflow Chain Overview

All 4 chains at a glance. `[GATE]` marks phases that require explicit user approval
before the next phase begins.

## APEX — Feature Development

```
x-auto → x-analyze [GATE] → x-design [GATE] → x-plan [GATE] → x-implement → x-review → git-commit
```

| Position | Skill | Phase | Gate? |
|----------|-------|-------|-------|
| 0/0 | x-auto | entry / classifier | No |
| 1/6 | x-analyze | analyze | **Yes** → before design |
| 2/6 | x-design | design | **Yes** → before plan |
| 3/6 | x-plan | plan | **Yes** → before implement |
| 4/6 | x-implement | implement | No |
| 5/6 | x-review | review | No (completion gate) |
| 6/6 | git-commit | commit | — |

## ONESHOT — Quick Fix

```
x-auto → x-fix [GATE] → git-commit
```

| Position | Skill | Phase | Gate? |
|----------|-------|-------|-------|
| 1/2 | x-fix | fix | **Yes** → before commit |
| 2/2 | git-commit | commit | — |

## DEBUG — Investigation

```
x-auto → x-troubleshoot → x-fix (simple) | x-implement (complex)
```

| Position | Skill | Phase | Gate? |
|----------|-------|-------|-------|
| 1/2 | x-troubleshoot | troubleshoot | No |
| 2/2 | x-fix or x-implement | fix / implement | x-fix has gate |

## BRAINSTORM — Exploration

```
x-auto → x-brainstorm ↔ x-research → x-design
```

| Position | Skill | Phase | Gate? |
|----------|-------|-------|-------|
| 1/3 | x-brainstorm | brainstorm | No |
| 2/3 | x-research | research | No |
| 3/3 | x-design | design | **Yes** → before plan |

## State Passing

Each phase writes `WORKFLOW.md` at phase completion. The next phase reads it at start.
Full schema: `references/workflow-state.md` (at repo root).

## Entry Points

- Via x-auto (recommended — classifies intent and starts the chain)
- Directly via any phase skill — read WORKFLOW.md if it exists for prior context
