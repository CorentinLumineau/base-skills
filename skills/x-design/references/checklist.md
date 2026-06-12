# x-design — ADR Construction Checklist

Load trigger: Read this file at the start of the design phase.

## Phase Start

- [ ] Read WORKFLOW.md if it exists — extract analyze-phase findings and scope
- [ ] Identify the decision to be made in one sentence (the "ADR question")
- [ ] Confirm scope: what is being decided? What is explicitly out of scope?

## Requirements Gathering

- [ ] List functional requirements the architecture must satisfy (at least 3)
- [ ] List non-functional requirements: performance, security, maintainability, scalability
- [ ] List constraints: tech stack, team expertise, timeline, compatibility

## Option Generation

- [ ] Generate at least 2 genuinely distinct alternatives (not a strawman vs real option)
- [ ] For each alternative: name it, summarize it in one sentence, list key components
- [ ] Steelman each alternative: what is the strongest argument FOR it, even if you disagree?

## Trade-off Matrix

- [ ] Identify 3–6 evaluation criteria relevant to the decision (e.g., complexity, testability)
- [ ] Score each alternative on each criterion (1–5 scale, or High/Medium/Low)
- [ ] Sum scores; note any criteria that are must-haves (disqualifiers)

## SOLID/KISS/YAGNI Validation

- [ ] SRP: Does each proposed component have a single responsibility?
- [ ] DIP: Do higher-level components depend on abstractions, not concretions?
- [ ] KISS: Is the proposed design the simplest that satisfies requirements?
- [ ] YAGNI: Does every proposed component serve a current, documented need?

## ADR Document

- [ ] Write the ADR to `documentation/decisions/ADR-{NNN}-{slug}.md`
- [ ] Include: Context, Decision Question, Alternatives, Trade-off Matrix, Decision, Consequences
- [ ] State the chosen approach in one sentence in the Decision section
- [ ] List at least 2 consequences (positive) and 1 risk or trade-off accepted

## Gate Readiness

- [ ] All alternatives are documented (not just the winner)
- [ ] Design principles validation is recorded
- [ ] Read `references/approval-gate.md` and present the gate to the user
