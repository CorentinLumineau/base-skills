# Control Mapping

Cross-framework control mapping tables for implementing controls that satisfy multiple frameworks simultaneously.

## Access Control

| Control | SOC 2 | ISO 27001 | GDPR | PCI-DSS | HIPAA |
|---------|-------|----------|------|---------|-------|
| Unique user accounts, no sharing | CC6.2 | A.9.2.1 | Art. 32 | Req 8.2.1 | §164.312(a)(2)(i) |
| MFA for privileged access | CC6.1 | A.9.4.2 | Art. 32 | Req 8.3.1 | §164.312(d) |
| MFA for remote access | CC6.6 | A.9.4.2 | Art. 32 | Req 8.3.2 | §164.312(d) |
| Least privilege | CC6.3 | A.9.2.3 | Art. 5(1)(c) | Req 7.1 | §164.312(a)(1) |
| Access reviews (quarterly) | CC6.2 | A.9.2.6 | Art. 5 | Req 7.2.3 | §164.312(a)(1) |
| Immediate access revocation on termination | CC6.3 | A.9.2.6 | Art. 5 | Req 8.2.6 | §164.312(a)(2)(i) |

## Data Protection

| Control | SOC 2 | ISO 27001 | GDPR | PCI-DSS | HIPAA |
|---------|-------|----------|------|---------|-------|
| Encryption at rest (AES-256) | CC6.7 | A.10.1.1 | Art. 32 | Req 3.4 | §164.312(a)(2)(iv) |
| Encryption in transit (TLS 1.2+) | CC6.7 | A.13.2.3 | Art. 32 | Req 4.2 | §164.312(e)(2)(ii) |
| Key management procedures | CC6.7 | A.10.1.2 | Art. 32 | Req 3.6 | §164.312(a)(2)(iv) |
| Data classification policy | CC6.5 | A.8.2 | Art. 5 | Req 3.1 | §164.514 |
| Secure deletion / media sanitization | CC6.5 | A.8.3.2 | Art. 17 | Req 9.4 | §164.310(d)(2)(i) |

## Monitoring and Logging

| Control | SOC 2 | ISO 27001 | GDPR | PCI-DSS | HIPAA |
|---------|-------|----------|------|---------|-------|
| Audit log of all privileged actions | CC7.2 | A.12.4.1 | Art. 5 | Req 10.2 | §164.312(b) |
| Log integrity (tamper-proof) | CC7.2 | A.12.4.2 | Art. 32 | Req 10.5 | §164.312(b) |
| Log retention ≥ 1 year | CC7.2 | A.12.4.1 | Art. 30 | Req 10.7 | §164.312(b) |
| Alerting on anomalous access | CC7.3 | A.12.4.1 | Art. 32 | Req 10.6 | §164.312(b) |
| Failed login attempt detection | CC7.3 | A.12.4.1 | — | Req 10.6.3 | — |

## Vulnerability Management

| Control | SOC 2 | ISO 27001 | GDPR | PCI-DSS | HIPAA |
|---------|-------|----------|------|---------|-------|
| Vulnerability scanning (quarterly) | CC7.1 | A.12.6.1 | Art. 32 | Req 6.3.3 | §164.308(a)(1) |
| Penetration testing (annual) | CC7.1 | A.12.6.1 | Art. 32 | Req 11.4.3 | §164.308(a)(1) |
| Critical patch within 30 days | CC7.1 | A.12.6.1 | Art. 32 | Req 6.3.3 | §164.308(a)(1) |
| Dependency scanning | CC7.1 | A.12.6.1 | — | Req 6.3.2 | — |

## Incident Response

| Control | SOC 2 | ISO 27001 | GDPR | PCI-DSS | HIPAA |
|---------|-------|----------|------|---------|-------|
| Written IR plan | CC7.3 | A.16.1.1 | Art. 33 | Req 12.10 | §164.308(a)(6) |
| IR plan tested annually | CC7.3 | A.16.1.1 | Art. 32 | Req 12.10.2 | §164.308(a)(6) |
| Breach notification procedure | CC7.4 | A.16.1.3 | Art. 33, 34 | Req 12.10 | §164.408 |
| Post-mortem for major incidents | CC7.3 | A.16.1.6 | — | Req 12.10.1 | §164.308(a)(6) |

## Change Management

| Control | SOC 2 | ISO 27001 | GDPR | PCI-DSS | HIPAA |
|---------|-------|----------|------|---------|-------|
| Approved change process | CC8.1 | A.12.1.2 | — | Req 6.4 | §164.308(a)(8) |
| Code review before deploy | CC8.1 | A.14.2.2 | — | Req 6.4.2 | — |
| Separate dev/test/prod environments | CC8.1 | A.12.1.4 | — | Req 6.4.1 | — |
| Change rollback capability | CC8.1 | A.12.1.2 | — | Req 6.4.4 | — |

## Control Implementation Priority

For organizations pursuing SOC 2 Type II as first certification:

**Phase 1 (months 1-2)**: Access control, MFA, logging
- Highest risk, most commonly tested controls
- Foundation for all other controls

**Phase 2 (months 3-4)**: Encryption, vulnerability management
- Technical controls that take time to implement and evidence

**Phase 3 (months 5-6)**: Change management, vendor management, policies
- Documentation-heavy, needs organizational buy-in

**Ongoing**: Evidence collection, access reviews, training records
- Evidence of sustained operation required for Type II
