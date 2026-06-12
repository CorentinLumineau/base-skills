# M3 Activation Boundary Audit

**Milestone**: base-skills-whole-plugin-distillation M3
**Date**: 2026-06-12
**Skills audited**: `vcs-conventional-commits`, `security-owasp`, `x-fix`

---

## Test Prompt Table

Each prompt is labeled with the expected activating skill.

| # | Test Prompt | Expected Skill | Rationale |
|---|-------------|---------------|-----------|
| 1 | "Write a commit message for adding OAuth2 login" | `vcs-conventional-commits` | "commit message" is an explicit activation keyword |
| 2 | "Review my commit history — do these follow conventional commits?" | `vcs-conventional-commits` | "conventional commits" keyword |
| 3 | "Should I use `feat` or `chore` for updating a dependency?" | `vcs-conventional-commits` | Type selection is commit-authoring vocabulary |
| 4 | "Audit this login endpoint for SQL injection and XSS vulnerabilities" | `security-owasp` | "SQL injection", "XSS" are explicit OWASP keywords |
| 5 | "Check this code against OWASP Top 10" | `security-owasp` | "OWASP Top 10" is a primary activation keyword |
| 6 | "Is this API endpoint vulnerable to SSRF?" | `security-owasp` | "SSRF" and "vulnerable" are distinct OWASP-domain keywords |
| 7 | "There's a null pointer exception in auth.ts at line 42 — fix it" | `x-fix` | "fix", "targeted bug" — ONESHOT workflow trigger |
| 8 | "Fix this error: TypeError: Cannot read property 'id' of undefined" | `x-fix` | "fix this error" → ONESHOT fix activation |
| 9 | "I need to correct the bug where users can see other users' data" | `x-fix` | "correct the bug" → ONESHOT; contrast with security-owasp (no audit requested) |

---

## Cross-Activation Overlap Check

### vcs-conventional-commits vs security-owasp

No keyword overlap detected. `vcs-conventional-commits` activates on commit vocabulary
(`commit message`, `feat`, `fix`, `BREAKING CHANGE`, `changelog`). `security-owasp` activates
on vulnerability vocabulary (`OWASP`, `injection`, `XSS`, `SSRF`, `CWE`, `security audit`).
**Result: CLEAN** — zero lexical overlap.

### security-owasp vs review-gate

`review-gate` activates on "code review", "pull request review", "architectural review".
`security-owasp` activates on "security audit", "security review", "vulnerability assessment".
Potential soft collision: the phrase "security review" could match `review-gate` triggers.
**Result: LOW RISK** — `review-gate` focuses on severity model during any review;
`security-owasp` focuses on OWASP-specific vulnerability patterns. The two are complementary
and intended to co-activate during a security code review. No sharpening needed.

### security-owasp vs solid-gate

`solid-gate` activates on writing or modifying any class/module. `security-owasp` activates
on security-specific vocabulary. No overlap.
**Result: CLEAN**

### x-fix vs security-owasp (cross-type check)

Prompt 9 tests the boundary: a data access control bug could trigger both `x-fix` (there is
a bug to fix) and `security-owasp` (broken access control is OWASP A01). These are not
mutually exclusive — `security-owasp` identifies the category and severity; `x-fix` drives
the repair workflow. Both should activate and are complementary.
**Result: INTENTIONAL CO-ACTIVATION** — no sharpening needed.

---

## F0 Audit Results for x-fix

| Check | Status | Evidence |
|-------|--------|----------|
| Real checklist referenced at phase start | PASS | SKILL.md line 21: "Read `references/checklist.md` at phase start" |
| `## Gotchas` section with ≥3 concrete items | PASS | 4 gotchas present (symptom vs root cause, scope discipline, upgrade trigger, regression test) |
| Output template exists and referenced | PASS | `references/output-template.md` exists; referenced in checklist Phase 4 completion |
| Validation loop (Phase 4 Verify) in checklist | PASS | checklist.md has Phase 4 with 4 verify steps |
| Not hollow | PASS | SKILL.md contains Key Steps, Phase Overview, Workflow Navigation, Gotchas |
| `assets/WORKFLOW.md.template` exists | PASS | File confirmed present |

**All 6 F0 bullets: PASS. No edits required.**

---

## Validate Tool Status

`skills-ref` was not found on PATH. Manual frontmatter conformance applied per milestone
edge-case fallback:
- No `user-invocable:`, `allowed-tools:`, or `category:` fields in either ported skill ✓
- `name` field matches directory name in both skills ✓
- `description` is non-empty and contains WHAT+WHEN+keywords in both skills ✓

This gap (missing `skills-ref` CLI) is a concrete risk item for M4: automated conformance
validation is not available. Recommendation: add `skills-ref` installation to the project's
README or Makefile bootstrap before scaling M4 skill ports.

---

## M4/M5 Recommendations

1. **Install `skills-ref` before M4**: The `validate-manual` fallback only checks 3 of the
   spec constraints. Before scaling to the M4 knowledge-skill batch, add
   `npm install -g skills-ref` to the Makefile or README bootstrap so every port can be
   machine-verified. Without it, conformance rests entirely on author discipline.

2. **Add OWASP-specific terms to `security-owasp` description if overlap widens**: Current
   description already contains `OWASP Top 10`, `CWE`, `injection`, `XSS attack`, `SSRF` —
   well-differentiated from `review-gate` and `solid-gate`. If M4 ports more security
   knowledge skills (e.g., `security-identity-access`), add distinguishing terms to
   each description to prevent ambiguity between authentication patterns and OWASP audit scope.

3. **`vcs-conventional-commits` references files were empty stubs in the source**: The mercure
   source `references/automation-tools.md` and `references/commit-type-catalog.md` are 0-byte
   stubs. Content was inlined in SKILL.md instead. For M4, verify whether mercure reference
   files are populated before porting — empty stubs are common and require inline expansion.
