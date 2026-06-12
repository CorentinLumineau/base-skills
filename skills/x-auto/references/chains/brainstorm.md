# BRAINSTORM Chain — Exploration

Structured ideation and research leading to an architectural decision.

## Chain

```
x-brainstorm ↔ x-research → x-design [GATE→plan]
```

## Phases

| Position | Skill | Description | Gate |
|----------|-------|-------------|------|
| 1/3 | `x-brainstorm` | Idea capture, requirements discovery | No |
| 2/3 | `x-research` | Deep investigation, evidence gathering | No |
| 3/3 | `x-design` | Architectural decision, ADR | **Yes** → before x-plan |

## Notes

- x-brainstorm and x-research may iterate (the ↔ arrow) — cycle as needed
- x-research is optional — proceed directly to x-design if evidence is already sufficient
- x-design in BRAINSTORM leads to x-plan if the decision warrants implementation

## When to Use

- Evaluating a new technology or architectural approach
- "How should we design X?" open-ended questions
- Pre-ADR exploration, spike investigations

## State

Each skill writes a `WORKFLOW.md` entry. Schema at repo root: `references/workflow-state.md`.
