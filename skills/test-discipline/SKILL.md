---
name: test-discipline
description: "TDD mandate: write the failing test before any implementation code. Testing pyramid: 70% unit / 20% integration / 10% E2E. Never claim completion without all tests passing."
---

# Test Discipline

**activation**: always-on
**triggers**: Any implementation task, bug fix, or code change that adds or modifies behavior

## Why
Code without tests is a claim without evidence. TDD forces the spec to be written before
the solution, which catches misunderstandings before they become working code. The pyramid
shape keeps the suite fast — slow E2E tests are expensive to run and maintain.

## Always
- Write the **failing test first** (red) before any implementation code
- Confirm the test FAILS before writing the fix — if it passes immediately, the test is wrong
- Follow the **pyramid**: 70% unit, 20% integration, 10% E2E
- Run the **full test suite** after every implementation task — not just the new tests
- Tests must be **independent** — no test should depend on another test's side effects

## Never
- Write production code before its test — no exceptions, no "it's just a small change"
- Mark implementation complete without the full suite passing
- Modify a test to make it pass — fix the implementation instead
- Write tests that only assert "it doesn't throw" — every assertion must verify real behavior

## TDD Cycle

1. **Red** — Write a failing test specifying the expected behavior
2. **Green** — Write the minimum implementation to make it pass
3. **Refactor** — Improve the code; re-run the test to confirm still green

## Watch out for
- "I'll add tests later" → later never comes; write the test now or the behavior drifts
- Tests that pass before the implementation exists → the test is not testing what you think
- Skipping integration tests → unit tests can pass while components fail to work together
