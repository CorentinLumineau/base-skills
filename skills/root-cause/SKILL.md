---
name: root-cause
description: Before any bug fix, apply the 5 Whys to distinguish symptom from root cause. Document the root cause chain explicitly before writing any fix. Workaround escape hatch for infeasible root cause fixes.
---

# Root Cause

**triggers**: Any bug fix, incident response, test failure, or unexpected behaviour

## Why
Fixing symptoms is faster than finding root causes. A symptom fix feels productive and is rewarded immediately. The undiagnosed root cause continues producing new symptoms, making the fixer busy forever — and the system no more reliable.

## Always
- Distinguish symptom from root cause before writing any fix
- Apply the **5 Whys**: start with the symptom, ask "why" five times (or until the answer stops changing), and verify the chain is causal, not correlational
- Document the root cause explicitly: "Root cause: {X}. Evidence: {Y}."
- Only write a fix after the root cause is documented and separated from the symptom

## Symptom vs Root Cause — Examples
1. **Symptom**: "The API returns 504." **Root cause** after 5 Whys: "The connection pool has 10 connections but 15 concurrent requests arrive because the upstream timeout was lowered from 30s to 5s."
2. **Symptom**: "User got a stale cache." **Root cause** after 5 Whys: "The cache invalidation event is emitted before the database write commits, so a concurrent reader sees the invalidation and reads the old value as the new truth."

## Never
- Write a fix for a symptom without tracing at least 3 levels of "why"
- Document "root cause: human error" — humans are not root causes; the system that allowed the error is
- Accept a workaround without documenting infeasibility explicitly (see workaround escape hatch below)

## Workaround Escape Hatch
When the root cause fix is infeasible (cost, timeline, platform constraint), document it explicitly: "Root cause fix infeasible because: {reason}. Workaround adopted: {description}. Trigger for re-evaluation: {condition}."

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Have I documented the root cause chain (minimum 3 Whys) separately from the fix?
- Is this fix addressing the root cause, not just the symptom?

## Artifact
Root cause statement — one paragraph: "Symptom: {X}. 5 Whys: {Y→Z→...}. Root cause: {Z}. Fix: {fix description}."

→ See skill-hard-choice for the Decision Record artifact format (used when root cause fix involves a hard choice).

## Watch out for
- "The user did something wrong" → The system should not have allowed it
- "It was a one-time thing" → One-time things are often the first occurrence of a repeatable pattern
