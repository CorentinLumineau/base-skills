# Compliance Frameworks

Detailed requirements for major compliance frameworks.

## SOC 2 (Trust Service Criteria)

SOC 2 is an audit of controls relevant to security, availability, processing integrity,
confidentiality, and/or privacy of data managed by a service organization.

### Type I vs Type II

| | SOC 2 Type I | SOC 2 Type II |
|-|-------------|--------------|
| What | Controls are suitably designed | Controls are operating effectively |
| Period | Point in time | 6-12 months of operation |
| Value | Starting point | More trusted by customers |

### Common Criteria (CC) — Security Domain

| Criterion | Requirement |
|-----------|-------------|
| CC1.1-1.5 | Control environment: commitment to integrity, board oversight, organizational structure |
| CC2.1-2.3 | Communication of information |
| CC3.1-3.4 | Risk assessment and risk management |
| CC4.1-4.2 | Monitoring activities |
| CC5.1-5.3 | Control activities, technology controls |
| CC6.1-6.8 | Logical and physical access |
| CC7.1-7.5 | System operations and change management |
| CC8.1 | Change management |
| CC9.1-9.2 | Risk mitigation |

### Additional Categories

- **A** — Availability: System availability meets objectives
- **PI** — Processing Integrity: Complete, accurate, timely processing
- **C** — Confidentiality: Information designated confidential is protected
- **P** — Privacy: Personal information collected, used, retained, disclosed per AICPA

## ISO 27001

Framework for establishing, implementing, maintaining, and improving an Information Security
Management System (ISMS).

### Annex A Control Categories

| Domain | Controls |
|--------|---------|
| A.5: Information security policies | Policy documents, review cycle |
| A.6: Organization of information security | Roles, remote work, mobile devices |
| A.7: Human resource security | Background checks, training, termination |
| A.8: Asset management | Inventory, classification, handling |
| A.9: Access control | Access policy, user management, privileges |
| A.10: Cryptography | Encryption policy, key management |
| A.11: Physical security | Secure areas, equipment security |
| A.12: Operations security | Change management, malware, backups, monitoring |
| A.13: Communications security | Network controls, information transfer |
| A.14: System acquisition & development | Secure development, change control |
| A.15: Supplier relationships | Supplier policy, agreements, monitoring |
| A.16: Incident management | Reporting, response, learning |
| A.17: Business continuity | Planning, procedures, verification |
| A.18: Compliance | Legal requirements, review |

### Certification Process

1. Gap assessment
2. Risk assessment (ISO 27005 methodology)
3. Statement of Applicability (SoA)
4. Risk treatment plan
5. Implement controls
6. Internal audit
7. Management review
8. Stage 1 audit (documentation review)
9. Stage 2 audit (implementation review)
10. Certification issued (valid 3 years, with annual surveillance audits)

## GDPR

Regulation (EU) 2016/679 — applies to any organization processing personal data of EU residents.

### Key Principles (Article 5)

| Principle | Requirement |
|-----------|-------------|
| Lawfulness, fairness, transparency | Must have legal basis; inform data subjects |
| Purpose limitation | Collect for specified, explicit purposes only |
| Data minimization | Collect only what is necessary |
| Accuracy | Keep data accurate and up to date |
| Storage limitation | Keep only as long as necessary |
| Integrity and confidentiality | Appropriate security measures |
| Accountability | Demonstrate compliance |

### Legal Bases (Article 6)

- Consent (freely given, specific, informed, unambiguous)
- Contract (necessary for contract performance)
- Legal obligation
- Vital interests
- Public task
- Legitimate interests (balance test required)

### Data Subject Rights

| Right | Requirement | SLA |
|-------|-------------|-----|
| Access (Art. 15) | Provide copy of personal data | 1 month |
| Rectification (Art. 16) | Correct inaccurate data | 1 month |
| Erasure (Art. 17) | "Right to be forgotten" | 1 month |
| Restriction (Art. 18) | Stop processing in certain cases | 1 month |
| Portability (Art. 20) | Machine-readable data export | 1 month |
| Objection (Art. 21) | Stop processing for direct marketing | Immediate |

### Breach Notification

- To supervisory authority: within 72 hours of becoming aware (Art. 33)
- To data subjects: without undue delay when high risk (Art. 34)

## PCI-DSS v4.0

Payment Card Industry Data Security Standard for organizations handling cardholder data.

### 12 Requirements

| Req | Domain | Key controls |
|-----|--------|-------------|
| 1-2 | Network security | Firewalls, secure configurations, no defaults |
| 3-4 | Protect account data | Encryption at rest (3.4), in transit (4.2) |
| 5-6 | Vulnerability management | Antivirus, secure development, patches |
| 7-8 | Access control | Least privilege, MFA for admin (8.3), unique IDs |
| 9 | Physical security | Physical access controls, visitor management |
| 10 | Logging and monitoring | Log all access, retain 1 year (3 months immediately available) |
| 11 | Testing | Vulnerability scans (quarterly), pen tests (annual) |
| 12 | Policy | Security policy, incident response |

### Scope Reduction

The best PCI-DSS strategy is scope reduction: minimize where cardholder data is stored, processed, or transmitted.

- Use tokenization (store token, not PAN)
- Use hosted payment pages (card data never touches your servers)
- Segment the cardholder data environment (CDE) from the rest of the network

## HIPAA

Health Insurance Portability and Accountability Act — US federal law protecting PHI.

### Safeguard Categories

| Category | Required | Examples |
|----------|---------|---------|
| Administrative | Yes | Security officer, training, risk analysis, workforce procedures |
| Physical | Yes | Facility access, workstation security, device disposal |
| Technical | Yes | Access controls, audit logs, encryption, automatic logoff |

### Key Requirements

- Risk analysis required before implementation and when major changes occur
- Business Associate Agreements (BAA) required for all vendors handling PHI
- Breach notification: individuals within 60 days, HHS annually (or within 60 days for >500 individuals)
- Right of access: provide PHI to individuals within 30 days
- Minimum necessary standard: access only what is needed for the task
