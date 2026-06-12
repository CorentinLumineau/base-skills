# Approval Gate — Design → Plan

## User-Facing Message

After writing the ADR, present this to the user:

---

**Architecture decision recorded.**

**ADR**: `{path to ADR file}`
**Decision**: {one-sentence statement of the chosen approach}
**Alternatives considered**: {count} ({list alternative names})
**Design principles**: {pass/warn summary — e.g. "SOLID: pass, KISS: warn (1 concern)"}

**Trade-off accepted**: {key trade-off in one sentence}

---

Then ask:

> "The ADR is written. Ready to create the implementation plan?"

Provide three response options:
1. **"Yes, proceed to planning"** — user approves the architectural direction
2. **"Revise the design"** — user wants to adjust the ADR before planning
3. **"More research needed"** — user wants to invoke x-research before committing

## Proceed Conditions

All conditions must be true before proceeding to x-plan:
- [ ] ADR file exists at the stated path
- [ ] At least 2 alternatives documented in the ADR
- [ ] User has explicitly chosen option 1 ("proceed to planning") — silence is NOT approval
- [ ] No open "◐ Blind spot" assumptions remain unresolved in the ADR

## Headless Auto-Approval Note

In automated/headless pipelines without interactive user input:
- Treat as auto-approved if the ADR file exists and passes all proceed conditions
- Set `approval_required_before: null` in WORKFLOW.md
- Log: `"[headless] Design → Plan gate auto-approved: ADR exists at {path}"`
