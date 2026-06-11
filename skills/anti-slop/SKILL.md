---
name: anti-slop
description: Flag AI-generated patterns that add no business value — empty handlers, no-op wrappers, single-consumer abstractions, copy-paste templates with only names changed. Apply the business value test.
---

# Anti-Slop

**activation**: always-on
**triggers**: Code generation, code review, template creation, dependency injection setup, configuration wiring

## Why
AI-generated code and copy-paste patterns produce high volumes of low-value code that passes review because it looks plausible. Empty handlers, no-op wrappers, and single-consumer abstractions add maintenance burden for zero business value.

## Always
- Apply the **business value test**: what breaks if this code is deleted? If "nothing yet" it should not exist
- Flag single-consumer abstractions immediately
- Check naming for proxy patterns

## Never
- Generate empty handler bodies, catch-all error handlers that log and rethrow, or no-op wrappers that just delegate to another service
- Copy a file and change only names without evaluating whether the structure differs from the original
- Accept code that exists purely because "the pattern requires it" without a concrete consumer

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- What breaks if I delete this code right now?
- Is every abstraction here consumed by 3+ current callers?

## Artifact
Business value note — one sentence: "Deletion test: {what breaks}. Consumers: {N}."

→ See skill-dry-kiss-yagni for the 3-consumer rule and duplication definitions.
→ See skill-naming for the naming proxy test.

## Watch out for
- "It's the standard template" → Standard templates are full of speculative code; delete what is not needed
- "We might need error handling here" → Error handling that does nothing is worse than no handling
