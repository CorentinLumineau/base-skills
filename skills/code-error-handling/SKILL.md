---
name: code-error-handling
description: >
  Use when implementing error handling or exception management in application code
  (error handling, exception, try-catch, Result pattern, fail-fast, error boundary,
  logging, retry, HTTP error, error message).
  Covers fail-fast patterns, meaningful error messages, Result types, error boundaries,
  logging strategy, and HTTP error response conventions.
  Do NOT use for debugging methodology or production incident response (use quality-debugging-performance).
license: MIT
compatibility: always-on knowledge skill
allowed-tools: Read Grep Glob
---

<!-- ported from mercure-plugin/skills/code-error-handling/ -->

# Error Handling

Robust error handling patterns for reliable software.

## Principles

| Principle | Description |
|-----------|-------------|
| Fail fast | Detect and report errors early |
| Meaningful messages | Help users understand and fix the problem |
| Don't swallow errors | Always handle or propagate |
| Graceful degradation | Partial functionality is better than a crash |

## Error Types

| Type | Handling | Example |
|------|----------|---------|
| Expected | Handle explicitly | Validation errors, not-found |
| Unexpected | Log and recover | System failures, network timeouts |
| Fatal | Crash gracefully | Out of memory, unrecoverable state |

## Error Handling Patterns

### Try-Catch Best Practices

```
✅ Catch specific exception types
✅ Log with full context (requestId, userId, operation)
✅ Re-throw if the current layer cannot handle
❌ Empty catch blocks
❌ Catch-all Exception/Error without re-throwing
❌ Swallowing errors silently
```

### Result Pattern

Return `Result<T, E>` instead of throwing for expected failure paths:

```
Success: { ok: true,  value: T }
Failure: { ok: false, error: E }
```

Benefits: forces callers to handle failure cases; avoids exceptions as control flow;
makes error types explicit in function signatures.

### Error Boundary

Wrap components or subsystem entry points:
- Catch errors at the boundary
- Display or return a fallback response
- Log the full error with context for debugging
- Do not let errors propagate past the boundary unhandled

### Retry with Back-off

For transient failures (network, external service):

```
maxAttempts: 3
backoff: exponential (100ms, 200ms, 400ms)
retryOn: 429, 502, 503, 504
noRetryOn: 400, 401, 403, 404 (client errors — retrying won't help)
```

Always cap total retry time and surface the final error if all attempts fail.

## Error Message Guidelines

| Component | Include |
|-----------|---------|
| What happened | Clear, non-technical description |
| Why it happened | Root cause if known |
| How to fix | Actionable guidance for the caller |
| Context | Request ID, timestamp, operation name |

**Never include**: passwords, raw SQL, full stack traces in user-facing messages, or PII.

## Logging Strategy

| Level | Use For |
|-------|---------|
| Error | Failures that require human attention |
| Warn | Issues that may need attention; unexpected but recoverable |
| Info | Normal operations, lifecycle events |
| Debug | Detailed troubleshooting; disabled in production by default |

### Log Content

```
✅ Error message and type
✅ Stack trace (for debugging — suppress in prod user responses)
✅ Request context (requestId, correlationId, operation)
✅ User ID (anonymized / hashed)
❌ Passwords or API keys
❌ Full request bodies containing PII
❌ Credit card or payment data
```

### Structured Logging

Prefer structured (JSON) log entries over free-text so log aggregators can index fields:

```json
{
  "level": "error",
  "message": "Order creation failed",
  "requestId": "req-abc123",
  "userId": "usr-hashed-456",
  "error": { "type": "ValidationError", "field": "email" },
  "timestamp": "2026-06-12T10:15:00Z"
}
```

## Async Error Handling

- Always `await` promises inside try-catch, or attach `.catch()` — unhandled rejections crash Node.js
- Use `Promise.allSettled` when multiple async operations can independently fail
- In event handlers and callbacks, wrap the body in try-catch (exceptions thrown in callbacks are not caught by the outer async chain)
- Propagate errors from async iterators explicitly — `for await` does not automatically surface inner errors

## HTTP Error Responses

| Code | Meaning | Use When |
|------|---------|----------|
| 400 | Bad Request | Validation failed |
| 401 | Unauthorized | Not authenticated |
| 403 | Forbidden | Authenticated but no permission |
| 404 | Not Found | Resource missing |
| 409 | Conflict | State conflict (duplicate, optimistic lock) |
| 422 | Unprocessable | Business logic error |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Server Error | Unexpected failure |
| 503 | Service Unavailable | Dependency down, circuit open |

### API Error Body

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is invalid",
    "requestId": "req-abc123",
    "details": [
      { "field": "email", "message": "Must be a valid email address" }
    ]
  }
}
```

## Error Monitoring

- Instrument every error boundary and unhandled exception handler with an observability sink (Sentry, Datadog, OpenTelemetry)
- Set alert thresholds on error rate, not just raw count — a spike relative to baseline matters
- Tag errors with service, version, and environment so you can filter noise from non-production
- Create error budgets per endpoint; breach = rollback trigger
- Review error trends weekly; recurring WARN-level errors are HIGH-level problems in disguise

## Checklist

- [ ] All errors are caught or explicitly propagated
- [ ] No empty catch blocks
- [ ] Meaningful error messages with actionable guidance
- [ ] Appropriate logging level per error type
- [ ] Sensitive data not exposed in logs or user-facing messages
- [ ] User-friendly error display (no raw stack traces to end users)
- [ ] Retry logic for transient failures with back-off
- [ ] Error recovery where possible (graceful degradation)
- [ ] Async errors handled (no unhandled promise rejections)
- [ ] Observability sink configured for production errors

## Output Format

When referenced during a workflow, apply these standards by:
- Identifying error handling gaps by category (swallowed errors, missing recovery, unclear messages) with file path and function context
- Using severity model: CRITICAL = BLOCK (empty catch blocks, swallowed fatal errors), HIGH = WARN (missing error propagation, unclear messages), MEDIUM = INFO (logging level mismatch, missing context)
- Providing concrete recovery strategy suggestions per finding (e.g., "Add Result pattern for validation at line 42; replace silent catch with explicit error propagation")
- Validating error responses against HTTP status code conventions for API-facing code
