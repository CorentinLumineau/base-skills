# Evidence Collection

Procedures for collecting, organizing, and presenting compliance evidence.

## Evidence Types

| Type | Description | Format | Freshness |
|------|-------------|--------|---------|
| Configuration snapshots | Current state of security settings | JSON/screenshot | At time of audit |
| Access roster | User list with roles and MFA status | CSV/JSON + signature | Monthly |
| Access review records | Confirmed/revoked access at review date | Signed document | Quarterly |
| Vulnerability scan results | CVSS findings and remediation status | PDF/JSON | Quarterly |
| Penetration test report | External/internal pen test findings | PDF | Annual |
| Training completion | % staff completed security training | LMS export | Annual or on demand |
| Incident records | Post-mortems and response timelines | Export from ticketing | Per incident |
| Change management logs | Approved changes with sign-offs | ITSM export | Continuous |
| Backup test results | Restore success/failure records | Test report | Monthly |
| Vendor assessments | Third-party risk reviews | Questionnaire + rating | Annual per vendor |

## Evidence Package Structure

```
evidence/
├── {YYYY-MM-DD}-audit-package/
│   ├── README.md               ← index of all evidence with collection dates
│   ├── access/
│   │   ├── user-roster.json    ← all users + roles
│   │   ├── mfa-status.json     ← MFA enabled/disabled per user
│   │   ├── privileged-users.json ← admin/privileged account list
│   │   └── access-review-Q1.pdf  ← signed quarterly review
│   ├── security/
│   │   ├── vulnerability-scan-{date}.json
│   │   ├── pentest-report-{year}.pdf
│   │   └── patch-status.json
│   ├── monitoring/
│   │   ├── alerting-config.json
│   │   └── log-retention-config.json
│   ├── encryption/
│   │   ├── s3-encryption.json
│   │   ├── db-encryption.json
│   │   └── tls-configuration.json
│   ├── change-management/
│   │   └── change-log-{period}.csv
│   └── training/
│       └── security-training-completion.csv
```

## Automated Evidence Collection Scripts

### User Roster and MFA Status (GitHub)

```bash
#!/usr/bin/env bash
# collect-github-org-evidence.sh

ORG="${GITHUB_ORG:?}"
DATE=$(date +%Y-%m-%d)

# Export all organization members
gh api "orgs/${ORG}/members" --paginate \
  | jq '[.[] | {login, site_admin, type}]' \
  > "evidence/access/github-members-${DATE}.json"

# Members without MFA
gh api "orgs/${ORG}/members?filter=2fa_disabled" --paginate \
  | jq '[.[] | .login]' \
  > "evidence/access/github-no-mfa-${DATE}.json"

# Admins
gh api "orgs/${ORG}/members?role=admin" --paginate \
  | jq '[.[] | .login]' \
  > "evidence/access/github-admins-${DATE}.json"

echo "GitHub evidence collected for org: $ORG"
```

### AWS Configuration Evidence

```bash
#!/usr/bin/env bash
# collect-aws-evidence.sh

DATE=$(date +%Y-%m-%d)

# S3 bucket encryption
aws s3api list-buckets --query 'Buckets[].Name' --output text \
  | tr '\t' '\n' | while read bucket; do
    aws s3api get-bucket-encryption --bucket "$bucket" 2>/dev/null \
      && echo "Bucket $bucket: encrypted" \
      || echo "Bucket $bucket: NOT encrypted"
  done > "evidence/encryption/s3-encryption-${DATE}.txt"

# CloudTrail enabled
aws cloudtrail describe-trails --output json \
  > "evidence/monitoring/cloudtrail-config-${DATE}.json"

# IAM users with MFA disabled
aws iam generate-credential-report
sleep 5
aws iam get-credential-report --query 'Content' --output text \
  | base64 -d \
  | awk -F, '$8=="false" {print $1}' \
  > "evidence/access/iam-no-mfa-${DATE}.txt"

# IAM password policy
aws iam get-account-password-policy \
  > "evidence/access/iam-password-policy-${DATE}.json"
```

### Database Encryption Status

```bash
# PostgreSQL: check if encryption-at-rest is enabled
# (depends on cloud provider — check via cloud API)

# AWS RDS
aws rds describe-db-instances \
  --query 'DBInstances[*].{ID:DBInstanceIdentifier, Encrypted:StorageEncrypted}' \
  --output json \
  > "evidence/encryption/rds-encryption-status-${DATE}.json"

# Check TLS in use
psql "${DATABASE_URL}" -c "SHOW ssl;" > "evidence/encryption/db-ssl-status-${DATE}.txt"
```

## Evidence Quality Standards

### What Makes Good Evidence

| Criterion | Requirement |
|-----------|-------------|
| Authenticity | Directly exported from system (not manually typed) |
| Integrity | Hash or signature where possible |
| Timeliness | Collected within the audit window |
| Completeness | All in-scope systems covered |
| Legibility | Auditor can understand without explanation |

### Evidence Metadata

Every evidence file should have an accompanying metadata entry:

```json
{
  "file": "user-roster-2024-01-15.json",
  "description": "Complete list of all organization members with roles",
  "source": "GitHub API: GET /orgs/{org}/members",
  "collected_by": "automation/collect-evidence.sh",
  "collected_at": "2024-01-15T09:00:00Z",
  "collected_by_person": "alice@example.com",
  "controls_evidenced": ["CC6.2", "CC6.3", "A.9.2.1"],
  "sha256": "abc123..."
}
```

## Evidence Review Checklist

Before submitting evidence package to auditor:

- [ ] All files have collection timestamps
- [ ] Collection period covers the audit period
- [ ] All in-scope systems are represented
- [ ] No evidence was manually created/modified (all system exports)
- [ ] Access review signatures are from authorized reviewers
- [ ] Vulnerability findings have remediation evidence or risk acceptance
- [ ] No sensitive data in evidence files (mask PAN, PHI, passwords)
- [ ] README index is complete and accurate

## Common Evidence Gaps and Fixes

| Gap | Fix |
|----|-----|
| No quarterly access review | Schedule recurring reminder + template |
| Vulnerability scan older than 90 days | Run scanner, export report |
| Training records incomplete | Export from LMS before audit |
| No documentation for vendor assessments | Questionnaire template + tracking spreadsheet |
| Change management without approvals | Enforce required approvers in forge (branch protection) |
| Audit logs with gaps | Investigate and document reason; continuous log monitoring prevents recurrence |
