---
name: compliance-audit-compliance
description: >
  Use when performing compliance audits, mapping controls to frameworks (GDPR, SOC 2, ISO 27001,
  PCI-DSS, HIPAA), collecting evidence, designing audit trails, or preparing for external audits.
  Covers control mapping, evidence collection patterns, audit trail implementation, and
  compliance framework requirements.
  Do NOT use for authentication/authorization implementation (use security-identity-access instead).
license: MIT
compatibility: >
  Always-on knowledge skill. Works with any agent that can read codebases, review policies,
  or produce compliance documentation.
metadata:
  type: knowledge
  domain: compliance
allowed-tools:
  - Read
  - Write
  - Bash
---

<!-- ported from mercure-plugin/skills/compliance-audit-compliance/ -->

# Compliance Audit

**triggers**: Preparing for SOC 2 audit, GDPR compliance review, implementing audit trails,
mapping controls to frameworks, collecting evidence for certification, security control assessment

## Compliance Frameworks

See [references/compliance-frameworks.md](references/compliance-frameworks.md) for detailed framework requirements.

### Framework Overview

| Framework | Scope | Primary requirement | Audience |
|-----------|-------|--------------------|---------| 
| **SOC 2 Type II** | Service organizations | Trust Service Criteria: Security, Availability, Confidentiality, Privacy, Processing Integrity | B2B SaaS |
| **ISO 27001** | Information security management system | ISMS implementation, risk treatment, continuous improvement | Enterprise |
| **GDPR** | Personal data of EU residents | Lawful processing, data subject rights, breach notification | Any org handling EU data |
| **PCI-DSS** | Payment card data | 12 requirements covering network, access, monitoring | Payment processors, merchants |
| **HIPAA** | Protected health information (PHI) | Administrative, physical, technical safeguards | US healthcare |
| **SOC 1** | Financial controls | Controls relevant to user entity's financial reporting | Financial services |

## Control Mapping

See [references/control-mapping.md](references/control-mapping.md) for control-to-framework mapping tables.

### Control Categories

| Category | Examples |
|----------|---------|
| Access Control | MFA, least privilege, access reviews, session management |
| Encryption | At rest, in transit, key management |
| Monitoring | Log collection, alerting, incident detection |
| Vulnerability Management | Patch management, scanning, pen testing |
| Change Management | Approved change process, code review, deployment gates |
| Incident Response | IR plan, post-mortem process, breach notification |
| Business Continuity | Backup, DR testing, RTO/RPO |
| Vendor Management | Third-party risk assessment, SLA |
| Physical Security | Data center access, device management |
| Training | Security awareness, role-specific training |

### Cross-Framework Control Map (excerpt)

| Control | SOC 2 | ISO 27001 | GDPR | PCI-DSS |
|---------|-------|----------|------|---------|
| MFA for admin access | CC6.1 | A.9.4.2 | Art. 32 | Req 8.3 |
| Encryption at rest | CC6.7 | A.10.1.1 | Art. 32 | Req 3.4 |
| Access logs retained 1 year | CC7.2 | A.12.4.1 | Art. 30 | Req 10.7 |
| Vulnerability scanning | CC7.1 | A.12.6.1 | — | Req 6.3 |
| Incident response plan | CC7.3 | A.16.1.1 | Art. 33 | Req 12.10 |
| Data breach notification | CC7.4 | A.16.1.3 | Art. 33, 34 | Req 12.10 |

## Audit Trail Patterns

See [references/audit-trail-patterns.md](references/audit-trail-patterns.md) for implementation patterns.

### Audit Log Requirements

Every compliance-relevant action must produce an immutable audit record:

| Field | Required | Description |
|-------|---------|-------------|
| `timestamp` | Yes | ISO 8601, UTC, millisecond precision |
| `actor` | Yes | User ID or service account performing the action |
| `action` | Yes | What was done (verb + object: `user.delete`, `config.update`) |
| `resource_id` | Yes | The resource affected |
| `resource_type` | Yes | Type of resource |
| `outcome` | Yes | `success` or `failure` |
| `ip_address` | Yes | Source IP (for user actions) |
| `request_id` | Yes | Correlation ID for tracing |
| `before_state` | Conditional | Previous value (for updates) |
| `after_state` | Conditional | New value (for updates) |
| `reason` | Conditional | Justification for privileged actions |

### Audit Log Schema (JSON)

```json
{
  "timestamp": "2024-01-15T10:23:11.456Z",
  "actor": {
    "id": "user:12345",
    "type": "user",
    "email": "alice@example.com",
    "ip_address": "203.0.113.45"
  },
  "action": "user.role.assign",
  "resource": {
    "id": "user:67890",
    "type": "user"
  },
  "outcome": "success",
  "request_id": "req_abc123",
  "metadata": {
    "before": { "role": "viewer" },
    "after": { "role": "admin" },
    "reason": "Approved by manager - ticket #4521"
  }
}
```

### Audit Trail Storage

| Requirement | Implementation |
|------------|---------------|
| Immutability | Write-once storage (S3 Object Lock, WORM drives) |
| Integrity verification | Cryptographic hash chaining |
| Retention | Minimum 1 year (SOC 2/PCI), 3-7 years (HIPAA/GDPR) |
| Availability | Searchable within retention period |
| Separation | Stored separately from application data |

## Evidence Collection

See [references/evidence-collection.md](references/evidence-collection.md) for evidence collection procedures.

### Evidence Categories

| Category | Examples | Collection method |
|----------|---------|------------------|
| Configuration screenshots | Security settings, MFA enabled | Automated export via API |
| Access review records | User list + roles at review date | Script: export + sign |
| Vulnerability scan results | CVSS scores, patch status | Scanner export (PDF/JSON) |
| Training completion | % of staff completing security training | LMS export |
| Penetration test reports | External pen test findings | PDF from vendor |
| Incident records | Post-mortems, response timelines | Exported from ticketing system |
| Change management logs | Approved change requests with sign-off | ITSM export |
| Backup test results | Restore success/failure records | Automated test reports |

### Evidence Collection Script Template

```bash
#!/usr/bin/env bash
# collect-evidence.sh — collect compliance evidence snapshot

AUDIT_DATE=$(date +%Y-%m-%d)
EVIDENCE_DIR="evidence/${AUDIT_DATE}"
mkdir -p "$EVIDENCE_DIR"

# 1. Export user list with roles
echo "Collecting user roster..."
gh api orgs/{org}/members --paginate \
  | jq '[.[] | {login, role}]' \
  > "$EVIDENCE_DIR/user-roster.json"

# 2. Export MFA status
echo "Collecting MFA status..."
gh api orgs/{org}/members --paginate \
  | jq '[.[] | select(.two_factor_authentication == false) | .login]' \
  > "$EVIDENCE_DIR/mfa-disabled-users.json"

# 3. Export recent access logs
echo "Collecting access logs..."
aws cloudwatch logs filter-log-events \
  --log-group-name /app/audit \
  --start-time $(($(date -d '30 days ago' +%s) * 1000)) \
  --output json > "$EVIDENCE_DIR/audit-logs-30d.json"

# 4. Capture configuration
echo "Collecting configuration..."
aws s3api get-bucket-encryption --bucket {prod-bucket} \
  > "$EVIDENCE_DIR/s3-encryption-config.json"

echo "Evidence collected in $EVIDENCE_DIR"
ls -la "$EVIDENCE_DIR/"
```

## GDPR Compliance Checklist

- [ ] Privacy policy is current and accurate
- [ ] Lawful basis documented for each processing activity
- [ ] ROPA (Record of Processing Activities) maintained
- [ ] Data subject rights procedures tested: access, erasure, portability, objection
- [ ] Data breach notification procedure: 72h to supervisory authority, without undue delay to individuals if high risk
- [ ] DPA (Data Processing Agreements) in place with all processors
- [ ] Privacy by design considered for new features
- [ ] Data retention schedules defined and enforced
- [ ] Cross-border transfers covered (SCCs or adequacy decision)

## SOC 2 Readiness Checklist

### Trust Service Criteria: Security (CC)

- [ ] CC6.1: Logical and physical access controls
- [ ] CC6.2: Prior to issuing system credentials, new users registered and authorized
- [ ] CC6.3: Role-based access controls (least privilege)
- [ ] CC6.6: External threats identified and mitigated (firewall, WAF)
- [ ] CC6.7: Encryption in transit and at rest
- [ ] CC7.1: Vulnerability management program
- [ ] CC7.2: Security monitoring and alerting
- [ ] CC7.3: Incident response procedures
- [ ] CC7.4: Security incidents documented and responded to
- [ ] CC8.1: Change management process

## Audit Preparation Timeline

```
T-6 months: Gap assessment — identify control gaps vs target framework
T-4 months: Remediation — implement missing controls
T-3 months: Evidence preparation — collect and organize evidence
T-2 months: Internal audit / dry run
T-1 month:  Auditor kickoff meeting, provide evidence package
T+0:        Audit fieldwork
T+4 weeks:  Draft report review
T+6 weeks:  Final report issued
```

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Manual evidence collection | Error-prone, slow, not repeatable | Automate with scripts |
| Collecting evidence after audit starts | Gaps discovered too late | Continuous evidence collection |
| Controls documented but not implemented | Audit findings, potential failure | Implement, then document |
| Shared accounts in audit logs | Cannot attribute actions to individuals | Enforce individual accounts |
| Audit logs in same DB as app data | Easy to tamper with, single failure | Separate, immutable log store |
| "Set and forget" compliance | Controls drift, next audit fails | Continuous monitoring |
