# x-fix — Output Template

Produce a fix summary in this format before presenting the approval gate:

## Fix Summary

**Bug**: {one-sentence description of the symptom}

**Root cause**: {one-sentence description of the underlying cause and its location}
- File: `{path/to/file}:{line}`

**Change made**:
- `{path/to/file}` — {description of change}
*(add rows for each file modified)*

**Regression test added**: `{test file}:{test name}`
- Before fix: FAILING
- After fix: PASSING

**Full test suite**: {N} tests, 0 failures, 0 errors

---

## Example

## Fix Summary

**Bug**: Login fails with valid credentials after password reset.

**Root cause**: Password comparison used the old hash before the new hash was persisted to the database.
- File: `src/auth/login.ts:47`

**Change made**:
- `src/auth/login.ts` — fetch fresh user record after password reset before comparing hash

**Regression test added**: `tests/auth/login.test.ts:should login after password reset`
- Before fix: FAILING
- After fix: PASSING

**Full test suite**: 142 tests, 0 failures, 0 errors

---

## WORKFLOW.md Write

After user approval, write WORKFLOW.md at repo root:

```yaml
workflow: oneshot
current_phase: fix
status: complete
prev_phases: []
approval_required_before: commit
started: # ISO date
summary: "1 file changed, regression test added, suite green"
```
