---
name: future-proof
description: Make the 2-year maintenance cost visible before every decision. Apply the next-developer test and change-cost test (>3 files per requirement change = smell).
---

# Future Proof

**activation**: always-on
**triggers**: Every decision that adds, modifies, or removes code, configuration, or infrastructure

## Why
The cost of a decision is paid mostly in maintenance, not initial development. Making that cost visible prevents short-term choices that create long-term burden.

## Always
- Make the **2-year maintenance cost** visible before committing: what does it take to keep this running, update dependencies, and onboard someone new?
- Apply the **next-developer test**: would someone unfamiliar with this code understand it in 6 months without asking for help?
- Apply the **change-cost test**: if the requirement changes, how many files change with it? More than 3 is a smell

## Never
- Accept a solution where more than 3 files change for a single requirement change without documenting why
- Assume "it's easy to maintain" without evidence — ask what the evidence is
- Skip naming rules for public-facing identifiers

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- What is the estimated 2-year maintenance cost of this decision (hours per year)?
- If the requirement changes, how many files change? (3+ requires justification)

## Artifact
Maintenance cost statement — one sentence: "2-year maintenance cost: {X hours/year}. Change-cost: {N} files."

→ See skill-dry-kiss-yagni for the YAGNI boundary (speculative vs prudent).
→ See skill-naming for naming rules.

## Watch out for
- "We'll document it later" → Documentation that does not exist in the PR does not exist
- "Anyone can figure this out" → The next developer is not anyone; they are someone with no context
