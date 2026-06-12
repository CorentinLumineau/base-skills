---
name: architecture-evidence
description: Every significant design decision needs an ADR with context, at least 2 alternatives (including the rejected option's strongest argument), trade-offs, coupling assessment, decision, and rationale.
---

# Architecture Evidence

**triggers**: Every significant design decision — choosing between frameworks, data stores, module boundaries, API styles, deployment strategies, or any decision with lasting cost

## Why
Unrecorded architectural decisions are invisible to future teams. A choice that seems obvious today will be questioned six months later, and without context the only answer is "I do not know why we did it that way."

## Always
- Produce an ADR for every significant design decision
- Evaluate at least **two alternatives** — the rejected option must get its strongest argument, not a strawman
- Include a coupling assessment using the taxonomy: data (best) → stamp → control → common → content (worst)
- State one viable **"do nothing" option** explicitly (the ADR escape hatch)

## ADR Format
| Section | Content |
|---------|---------|
| Context | What prompted this decision? What constraints are we working under? |
| Options | At least 2 alternatives described neutrally |
| Trade-offs | Strengths and weaknesses of each option, including coupling impact |
| Decision | Which option was chosen |
| Rationale | Why this option over the others — reference specific trade-offs |

## Never
- Make an architecture decision without writing at least the Context and Rationale sections
- Dismiss an option in one sentence — reconstruct its strongest argument before rejecting it
- Skip the coupling taxonomy when a module boundary is involved

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Does this decision have a written ADR with at least 2 alternatives evaluated?
- Is the rejected alternative's strongest argument represented in the ADR?

## Artifact
ADR document — single file in project's docs/adr/ or architecture/ directory. Sections: Context / Options / Trade-offs / Decision / Rationale + coupling assessment.

## Watch out for
- "We already know the right choice" → If it is obvious, the ADR takes 10 minutes
- "It is just internal plumbing" → Internal plumbing has the longest lifespan
- "Do nothing is not an option" → Do nothing is always an option; naming it clarifies why action is necessary
