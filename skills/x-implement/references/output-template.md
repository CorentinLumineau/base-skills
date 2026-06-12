# x-implement — Output Template

When implementation is complete, produce an evidence statement in this format:

## Implementation Complete

**Plan**: `{plan-file-name.md}`
**Tasks completed**: {N} of {N}

### Verification Evidence

```
Tests:     {pass count} passed, 0 failed  ← paste runner output line
Lint:      clean (or "N pre-existing warnings, 0 new")
Typecheck: clean (or "N/A — no type checker configured")
```

### Tasks Summary

| # | Task | Acceptance Criterion | Status |
|---|------|----------------------|--------|
| T1 | {task title} | {criterion} | ✓ Met |
| T2 | {task title} | {criterion} | ✓ Met |

### Files Changed

- `{path/to/file}` — {add / modify} ({brief description})

---

## WORKFLOW.md Write

After producing the evidence statement, write WORKFLOW.md at repo root:

```yaml
workflow: apex
current_phase: implement
status: complete
prev_phases:
  - phase: analyze
    summary: "# paste from prior WORKFLOW.md"
  - phase: plan
    summary: "# paste from prior WORKFLOW.md"
approval_required_before: ~
started: # ISO date from prior WORKFLOW.md
summary: "{N} tasks, {N} files changed, all tests green"
```

Set `status: complete` and `approval_required_before: ~` (no gate before x-review — it runs automatically).

Then invoke x-review.
