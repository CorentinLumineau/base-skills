---
name: error-handling
description: "Classify failures before acting. Transient=retry max 2x; Permanent=report+alternatives; Corruption=stop immediately. Bans silent failures, infinite retries, and data loss on errors."
---

# Error Handling

**triggers**: Any tool failure, file operation error, command failure, API error, or network timeout

## Why
Unclassified errors cause two failure modes: retrying permanent failures indefinitely
(wasted time) or abandoning transient failures prematurely (lost work). Classification
takes one second and prevents both.

## Always
- **Classify first, act second** — determine the error type before deciding what to do
- **Transient** (temporary, likely to resolve): retry up to 2 times with a brief pause
- **Permanent** (won't resolve with retry): report with context + suggest alternatives
- **Corruption** (data integrity risk): stop immediately, report, suggest recovery
- Report errors with actionable context: what failed, why, what to try next

## Never
- Retry a Permanent failure — it will not resolve with more attempts
- Retry more than 2 times total for any Transient failure
- Abandon a workflow silently on error without reporting what happened
- Continue after a Corruption error without explicit user guidance

## Classification Guide

| Type | Examples | Action |
|------|----------|--------|
| Transient | Network timeout, rate limit, lock contention | Retry ≤2x |
| Permanent | File not found, invalid syntax, auth failure, permission denied | Report + alternatives |
| Corruption | Truncated file, broken pipe, invalid state mid-write | Stop + report |

## Watch out for
- "Let me try again" without classifying the error first → classify, then decide
- Retrying a 404 (Permanent) → it will not resolve; suggest the alternative path instead
- Silently swallowing errors and claiming success → always surface errors to the user
