# x-design — ADR Output Template

Write the ADR to `documentation/decisions/ADR-{NNN}-{slug}.md`.
Increment NNN from the highest existing ADR in that directory.

## ADR Frontmatter

```yaml
---
type: adr
status: accepted
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
review_trigger: "on implementation start"
related:
  - documentation/audits/{prior-analysis}.md   # from x-analyze if applicable
---
```

## ADR Body Sections

```markdown
# ADR-{NNN} — {Decision Title}

## Context

{2–4 sentences describing the situation, problem, and why a decision is needed.
Reference x-analyze findings if this follows an APEX analysis phase.}

## Decision Question

> {One-sentence statement of what is being decided.}

## Alternatives

### Option A: {Name}

{1–2 sentence summary.}

**Arguments for**: {steelmanned case}
**Arguments against**: {honest critique}

### Option B: {Name}

{1–2 sentence summary.}

**Arguments for**: {steelmanned case}
**Arguments against**: {honest critique}

## Trade-off Matrix

| Criterion | Option A | Option B | Notes |
|-----------|----------|----------|-------|
| {criterion 1} | {score} | {score} | {note} |
| {criterion 2} | {score} | {score} | {note} |
| Totals | {sum} | {sum} | |

## Decision

**Chosen approach**: Option {X} — {name}

{One sentence justifying the choice, referencing the dominant criteria.}

## Consequences

**Positive**:
- {Consequence 1}
- {Consequence 2}

**Trade-offs accepted**:
- {Key trade-off: what is given up and why it's acceptable}

## Cross-skill References

→ See `skill-hard-choice` for the decision record format used within this ADR.
```
