# x-brainstorm — Structured Exploration Checklist

Load trigger: Read this file at the start of every brainstorm session.

## Phase Start

- [ ] Read WORKFLOW.md if it exists — extract prior context if re-entering from x-research
- [ ] Ask the user: "What problem are you trying to solve?" — wait for response before proceeding
- [ ] Restate the problem in your own words — confirm alignment before exploring

## Multi-Perspective Exploration

Cover at least 3 of these 5 perspectives (skip only with explicit justification):

- [ ] **User perspective**: What does the end user experience? What pain are they feeling?
- [ ] **Implementor perspective**: What is technically challenging? What are the implementation risks?
- [ ] **Operator perspective**: How will this be deployed, monitored, and maintained in production?
- [ ] **Security perspective**: What could go wrong? What data is exposed or modified?
- [ ] **Maintainability perspective**: How will this age? Who will change it in 6 months?

## Idea Generation

- [ ] Generate at least 5 distinct approaches or solution ideas (quantity before quality)
- [ ] No pruning during generation — capture all ideas, even weak-seeming ones
- [ ] For each idea: state it in one sentence; note which perspectives it addresses
- [ ] Identify open questions: what do you NOT know that would change the ranking?

## Pareto Prioritization

- [ ] Score each idea: impact (1–5) × feasibility (1–5)
- [ ] Classify into Must Have / Should Have / Could Have / Won't Have
- [ ] For every Won't Have item: steelman its strongest case before demotion
- [ ] Verify top Must Have items: "What if we deferred this?" — confirm it's truly essential

## Output

- [ ] Write concept document using `references/output-template.md`
- [ ] Identify the top 3 open questions that x-research should answer (if any)
- [ ] Fill WORKFLOW.md from `assets/WORKFLOW.md.template` with ranked idea summary
