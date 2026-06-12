# x-auto — Output Template

x-auto produces two outputs: a classification statement (inline response) and a WORKFLOW.md file.

## Inline Classification Statement

Present to the user immediately after classifying:

```
Routing to the {WORKFLOW} chain, starting with `{skill}`.
Workflow started. Invoke `{first-skill}` to begin.
```

Examples:

- "Routing to the APEX chain, starting with `x-analyze`."
- "Routing to the ONESHOT chain, starting with `x-fix`."
- "Routing to the DEBUG chain, starting with `x-troubleshoot`."
- "Routing to the BRAINSTORM chain, starting with `x-brainstorm`."

## WORKFLOW.md

Created from `assets/WORKFLOW.md.template`. Required fields to fill:

| Field | Value | Example |
|-------|-------|---------|
| `workflow` | Detected workflow name (lowercase) | `apex` |
| `started` | ISO date of session start | `2026-06-12` |

All other fields (`current_phase`, `status`, `prev_phases`, `approval_required_before`) are
written by downstream phase skills — x-auto leaves them at template defaults.

## File Location

Write WORKFLOW.md to the repository root (same directory as README.md or the primary entry point).
If the user invoked x-auto from a subdirectory, still write to the root.
