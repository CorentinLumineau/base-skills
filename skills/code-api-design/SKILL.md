---
name: code-api-design
description: >
  Use when designing or reviewing REST APIs, GraphQL schemas, or SDK interfaces
  (API design, REST, GraphQL, SDK, endpoint, versioning, pagination, OpenAPI, rate limiting).
  Covers resource naming, HTTP methods, response codes, versioning, pagination, error formats,
  GraphQL schema best practices, and SDK/code-generation patterns.
  Do NOT use for code quality reviews (use code-code-quality) or design patterns (use code-design-patterns).
allowed-tools: Read Grep Glob
metadata:
  license: MIT
  compatibility: always-on knowledge skill
---

<!-- ported from mercure-plugin/skills/code-api-design/ -->

# API Design

Best practices for designing clean, consistent APIs and SDK client libraries.

## REST Principles

| Principle | Description |
|-----------|-------------|
| Resources | Nouns, not verbs |
| HTTP Methods | GET, POST, PUT, PATCH, DELETE |
| Stateless | No server-side session |
| HATEOAS | Links for discoverability |

## URL Structure

```
/users              (collection)
/users/123          (resource)
/users/123/posts    (nested)
```

## HTTP Methods

| Method | Use For | Idempotent |
|--------|---------|------------|
| GET | Read resources | Yes |
| POST | Create resource | No |
| PUT | Replace resource | Yes |
| PATCH | Partial update | Yes |
| DELETE | Remove resource | Yes |

## Response Codes

| Code | Meaning |
|------|---------|
| 200 | OK |
| 201 | Created |
| 204 | No Content |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 422 | Unprocessable Entity |
| 500 | Server Error |

## Pagination

```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "hasNext": true
  }
}
```

Query params: `?page=1&limit=20` or `?cursor=abc123`

## Versioning

| Strategy | Example |
|----------|---------|
| URL path | `/v1/users` |
| Header | `Accept: application/vnd.api.v1+json` |
| Query | `?version=1` |

**Recommended**: URL path (explicit, discoverable)

## Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is invalid",
    "details": [
      { "field": "email", "message": "Must be valid email" }
    ]
  }
}
```

## GraphQL Considerations

| Aspect | Best Practice |
|--------|---------------|
| Schema | Type-safe, documented |
| Queries | Avoid over-fetching |
| Mutations | Clear input/output |
| N+1 | Use DataLoader |

### GraphQL Schema Design

- Use descriptive field names and SDL comments for documentation
- Separate query, mutation, and subscription types clearly
- Use input types for mutations (never raw scalars for complex arguments)
- Apply cursor-based pagination (`edges`/`node`/`pageInfo`) for lists
- Avoid deeply nested queries — expose flat structures where possible
- Use fragments to share selection sets across operations
- Implement `DataLoader` (or equivalent) at the resolver layer to batch N+1 queries
- Version via field deprecation (`@deprecated(reason: "...")`) rather than schema versioning

## OpenAPI / Specification

- Define every endpoint in an OpenAPI 3.x spec before implementation
- Use `$ref` to avoid duplicating schema definitions
- Document all request/response examples inline
- Validate the spec with a linter (`spectral`, `redocly`) in CI
- Generate server stubs and client SDKs from the spec to keep code and spec in sync
- Keep the spec as the single source of truth; do not hand-edit generated stubs

## Rate Limiting

| Strategy | Use When |
|----------|----------|
| Token bucket | Smooth traffic, allow short bursts |
| Fixed window | Simple quota enforcement |
| Sliding window | Fairness under sustained load |

- Return `429 Too Many Requests` with `Retry-After` header
- Document limits in the API spec and error response body
- Apply per-user and per-IP limits independently where applicable

## SDK Design Patterns

- Match language idioms: async/await in JS, futures in Rust, goroutines in Go
- Expose a fluent builder for configuration; avoid long constructor argument lists
- Return typed result objects (`Result<T, ApiError>`) rather than throwing raw errors
- Implement automatic retry with exponential back-off for 429 and 5xx responses (max 3 retries by default)
- Surface `requestId` / `correlationId` in every error object for support traceability
- Generate the SDK from the OpenAPI spec (`openapi-generator`, `kiota`, `speakeasy`) to eliminate drift
- Publish SDK changelogs that map to API version increments

### Builder Pattern for SDK Configuration

```
ApiClient.builder()
  .baseUrl("https://api.example.com")
  .apiKey(key)
  .retryPolicy(RetryPolicy.exponential(maxAttempts=3))
  .build()
```

## API Design Checklist

- [ ] Resources are nouns
- [ ] HTTP methods used correctly
- [ ] Consistent naming (plural, lowercase, hyphens)
- [ ] Proper status codes
- [ ] Pagination for lists
- [ ] Versioning strategy defined
- [ ] Error response format consistent
- [ ] Rate limiting implemented and documented
- [ ] Authentication documented
- [ ] SDK follows language idioms
- [ ] Retry logic for transient failures
- [ ] OpenAPI spec validated

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting API conformance issues with endpoint path, HTTP method, and specific violation (e.g., "POST /getUsers — verb in resource URL")
- Using severity model: CRITICAL = BLOCK (breaking REST contract), HIGH = WARN (naming/versioning violation), MEDIUM = INFO (pagination/error format gap)
- Providing corrected endpoint signatures, response schemas, or status code mappings for each finding
- Summarizing conformance against the API Design Checklist with pass/fail per item
