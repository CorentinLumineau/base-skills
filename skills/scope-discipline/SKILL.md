---
name: scope-discipline
description: Before starting any task, write IS in scope / IS NOT in scope. Never fix out-of-scope discoveries. Rationalization trap table for common creep patterns.
license: MIT
---

# Scope Discipline

**triggers**: Before starting any task, before branching, before writing the first line of code, and whenever tempted to add "just one more thing"

## Why
Scope creep is the single largest source of delayed deliveries. It feels virtuous — "while we're here, let's fix that too" — but every addition multiplies review time, risk, and rework surface. Discipline feels restrictive; it is liberating.

## Always
- Before starting, write: **IS in scope** / **IS NOT in scope** — two explicit lists
- The diff boundary is: files and changes that are necessary to complete the IS list. Nothing else.
- Out-of-scope discoveries: document them (file, what, why out) but never fix unilaterally

## Never
- Fix a discovery that is not in the IS scope — even if it takes "just a minute"
- Expand the IS NOT list mid-task without re-anchoring: stop, re-evaluate, produce a new scope boundary

## Rationalization Trap Table
| Rationalization | Why it is wrong |
|----------------|-----------------|
| "While we're here" | That is exactly how creep starts |
| "It's in an adjacent function" | Adjacent is outside |
| "The whole module needs it" | If the whole module needs it, that is a separate task |
| "Best practice says" | Best practice is a reason for a separate ticket, not scope expansion |
| "It's just a quick fix" | Quick fixes are never quick when reviewed, tested, and deployed |

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Is this change in my IS scope list?
- Have I written the IS / IS NOT boundary before starting?

## Artifact
Scope boundary — two lists: IS in scope (bullet) / IS NOT in scope (bullet)

## Watch out for
- "This is clearly related" → Related is not in scope
- "We'd be irresponsible not to fix it" → Responsibility is defined by the task, not by proximity
