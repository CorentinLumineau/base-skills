# x-fix — Fix Checklist

Load trigger: Read this file before writing any fix code.

## Phase 1: Root Cause Diagnosis

Before writing a single line of code:

- [ ] State the root cause in one sentence: "The bug is caused by {X} in {file}:{line}"
- [ ] Distinguish symptom from cause: the symptom is what the user sees; the cause is why it happens
- [ ] Identify the earliest point in the call chain where the failure originates
- [ ] Confirm with a failing test or observed behavior — not just code reading

**STOP** if you cannot state the root cause. Do not write the fix without a clear root cause statement.

## Phase 2: Fix Scope Check

- [ ] How many files does the fix require? If >3 files → upgrade to APEX workflow
- [ ] Does the fix require architectural change? → upgrade to APEX
- [ ] Is this a symptom fix (masking the problem) or a root cause fix? → choose root cause
- [ ] Does the fix risk breaking other behavior? → identify regression test targets

## Phase 3: Write the Fix

- [ ] Write a regression test that fails with the current code and passes with the fix
- [ ] Write the minimal fix targeting the root cause
- [ ] Do not refactor unrelated code in the same commit
- [ ] → See skill-error-handling if the fix involves error handling patterns

## Phase 4: Verify

- [ ] Regression test passes
- [ ] Full test suite passes (no new failures)
- [ ] Lint clean
- [ ] The original symptom no longer occurs

## Completion Check

Before presenting the fix for approval:

- [ ] Root cause stated explicitly
- [ ] Regression test written and passing
- [ ] Full suite green
- [ ] Fix is minimal (no scope creep)

See `references/approval-gate.md` for the user approval gate message format.
