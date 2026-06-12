# x-research — Research Report Template

Write the research report to `documentation/investigations/{slug}-research.md` if the directory
exists, otherwise present inline. Use this structure exactly.

## Required Sections

```markdown
# Research: {Topic}

## Questions Answered

| Question | Answer (one sentence) | Confidence |
|----------|-----------------------|-----------|
| {question 1} | {evidence-based answer} | High / Medium / Low |
| {question 2} | {evidence-based answer} | High / Medium / Low |

## Findings

### {Finding 1 Title}

{2–4 sentences explaining the finding.}

**Evidence**:
- `{file}:{line}` — {what was found}
- `{doc section or URL}` — {what it says}

### {Finding 2 Title}

{2–4 sentences.}

**Evidence**:
- `{file}:{line}` — {what was found}

## Open Questions (for x-brainstorm)

These questions arose during research and require brainstorm-level exploration:

1. {New question with context: "Found X but unclear why Y"}
2. {New question requiring user input or exploration}

## Unresolved Items

| Item | What's Missing | Where to Look |
|------|---------------|---------------|
| {topic} | {what evidence is absent} | {suggested source} |

## Recommendations

Based on the findings:
- {Recommendation 1 with evidence basis}
- {Recommendation 2 with evidence basis}
```
