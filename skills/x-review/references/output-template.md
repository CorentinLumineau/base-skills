# x-review — Output Template

Produce a review report in this format:

## Review Report

**Scope**: {diff summary — N files, N lines changed}
**Date**: {YYYY-MM-DD}

### Summary

| Severity | Count |
|----------|-------|
| CRITICAL | {n} |
| HIGH | {n} |
| MEDIUM | {n} |
| LOW | {n} |

### Findings

#### CRITICAL

- `{file}:{line}` — {description}
  - **Mitigation**: {concrete action}

#### HIGH

- `{file}:{line}` — {description}
  - **Mitigation**: {concrete action}

#### MEDIUM

- `{file}:{line}` — {description}
  - **Mitigation**: {concrete action or "deferred: {reason}"}

*(Omit sections with zero findings)*

### Completion Gate

- [ ] Zero CRITICAL violations: {PASS / FAIL — N remaining}
- [ ] Zero HIGH violations: {PASS / FAIL — N remaining}
- [ ] MEDIUM violations flagged: {PASS}

**Verdict**: APPROVED (proceed to git-commit) | BLOCKED (loop to x-implement)

---

## WORKFLOW.md Write

After producing the report, write WORKFLOW.md at repo root:

```yaml
workflow: apex
current_phase: review
status: complete
prev_phases:
  - phase: analyze
    summary: "# paste from prior WORKFLOW.md"
  - phase: plan
    summary: "# paste from prior WORKFLOW.md"
  - phase: implement
    summary: "# paste from prior WORKFLOW.md"
approval_required_before: ~
started: # ISO date from prior WORKFLOW.md
summary: "{N} files reviewed, {N} findings, verdict: APPROVED"
```
