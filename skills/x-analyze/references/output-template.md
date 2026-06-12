# Audit Report Template

Write the audit report as a file named `audit-{scope}-{date}.md`, or inline if no file access.

## Format

```markdown
---
type: analysis
scope: {scope description}
date: YYYY-MM-DD
status: draft
---

# Audit Report — {scope}

## Summary

| Severity | Count | Top Finding |
|----------|-------|-------------|
| CRITICAL | {n}   | {one-line description} |
| HIGH     | {n}   | {one-line description} |
| MEDIUM   | {n}   | {one-line description} |
| LOW      | {n}   | — |

## Findings

### CRITICAL

**C1 — {title}** — `{file:line}` (if known)
{2-3 sentences: what it is, why it matters, how to detect it.}

### HIGH

**H1 — {title}** — `{file:line}` (if known)
{description}

### MEDIUM

**M1 — {title}**
{description}

### LOW

...

## Top 3 Recommendations

1. {recommendation} — effort: {low|medium|high}
2. {recommendation} — effort: {low|medium|high}
3. {recommendation} — effort: {low|medium|high}
```

## Notes

- `status: draft` until user explicitly approves the findings
- Only list findings that are concrete and evidence-based (file:line or component-level)
- Never invent findings — if a domain is clean, say so ("Security: no OWASP issues detected")
- Include file:line references whenever possible — they make findings actionable
