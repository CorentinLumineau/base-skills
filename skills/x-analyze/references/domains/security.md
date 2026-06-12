# Security Domain — OWASP Top 10 Checklist

Check the codebase against all 10 OWASP categories (2021 edition).

## OWASP Top 10

| # | Category | What to Look For | Severity |
|---|----------|-----------------|---------|
| A01 | Broken Access Control | Missing authorization checks before sensitive operations | CRITICAL |
| A02 | Cryptographic Failures | Plaintext secrets, weak hashing (MD5/SHA1 for passwords) | HIGH |
| A03 | Injection | Unparameterized DB queries, exec()/eval() with user input | CRITICAL |
| A04 | Insecure Design | Business logic that can be abused by design (e.g. negative prices) | HIGH |
| A05 | Security Misconfiguration | Debug mode on, default credentials, verbose error messages | MEDIUM |
| A06 | Vulnerable Components | Outdated dependencies with known CVEs | HIGH |
| A07 | Auth / Identity Failures | Weak password rules, no rate limiting, session fixation | HIGH |
| A08 | Software / Data Integrity | No integrity checks on fetched code or data | MEDIUM |
| A09 | Logging Failures | Sensitive data in logs, no audit trail for auth events | MEDIUM |
| A10 | SSRF | User-supplied URLs fetched without validation | HIGH |

## Quick Scan Pattern

For each file that handles external input:
1. Does it handle user input? → check A03 (injection), A01 (access control)
2. Does it handle authentication? → check A07, A01
3. Does it log? → check A09 (no secrets in logs)
4. Does it fetch external URLs or data? → check A10 (SSRF)
5. Does it store or compare passwords/keys? → check A02 (crypto)

## Severity Guide

- **CRITICAL**: A01 missing auth, A03 injection — exploitable directly
- **HIGH**: A02 crypto failures, A06 vulnerable deps, A07 auth failures, A10 SSRF
- **MEDIUM**: A05 misconfiguration, A08 integrity, A09 logging failures

## Reporting

Only report concrete issues with evidence (file:line, specific variable/function).
"This might be vulnerable to injection" is not a finding.
"UserRepo.findUser() concatenates user input into SQL at line 47" is a finding.
