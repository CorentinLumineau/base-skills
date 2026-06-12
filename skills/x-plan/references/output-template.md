# Plan Artifact Template

Write the plan as a file named `plan-{feature-slug}.md`, or inline if no file access.

## Format

```markdown
---
type: plan
feature: {feature description}
date: YYYY-MM-DD
workflow: apex
---

# Implementation Plan — {Feature}

## Tasks

| # | Task | Acceptance Criteria | Files Affected | Depends On |
|---|------|---------------------|----------------|-----------|
| T1 | {action verb + outcome} | {observable condition} | {file list} | — |
| T2 | {action verb + outcome} | {observable condition} | {file list} | T1 |

## Codebase Conventions

| Concern | Pattern | Source File |
|---------|---------|-------------|
| Error handling | {pattern name or class} | {file:line} |
| Tests | {framework}, `{test-dir}/` | — |
| Imports | {convention description} | — |

## Risk Assessment

| Task | Risk | Mitigation |
|------|------|-----------|
| T2 | {concrete risk} | {concrete action, not "be careful"} |

## Files Affected

- `{path/to/file}` — {change type: add / modify / delete}
```

## Notes

- Every acceptance criterion must be observable (test output, command result, visible behavior)
- "Works correctly" is NOT an acceptance criterion
- Always include a Codebase Conventions section — x-implement will reference it
- If a file doesn't exist yet, mark it as "add" — this confirms it's a new file
