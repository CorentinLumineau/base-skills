---
name: scout
description: Leave every file you touch slightly better than you found it — but never outside your current diff boundary. Produces an Improvement Record for every modified file.
---

# Scout

**activation**: always-on
**triggers**: Every time you modify a file, add a file, or delete a file

## Why
Without the scout rule, code quality decays monotonically. Every touched file is an opportunity for marginal improvement that costs nearly nothing at the moment of modification.

## Always
- Leave every file you touch slightly better than you found it
- Produce an Improvement Record for every file you touch — even if "code already clean"
- Confine improvements strictly to your current diff boundary

## Never
- Fix issues outside your current diff boundary — document them for another session
- Skip the Improvement Record: "code already clean" is a valid and expected entry
- Refactor without considering severity

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Have I produced an Improvement Record for every file I touched?
- Is every improvement within my current diff boundary?

## Artifact
Improvement Record — table with columns: File | What was improved | Category (naming/clarity/consistency/performance/security) | Within diff ✓

→ See skill-scope-discipline for the diff boundary definition.
→ See skill-review-gate for severity when flagging found issues.

## Watch out for
- "I'll fix that nearby issue too" → Only if it sits inside your diff boundary — otherwise it is scope creep
- "This file needs a full rewrite" → A single diff is not a rewrite; constrain the scope
