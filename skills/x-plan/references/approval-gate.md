# Approval Gate — Plan → Implement

## User-Facing Message

Present the plan as a table, then ask:

> "Here's the implementation plan:
>
> | # | Task | Acceptance Criteria | Files | Risk |
> |---|------|---------------------|-------|------|
> | T1 | {action + outcome} | {observable condition} | {files} | {risk or —} |
> | ...
>
> Does this plan look correct? Reply 'yes' or 'proceed' to begin implementation,
> or describe changes you'd like before we start."

## Conditions for Proceeding

- User has explicitly confirmed ("yes", "proceed", "go ahead", "looks good", "start")
- Every task has measurable acceptance criteria (not just a title)
- If user requests changes: revise the plan, then re-present
- **Do NOT treat silence as approval**
- **Do NOT write WORKFLOW.md before this gate passes**

## Post-Approval Action

1. Copy `assets/WORKFLOW.md.template`
2. Set `current_phase: plan`
3. Fill `summary` (e.g. "8 tasks, 4 files affected, 1 HIGH risk: async migration")
4. Append prior phase summaries to `prev_phases`
5. Set `approval_required_before: implement`
6. Write or update `WORKFLOW.md` at repo root
7. Respond: "Plan approved. Invoke `x-implement` to begin."

## Headless / Automated Context

If operating without human interaction:
- Treat the gate as automatically approved
- Add `approval: auto-headless` to WORKFLOW.md
- Log: "Approval gate skipped — headless context. Proceeding to x-implement."
