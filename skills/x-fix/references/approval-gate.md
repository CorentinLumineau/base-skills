# x-fix — Approval Gate

## User-Facing Message

Present the fix summary, then ask:

> "Here is the fix summary:
>
> **Root cause**: {one sentence}
> **Change**: {file(s) modified, what changed}
> **Regression test**: {test name or description} — PASSING
> **Full suite**: {N} tests, 0 failures
>
> Does this fix look correct? Reply 'yes' or 'proceed' to commit,
> or describe any concerns before we commit."

## Conditions for Proceeding

- User has explicitly confirmed ("yes", "proceed", "go ahead", "looks good", "commit it")
- Root cause is stated (not just symptom description)
- Regression test exists and passes
- Full test suite passes
- **Do NOT treat silence as approval**
- **Do NOT commit before this gate passes**

## Post-Approval Action

1. Write WORKFLOW.md at repo root (see `assets/WORKFLOW.md.template`)
2. Respond: "Fix approved. Invoke git-commit to commit."

## Headless / Automated Context

If operating without human interaction:
- Treat the gate as automatically approved
- Add `approval: auto-headless` to WORKFLOW.md
- Log: "Approval gate skipped — headless context. Proceeding to git-commit."
- All verification conditions still apply (root cause, regression test, full suite green)
