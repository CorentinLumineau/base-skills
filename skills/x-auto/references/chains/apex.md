# APEX Chain — Feature Development

Full phase sequence with gate positions.

## Chain

```
x-analyze [GATE→design] → x-design [GATE→plan] → x-plan [GATE→implement] → x-implement → x-review → git-commit
```

## Phases

| Position | Skill | Description | Gate |
|----------|-------|-------------|------|
| 1/6 | `x-analyze` | Assess codebase: quality, security, performance, architecture | **Yes** — before x-design |
| 2/6 | `x-design` | Architectural decisions, ADR | **Yes** — before x-plan |
| 3/6 | `x-plan` | Implementation plan, task breakdown | **Yes** — before x-implement |
| 4/6 | `x-implement` | TDD-driven implementation | No |
| 5/6 | `x-review` | Post-implementation quality gate | No (completion gate) |
| 6/6 | `git-commit` | Commit changes | — |

## Approval Gates

Gates require explicit user confirmation ("yes", "proceed", "go ahead").
Silence is not approval. Each gated skill's `references/approval-gate.md` has
the exact user-facing message and conditions.

## State

Each phase writes `WORKFLOW.md`. Read it at the start of each subsequent phase.
Schema at repo root: `references/workflow-state.md`.

## Entry Points

- Via x-auto (standard)
- Directly via `x-analyze` (phase 1) — create WORKFLOW.md if absent
- Mid-chain via any APEX phase — read existing WORKFLOW.md for context
