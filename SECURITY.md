# Security Policy

## Supported Versions

| Version | Security fixes |
|---------|---------------|
| `v0.2.1` (current) | Yes |
| `v0.2.0` | No — upgrade to `v0.2.1` (ships broken `CHECKSUMS.md` and no `LICENSE`) |
| `v0.1.x` and earlier | No — upgrade to `v0.2.1` |

This repository contains plain Markdown skill files injected into AI agent system prompts.
The threat model is **content tampering and prompt injection**, not software CVEs in compiled
code. There are no compiled binaries, runtime dependencies, or network services in this
repository.

## Reporting a Vulnerability

Use **GitHub's private vulnerability disclosure** feature:
[https://github.com/CorentinLumineau/base-skills/security/advisories/new](https://github.com/CorentinLumineau/base-skills/security/advisories/new)

Do not open a public issue for security reports. The disclosure will remain confidential
until a fix is published.

**Response SLA**:

| Step | Target |
|------|--------|
| Acknowledgement | Within **72h** of receipt |
| Initial assessment | Within 5 business days |
| Patch (if applicable) | Within 30 days for HIGH findings; 90 days for MEDIUM |
| Public disclosure | After patch is released and consumers have had time to update |

If you cannot use GitHub private disclosure, send a plain-text email to
`lumineau.corentin11@gmail.com` with the subject line `[base-skills] Security report`.

## Scope

**In scope** — please report:

- A SKILL.md file contains instructions that, when injected into an agent's system prompt,
  could cause the agent to exfiltrate data, bypass safety measures, or execute unauthorized
  actions (prompt injection via skill content).
- The `system-prompt.md` file contains adversarial instructions that could manipulate agent
  behavior in harmful ways when copied as-is into a system prompt.
- A supply-chain scenario in which `CHECKSUMS.md` entries do not match the published files,
  indicating potential tampering between the repository and the consumer's install path.
- Any mechanism by which the `npx skills add` install pipeline could deliver tampered content
  without detection.

**Out of scope** — please do not report:

- Security vulnerabilities in `npx` / npm itself, the `skills-ref` validator, or the
  `agentskills.io` registry infrastructure. Report those to the respective maintainers.
- The underlying AI model's safety properties (e.g., whether a model can be jailbroken
  via a skill — that is the model provider's responsibility).
- Informational findings with no plausible attack vector against skill consumers.
- Findings in archived or deprecated skill versions no longer present on `main`.

## Threat Model Summary

Skills are **text content** injected verbatim into AI agent system prompts. The primary
attack surfaces are:

| Threat | Category | Control |
|--------|----------|---------|
| Skill content modified in transit (CDN or registry) | Tampering | `CHECKSUMS.md` SHA-256 per file; pinned `@v0.2.1` install |
| `CHECKSUMS.md` tampered alongside skill files | Tampering | Pin `CHECKSUMS.md` hash in CI; future: GPG-signed releases |
| Adversarial instructions injected into a skill file | Prompt injection | Code review gate on all PRs; no auto-merge |

There are no SQL queries, no compiled code, no secrets, and no network endpoints in this
repository.

## Disclosure Timeline

1. **Receive** — Reporter submits via private disclosure or email.
2. **Acknowledge** — Maintainer acknowledges within 72 hours; assigns preliminary severity.
3. **Investigate** — Root-cause analysis; reproduce the issue; determine affected versions.
4. **Patch** — Correct the skill content and/or regenerate `CHECKSUMS.md`; cut a new release.
5. **Notify** — Private notification to reporter; draft public advisory.
6. **Publish** — Merge patch to `main`; push new tag; publish GitHub Security Advisory.

The reporter will be credited in the advisory unless they request otherwise.

## Future Enhancements

The following controls are planned but not yet implemented for `v0.2.1`:

- **GPG-signed releases** — each tag will include a detached `.asc` signature; consumers
  can verify the tag was created by the maintainer's key.
- **CI checksum drift gate** — automated check that `sha256sum --check CHECKSUMS.md` passes
  on every PR, preventing undetected edits to skill files.
