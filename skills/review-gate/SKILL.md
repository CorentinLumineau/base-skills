---
name: review-gate
description: Canonical severity model for code review — CRITICAL (blocks merge), HIGH (blocks without user exception), MEDIUM (surface), LOW (note). Zero CRITICAL to pass. Rationalization trap table included.
---

# Review Gate

**activation**: always-on
**triggers**: Every code review, pull request review, architectural review, or design review

## Why
Without a shared severity model, reviewers disagree about what blocks a merge. A reviewer who calls everything CRITICAL is ignored; one who calls everything LOW lets problems through. The model makes the bar consistent.

## Always
- Classify every finding by severity using the canonical model below
- Block on any CRITICAL finding. Escalate any HIGH finding (unless the user has explicitly approved an exception in writing). Surface every MEDIUM finding. Note every LOW finding.

## Severity Model
| Level | Meaning | Action |
|-------|---------|--------|
| CRITICAL | Correctness bug, data loss, security vulnerability, SRP or LSP violation | Blocks merge until fixed |
| HIGH | OCP / DIP violation, >10 lines duplicated, architectural smell, missing error handling on external IO | Blocks merge unless user explicitly documents an approved exception in writing |
| MEDIUM | ISP violation, 3–10 lines duplicated, naming clarity, missing edge case in tests | Surface in review; non-blocking but document |
| LOW | Style preference, comment clarity, minor naming suggestion | Note only; author may ignore |

## Rationalization Trap Table
| Rationalization | Why it is wrong |
|----------------|-----------------|
| "It's just like the existing code" | Existing code may also be wrong |
| "We can fix it in a follow-up" | Follow-ups rarely happen without a tracker ticket |
| "It passes tests" | Tests only cover what they test |
| "Everyone does it this way" | Popularity is not correctness |
| "The deadline is tight" | Deadline pressure is when critical bugs are introduced |

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Does this review have any CRITICAL findings that are not resolved?
- Does every HIGH finding have a documented user-approved exception or is it resolved?

## Artifact
Review summary — one line: "Review: {N} findings — {N} CRITICAL, {N} HIGH, {N} MEDIUM, {N} LOW. HIGH exceptions: {Y/N}."

## Watch out for
- "It's just a style preference" → Style preferences belong at LOW, not HIGH
- "This is clearly wrong" → If it is clearly wrong it is at least HIGH — use the model
