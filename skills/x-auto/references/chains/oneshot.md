# ONESHOT Chain — Quick Fix

Targeted fix for a known bug, followed by a commit approval gate.

## Chain

```
x-fix [GATE→commit] → git-commit
```

## Phases

| Position | Skill | Description | Gate |
|----------|-------|-------------|------|
| 1/2 | `x-fix` | Root-cause verify + targeted fix + regression test | **Yes** — before git-commit |
| 2/2 | `git-commit` | Commit the fix | — |

## When to Use

- You have an identified bug with a known root cause
- The fix scope is limited (1-3 files, no architectural impact)
- No new feature, no refactor — purely a correction

When the fix turns out to be larger than expected or requires architectural decisions,
upgrade to APEX via x-auto.

## State

x-fix writes `WORKFLOW.md`. Schema at repo root: `references/workflow-state.md`.
