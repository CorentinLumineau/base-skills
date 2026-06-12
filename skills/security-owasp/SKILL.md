---
name: security-owasp
description: >
  Detect and prevent OWASP Top 10 2021 web application vulnerabilities during code review,
  security audit, or implementation. Covers injection, broken authentication, XSS, SSRF,
  insecure design, and misconfiguration with detection patterns and prevention strategies.
  Use when performing a security audit, reviewing authentication flows, validating input handling,
  or assessing API endpoints for security risk
  (OWASP Top 10, security audit, injection vulnerability, XSS attack, SQL injection,
  broken authentication, CWE, web application security, security review, vulnerability assessment,
  SSRF, insecure design, security misconfiguration).
compatibility: >
  Knowledge skill. No special agent primitives required. Works with any agent that can read
  and review code.
---

<!-- ported from mercure-plugin/skills/security-owasp/ -->

# OWASP Top 10 — Security Audit

**triggers**: Security audit, reviewing authentication or input handling code, assessing API
endpoints, code review of web application components, or any request containing "OWASP",
"security vulnerability", "injection", "XSS", "CWE", or "SSRF"

## Why

The OWASP Top 10 accounts for the majority of exploited web vulnerabilities. Addressing them
systematically during development costs far less than remediating a breach. Each category maps
to concrete detection patterns and countermeasures that can be applied during code review
without specialized security tooling.

## OWASP Top 10 2021 — Quick Reference

| # | Category | Severity | Key Risk |
|---|----------|----------|----------|
| A01 | Broken Access Control | CRITICAL | Privilege escalation, unauthorized data access |
| A02 | Cryptographic Failures | HIGH | Data exposed in transit or at rest |
| A03 | Injection (SQL, NoSQL, OS, LDAP) | CRITICAL | Data destruction, exfiltration, RCE |
| A04 | Insecure Design | HIGH | Systemic architectural flaws |
| A05 | Security Misconfiguration | HIGH | Default credentials, open cloud storage |
| A06 | Vulnerable and Outdated Components | HIGH | Known CVEs in dependencies |
| A07 | Identification and Authentication Failures | CRITICAL | Session hijacking, credential stuffing |
| A08 | Software and Data Integrity Failures | HIGH | Supply chain attacks, unsafe deserialization |
| A09 | Security Logging and Monitoring Failures | MEDIUM | Undetected breach, slow incident response |
| A10 | Server-Side Request Forgery (SSRF) | HIGH | Internal network exposure, metadata theft |

---

## A01 — Broken Access Control

**Detection patterns**:
- URL path traversal: `../`, `%2e%2e/` in user-controlled path parameters
- Missing authorization check before data access (read file/DB row without owner check)
- JWT or session token not verified server-side for every protected route
- CORS policy set to `*` on authenticated endpoints
- `isAdmin` flag passed from the client and trusted server-side

**Prevention**:
- Deny by default: all routes require explicit grant, not just the "restricted" ones
- Enforce ownership: `WHERE id = ? AND owner_id = current_user_id`
- Server-side session store — never trust client-provided role claims without re-validation
- Log access denials; alert on repeated denials from same identity

---

## A03 — Injection (SQL, NoSQL, Command, LDAP)

**Detection patterns — SQL**:
- String concatenation building SQL: `"SELECT * FROM users WHERE id = " + userId`
- `execute()` / `query()` with user input in the query string
- ORM raw query escapes: `.raw()`, `.unsafeQuery()`, `$queryRawUnsafe()`

**Detection patterns — Command injection**:
- `exec()`, `spawn()`, `system()`, `popen()` with unsanitized user input
- Shell metacharacters not stripped: `;`, `|`, `&&`, `$()`, backticks

**Detection patterns — NoSQL**:
- MongoDB operators (`$where`, `$gt`, `$ne`) injected via JSON body
- Query built from `req.body` directly: `db.find(req.body)`

**Prevention**:
- Parameterized queries / prepared statements for all database access
- ORM query builders — never `.raw()` with interpolated user data
- Input allowlisting for command arguments; avoid shell invocation when possible
- Validate type and shape before any database or OS operation

---

## A02 — Cryptographic Failures

**Detection patterns**:
- Passwords stored as MD5, SHA1, or plain text
- Sensitive data in URL query parameters (logged by proxy/server)
- HTTP (not HTTPS) for any page handling credentials or PII
- Encryption keys hardcoded in source or config files committed to VCS
- AES-ECB mode in use (deterministic, reveals patterns)

**Prevention**:
- Passwords: bcrypt, scrypt, or Argon2 with appropriate work factor
- TLS 1.2+ enforced; HSTS header set
- Secrets in environment variables or a secrets manager — never in source
- Authenticated encryption: AES-GCM or ChaCha20-Poly1305

---

## A07 — Identification and Authentication Failures

**Detection patterns**:
- No account lockout or rate limit on login endpoint
- Password reset tokens with predictable values or no expiry
- Session IDs in URL parameters
- "Remember me" token stored in localStorage (XSS-accessible)
- Missing `HttpOnly`, `Secure`, or `SameSite` flags on session cookie

**Prevention**:
- Rate-limit login: exponential backoff after N failures; CAPTCHA on threshold
- Cryptographically random tokens for password reset; expire in ≤1 hour; single-use
- Session cookies: `HttpOnly; Secure; SameSite=Strict`
- MFA for privileged accounts

---

## A04 — Insecure Design

**Detection patterns** (architectural, not code-level):
- No threat model for the feature
- Business logic bypassable by replaying requests or skipping steps
- Rate limiting absent on high-value operations (payment, registration)
- Sensitive operations lack audit trail

**Prevention**:
- Threat model every new feature before coding
- Verify workflow integrity server-side (don't trust client-reported step number)
- Idempotency keys on payment and sensitive mutation endpoints

---

## A05 — Security Misconfiguration

**Detection patterns**:
- Default credentials not rotated (admin/admin, root/root)
- Stack traces or debug info exposed to end users in production
- Unnecessary services enabled, unused ports open
- Cloud storage bucket with public read/write ACL
- Missing security headers: `X-Content-Type-Options`, `X-Frame-Options`, `CSP`

**Prevention**:
- Automated configuration scanning (e.g., `trivy`, `checkov`) in CI
- Separate configs per environment; no dev secrets in production config
- Security headers in every HTTP response

---

## A10 — Server-Side Request Forgery (SSRF)

**Detection patterns**:
- Endpoint accepts a URL parameter and fetches it server-side
- Internal metadata endpoints reachable: `http://169.254.169.254/`, `http://localhost/`
- URL scheme not validated (allows `file://`, `gopher://`, `dict://`)
- Response body from the fetched URL returned directly to the caller

**Prevention**:
- URL allowlist: only permit fetch to approved external domains
- Block reserved IP ranges (loopback, link-local, RFC1918) at the network layer
- Do not return raw fetch response body — transform and sanitize before returning

---

## A06 — Vulnerable and Outdated Components

**Detection patterns**:
- `npm audit`, `pip-audit`, `trivy` reports HIGH/CRITICAL CVEs in dependencies
- Dependencies pinned to exact versions with no automated update process
- Unpinned base images in Dockerfiles (`FROM node:latest`)

**Prevention**:
- Automated dependency scanning in CI — fail build on CRITICAL CVEs
- Dependabot or Renovate for automated patch PRs
- Pin base images to digest-pinned tags

---

## A08 — Software and Data Integrity Failures

**Detection patterns**:
- Deserialization of user-controlled data without type check: `JSON.parse(req.body)` used as
  object directly in sensitive logic
- npm/pip packages installed from untrusted registries or without integrity hash
- CI/CD pipeline can be modified by untrusted contributors

**Prevention**:
- Lock files committed to VCS; verify integrity hashes on install
- CI runners do not have write access to production systems from PRs
- Validate deserialized objects against a strict schema before use

---

## A09 — Security Logging and Monitoring Failures

**Detection patterns**:
- Login failures, access denials, and data exports not logged
- Logs contain PII (passwords, tokens, SSN) in plain text
- No alerting on repeated authentication failures or unusual data volumes

**Prevention**:
- Log: authentication events, authorization failures, high-value mutations
- Sanitize logs: mask/redact secrets and PII before writing
- Alert threshold: N failed logins in T seconds → alert

---

## Reporting Format

For each finding from a security audit, report:

| Field | Content |
|-------|---------|
| **Severity** | CRITICAL / HIGH / MEDIUM |
| **Category** | OWASP A0N — Category Name |
| **Location** | file:line or component |
| **Finding** | One-sentence description of the vulnerability |
| **Evidence** | Code snippet or pattern match |
| **Fix** | Specific remediation step |

## Gate

Before completing a security audit:
- [ ] All 10 OWASP categories checked (mark N/A with rationale if not applicable)
- [ ] Every CRITICAL finding has a specific remediation step
- [ ] No finding uses vague language ("improve security") — each fix is actionable

## Gotchas

- Parameterized queries do not protect against second-order injection — validate data
  on read, not just on write
- CORS `*` on a public read-only API is acceptable; on an authenticated API it is CRITICAL
- `HttpOnly` prevents XSS token theft but does not prevent CSRF — both defenses are needed
- A dependency with a CRITICAL CVE that is only used in test code is HIGH, not CRITICAL
- SSRF via DNS rebinding bypasses IP allowlists — pin DNS resolution at connection time

## Artifact

Security audit summary: "{N} findings — CRITICAL: {N}, HIGH: {N}, MEDIUM: {N}.
Categories covered: {list}. CRITICAL findings require fix before merge."
