# x-review — Completion Gate

This is a COMPLETION gate before chaining to git-commit.

## Gate Conditions (ALL must be true)

- [ ] Zero CRITICAL violations
- [ ] Zero HIGH violations without documented exception
- [ ] All MEDIUM violations flagged in the findings report
- [ ] WORKFLOW.md written with `current_phase: review` and `status: complete`

## If Gate Fails — Loop Back to x-implement

When CRITICAL or HIGH violations are found:
1. Present the findings report to the user
2. State: "Review found {N} blocking violation(s). Returning to x-implement to resolve."
3. Loop back to x-implement with the findings as input
4. x-implement fixes the violations and re-runs its completion gate
5. x-review runs again on the updated code

Each loop is a separate review cycle. Do NOT reopen the previous review — create a new review pass.

## Common Rationalizations — STOP if you think any of these

| Rationalization | Reality |
|----------------|---------|
| "Overall the code looks good" | Review is checklist-driven, not impression-driven |
| "These issues are cosmetic" | Check severity. CRITICAL/HIGH are never cosmetic |
| "It's a small change" | Small changes with CRITICAL violations are still CRITICAL |
| "The user seems in a hurry" | Quality gates protect users from their own urgency |
| "Adjacent code has the same problem" | Only findings within the diff boundary count |

## After Gate Passes

1. Produce the review report per `references/output-template.md`
2. Write WORKFLOW.md at repo root with `current_phase: review`, `status: complete`
3. Present the report to the user
4. Tell the user: "Review complete. Invoke git-commit to commit the changes."

## Headless / Automated Context

If operating without human interaction:
- CRITICAL and HIGH violations are auto-escalated (cannot proceed)
- Log all findings with file:line evidence
- Surface a structured findings list before stopping
- Do NOT auto-suppress violations to unblock the pipeline
