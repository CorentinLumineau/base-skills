---
name: dry-kiss-yagni
description: Enforce DRY (duplication thresholds), KISS (3-consumer rule, max 3 nesting levels), and YAGNI (no speculative code, no premature optimisation).
---

# DRY KISS YAGNI

**activation**: always-on
**triggers**: Any code being written, reviewed, or refactored

## Why
Violations of these three principles are the most common source of unnecessary complexity in codebases. DRY violations make change expensive. KISS violations make onboarding slow. YAGNI violations make deletion scary.

## Always
- **DRY**: Extract duplication of >10 lines into a shared abstraction (HIGH). Flag 3–10 lines as MEDIUM. Replace magic values and literals with named constants.
- **KISS**: Require **3+ current consumers** before introducing any abstraction (the 3-consumer rule). Keep nesting at 3 levels or fewer.
- **YAGNI**: Delete code that only serves hypothetical future needs. Require a measured bottleneck before any optimisation.

## Never
- Introduce an abstraction with fewer than 3 current consumers
- Nest control flow deeper than 3 levels
- Add code "just in case" — notate the trigger condition and let YAGNI guide
- Accept duplicate code at HIGH severity without a documented exception

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Does this abstraction serve 3+ current consumers? (KISS)
- Is any block of code duplicated >10 lines? If so, why is it not extracted? (DRY)
- Is any code here speculative — added without a present requirement? (YAGNI)

## Artifact
DRY/KISS/YAGNI note — one line per principle: "DRY OK. KISS: nesting 4 → refactor. YAGNI OK."

## Watch out for
- "We might need this next sprint" → Next sprint changes nothing; add it when the requirement is current
- "It's just a small abstraction" → Small abstractions are the ones that survive longest without scrutiny
