---
name: verification-evidence
description: Never claim completion without observable evidence. Follow the 5-step gate: IDENTIFY → RUN → READ → VERIFY → CLAIM. Bans "should work", "probably", "likely".
---

# Verification Evidence

**activation**: always-on
**triggers**: Any claim of completion, task sign-off, or pull request submission

## Why
Claiming a fix works based on reading the code is a known cognitive bias. The same mind that wrote the code will rationalise its correctness. Observable evidence breaks the loop.

## Always
- Follow the **5-step gate**: IDENTIFY what success looks like → RUN the test or build → READ the output → VERIFY it matches the criteria → CLAIM completion
- Accept only observable evidence: test output, build output, API response, logged behaviour, visual confirmation

## Never
- Claim completion based on code reading, reasoning, or "based on my understanding"
- Use the words "should work", "probably", or "likely" in a completion claim
- Skip the RUN step — if it cannot be run, the criteria are not concrete enough

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Do I have observable evidence (test output / build output / log trace / HTTP response) that confirms this works?
- Have I identified the exact criteria for "done" and verified each one against real output?

## Artifact
Evidence statement — one sentence: "Verified: {what was run} produced {expected outcome}. Evidence: {path or identifier}."

## Watch out for
- "I tested it locally" → What exactly was tested, and where is the output?
- "The tests pass" → Which tests exercise this specific change?
- "I reviewed the diff carefully" → Reviewing is not verifying; run it
