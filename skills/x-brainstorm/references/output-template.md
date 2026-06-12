# x-brainstorm — Concept Document Template

Write the concept document to `documentation/brainstorms/{slug}.md` if the directory exists,
otherwise present inline. Use the structure below exactly.

## Required Sections

```markdown
# Brainstorm: {Topic}

## Problem Statement

{2–4 sentences. What problem is being solved? Who experiences it? Why does it matter now?}

## Ideas

### Must Have

| Idea | Rationale | Open Questions |
|------|-----------|----------------|
| {idea 1} | {why essential} | {question 1} |

### Should Have

| Idea | Rationale | Deferred Because |
|------|-----------|-----------------|
| {idea 2} | {why important} | {why not must-have} |

### Could Have

| Idea | Rationale | Deferred Because |
|------|-----------|-----------------|
| {idea 3} | {value} | {why not should-have} |

### Won't Have (this iteration)

| Idea | Strongest Case For It | Why Deferred |
|------|-----------------------|--------------|
| {idea 4} | {steelmanned argument} | {honest reason} |

## Perspective Coverage

| Perspective | Addressed? | Key Insight |
|-------------|-----------|-------------|
| User | Yes / Partial / No | {insight} |
| Implementor | Yes / Partial / No | {insight} |
| Operator | Yes / Partial / No | {insight} |
| Security | Yes / Partial / No | {insight} |
| Maintainability | Yes / Partial / No | {insight} |

## Open Questions for x-research

1. {Specific question with unknown answer that would change the ranking}
2. {Specific question about a technical approach or external dependency}
3. {Specific question about constraints or requirements}
```
