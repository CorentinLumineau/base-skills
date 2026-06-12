# DEBUG Chain — Investigation

Hypothesis-driven debugging for unknown problems.

## Chain

```
x-troubleshoot → x-fix (simple) | x-implement (complex)
```

## Phases

| Position | Skill | Description | When |
|----------|-------|-------------|------|
| 1/2 | `x-troubleshoot` | Investigate, form hypotheses, identify root cause | Always first |
| 2/2 | `x-fix` | Apply fix once root cause is known | Root cause is clear + fix ≤ 3 files |
| 2/2 | `x-implement` | Full implementation if fix is larger | Fix requires multi-file or refactoring |

## Branching Decision

After x-troubleshoot, choose:
- **x-fix** if the root cause is clear and the change is small
- **x-implement** (APEX phase 4, via x-plan) if the fix is larger

## When to Use

- Error behavior is unexpected or inconsistent
- Root cause is unknown ("why is X happening?")
- Reproducing the issue requires investigation

## State

x-troubleshoot writes `WORKFLOW.md` with its findings summary.
Schema at repo root: `references/workflow-state.md`.
