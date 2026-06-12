---
name: hard-choice
description: Evaluate the easy path (optimises for today) vs the hard path (optimises for the next two years) before committing to any solution. Produces a Decision Record.
---

# Hard Choice

**triggers**: Committing to a solution approach, choosing between alternatives, making a technical or design decision

## Why
The easy path feels correct because it minimises short-term effort. The hard path feels wrong because it costs more today. Both feelings are misleading without explicit comparison against a two-year horizon.

## Always
- Separate the easy path (optimises for today) from the hard path (optimises for the next two years)
- Evaluate both on: maintenance burden, change cost, onboarding friction, and failure modes
- Produce a Decision Record before committing to either path

## Never
- Choose the easy path by default — laziness is not a rationale
- Dismiss the hard path as "over-engineered" without steelmanning it first
- Skip the Decision Record for decisions that affect more than one module

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Have I written down the easy path and the hard path with concrete evaluation criteria?
- If I choose today's optimum, what does the rework cost 18 months from now?

## Artifact
Decision Record — lightweight, per-decision: Easy path (cost today, cost in 18 months) / Hard path (cost today, cost in 18 months) / Decision / One-sentence rationale.

This is distinct from an ADR: a Decision Record is a quick two-path comparison produced inline.
→ See [architecture-evidence](../architecture-evidence/SKILL.md) for full ADR format (durable design documents stored in the repo).
→ See [root-cause](../root-cause/SKILL.md) for root cause diagnosis during incident-driven decisions.

## Watch out for
- "We can always refactor later" → Later never comes without a documented decision that names the trigger
- "It's just a prototype" → Prototypes have a habit of becoming production
