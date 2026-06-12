# Approval Gate — Analyze → Design

## User-Facing Message

Present this to the user after the audit report is written:

> "Analysis complete. Here's the summary:
>
> [paste the top 3-5 findings from the audit report]
>
> Shall I proceed to the **Design** phase to address these findings?
> Reply 'yes' or 'proceed' to continue, or describe changes before we move on."

## Conditions for Proceeding

- User has explicitly confirmed ("yes", "proceed", "go ahead", "continue")
- If user requests scope changes or additional analysis: address them, then re-present
- **Do NOT treat silence as approval**
- **Do NOT write WORKFLOW.md before this gate passes**

## Post-Approval Action

1. Copy `assets/WORKFLOW.md.template`
2. Set `current_phase: analyze`
3. Fill `summary` with one sentence (e.g. "3 HIGH security issues in auth; 12 quality findings")
4. Set `approval_required_before: design`
5. Write or update `WORKFLOW.md` at repo root
6. Respond: "Proceeding to Design. Invoke `x-design` with these findings as context."

## Headless / Automated Context

If operating without human interaction:
- Treat the gate as automatically approved
- Add `approval: auto-headless` to WORKFLOW.md
- Log: "Approval gate skipped — headless context. Proceeding to x-design."
