# Debugging Introspection Markers

<!-- ported from mercure-plugin/skills/quality-debugging-performance/ -->

Visual indicators for transparent problem-solving.

## Marker Reference

### Analyzing
**When**: Gathering information, parsing errors, reviewing context
```
Analyzing error context...
   Error: "Cannot read property 'id' of undefined"
   Stack trace: userService.ts:45
   Recent changes: Email validation added 2 days ago
```

### Hypothesis
**When**: Forming root cause theory, selecting strategy
```
Root cause hypothesis...
   H1: Validation returns undefined instead of user (85%)
   H2: Database connection timeout (10%)
   H3: Missing error handling (5%)
   Selected: H1 - Validation logic error
```

### Testing
**When**: Reproducing issue, applying fixes, executing tests
```
Testing hypothesis...
   Reproduced: Validation with invalid email returns undefined
   Expected: Should throw validation error
   Root cause confirmed: emailValidator.ts:23
```

### Data
**When**: Measuring impact, collecting metrics, assessing severity
```
Impact assessment...
   Affected: All user creation endpoints
   User impact: Cannot create accounts
   Severity: High (blocks signup)
```

### Insight
**When**: Pattern recognition, resolution, lessons learned
```
Resolution...
   1. Update validator to throw ValidationError
   2. Add error handling in service
   3. Add regression test for edge cases
   Validated: All creation flows work
```

## Workflow Examples

### Quick Fix (Tier 1)
```
Testing quick fix...
   Error: ReferenceError: user is undefined
   File: auth.test.ts:23
   Fix: Add missing variable declaration
Tests passing
```

### Debug Session (Tier 2)
```
Analyzing API issue...
Hypothesis: Race condition in cache
Testing: Confirmed cache key collision
Fix applied and validated
```

### Troubleshooting (Tier 3)
```
Context gathering...
Systematic investigation...
Debug instrumentation added...
Data collection complete...
Root cause: Processing exceeds timeout
Solution: Async queue with progress callbacks
```
