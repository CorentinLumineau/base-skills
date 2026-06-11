# Quality Principles

Always-on behavioral rules. Applied automatically to every task.

## Focus and Scope

- **ALWAYS** identify the 20% of effort that delivers 80% of value before starting any multi-step task. Produce a one-sentence Pareto Statement. Defer everything below the threshold explicitly.
- **ALWAYS** write IS in scope / IS NOT in scope before starting any task. Never fix a discovery outside the IS list.
- **NEVER** expand scope mid-task without producing a new scope boundary.

## Decision Quality

- **ALWAYS** evaluate easy path vs hard path before committing to any solution. The easy path optimises for today; the hard path optimises for the next two years.
- **NEVER** choose the easy path by default. Produce a Decision Record.
- **ALWAYS** steelman every rejected alternative before dismissing it.
- **NEVER** accept a technical proposal after three consecutive unchallenged approvals without a mandatory critical review.

## Code Quality

- **ALWAYS** verify SOLID compliance before writing any class, module, or function. SRP/LSP=CRITICAL, OCP/DIP=HIGH, ISP=MEDIUM.
- **NEVER** introduce an abstraction with fewer than 3 current consumers.
- **NEVER** nest control flow deeper than 3 levels.
- **NEVER** add speculative code without a present requirement.
- **NEVER** duplicate >10 lines without extracting a shared abstraction.

## Naming

- **ALWAYS** apply the explains-itself test to every new identifier.
- **NEVER** use: `data`, `info`, `manager`, `handler`, `utils`, `misc`, `helper` as name components.
- **ALWAYS** use verb-first for functions, `is/has/can/shouldX` for booleans.

## Verification

- **NEVER** claim completion without observable evidence. Gate: IDENTIFY → RUN → READ → VERIFY → CLAIM.
- **NEVER** use "should work", "probably", or "likely" in a completion claim.
- **ALWAYS** classify review findings by severity: CRITICAL=block, HIGH=block or escalate, MEDIUM=surface, LOW=note.
- **NEVER** merge with CRITICAL findings unresolved.

## Root Cause and Fixes

- **ALWAYS** apply the 5 Whys before any bug fix. Document the root cause before writing the fix.
- **NEVER** fix a symptom without tracing at least 3 levels of "why".
- **NEVER** document "root cause: human error" — the system that allowed the error is the root cause.

## Agent Behavior

- **ALWAYS** leave every file you touch slightly better than you found it, within the diff boundary.
- **ALWAYS** flag AI-generated patterns with no business value: empty handlers, no-op wrappers, single-consumer abstractions.
- **ALWAYS** pause and confirm before: >3 files affected, irreversible actions, architectural decisions, or ambiguous tasks.
- **NEVER** proceed on an ambiguous task without reformulating and confirming intent.
