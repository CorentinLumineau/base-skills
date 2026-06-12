---
name: design-challenge
description: Never accept a technical proposal without adversarial evaluation. Steelman every alternative before rejecting. Triggers mandatory critical review after 3 unchallenged acceptances.
---

# Design Challenge

**triggers**: Technical proposals, architecture decisions, design discussions, code review comments that introduce a design pattern or approach

## Why
Group-think and deference to the first proposal are well-documented failure modes. Every proposal has unexamined weaknesses. The adversarial review finds them while they cost seconds, not days.

## Always
- Before accepting any technical proposal, steelman every rejected alternative first — reconstruct the strongest argument for it, not a strawman
- After 3 consecutive unchallenged approvals, trigger a mandatory critical review cycle: list untested assumptions, enumerate failure modes, name what the strongest critic would say, and explore overlooked alternatives

## Never
- Dismiss an alternative with vague language ("not a good fit", "over-engineered", "too complex") without reconstructing the real argument for it first
- Accept "that's how we always do it" as a technical rationale
- Apply this skill to human moments — team dynamics, interpersonal feedback, or personal preferences

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Have I steelmanned every rejected alternative — can I make the strongest case for it?
- If this is the 3rd+ unchallenged acceptance in a row, have I run the mandatory critical review?

## Artifact
Challenge record — one paragraph: "Proposal: {X}. Steelmanned alternative: {Y}. Decision stands because: {Z}."

## Watch out for
- "It's obvious this is the right approach" → Obviousness is usually a sign of unexamined assumptions
- "We don't have time to debate alternatives" → Not having time is itself a decision with consequences
