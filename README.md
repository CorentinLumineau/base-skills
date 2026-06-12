---
name: base-skills
description: 53 skills for AI coding agents — 17 always-on behavioural principles, an L2 knowledge layer covering security, architecture, testing, delivery, and more, plus 10 workflow orchestration skills.
---

# Base Skills

**53 skills** for AI coding agents in three tiers:

- **L1 — Behavioural skills (17)**: Always-on principles (Pareto focus, SOLID gate, review severity, root cause analysis, naming discipline). Applied automatically — no invocation needed.
- **L2 — Knowledge skills (26)**: On-demand domain expertise loaded when the agent needs deep procedural guidance (security audits, API design, testing strategies, CI/CD, data persistence, and more).
- **L3 — Workflow orchestration skills (10)**: Structured APEX/ONESHOT/DEBUG/BRAINSTORM workflows (x-auto, x-analyze, x-design, x-plan, x-implement, x-review, x-fix, x-troubleshoot, x-brainstorm, x-research).

## Install

### agentskills.io (primary — any compatible agent)

Install all skills:

```bash
npx skills add CorentinLumineau/base-skills
```

Individual skills:

```bash
npx skills add CorentinLumineau/base-skills --skill pareto-focus
npx skills add CorentinLumineau/base-skills --skill review-gate --skill naming --skill solid-gate
npx skills add CorentinLumineau/base-skills --skill '*'
```

List without installing:

```bash
npx skills add CorentinLumineau/base-skills --list
```

Skills are installed to `.agents/skills/<name>/SKILL.md` per the agentskills.io spec.

### Claude Code (one client)

```bash
claude mcp install CorentinLumineau/base-skills
```

Or clone and install locally:

```bash
git clone https://github.com/CorentinLumineau/base-skills
claude mcp install ./base-skills
```

> **Migration note**: Previous installs may have relied on `rules/quality-principles.md` as an
> auto-loaded rule file. That auto-load mechanism has been removed. To keep the same behaviour,
> copy `system-prompt.md` into your Claude Code project's `CLAUDE.md` or system instructions.

### Any other agent

Copy `system-prompt.md` into your agent's system instructions. It produces the same behavioural effect as all 17 L1 behavioural skills in under 500 tokens.

## Skills

### L1 — Behavioural Skills (17, always-on)

| # | Skill | Summary |
|---|-------|---------|
| 1 | [pareto-focus](skills/pareto-focus/SKILL.md) | Identify and protect the 20% of effort that delivers 80% of value |
| 2 | [hard-choice](skills/hard-choice/SKILL.md) | Evaluate easy-path (today) vs hard-path (2 years) before committing |
| 3 | [solid-gate](skills/solid-gate/SKILL.md) | Check every class/module/function against all five SOLID principles |
| 4 | [dry-kiss-yagni](skills/dry-kiss-yagni/SKILL.md) | No abstraction without 3 consumers, no speculative code, no deep nesting |
| 5 | [verification-evidence](skills/verification-evidence/SKILL.md) | Never claim completion without observable evidence (IDENTIFY→RUN→READ→VERIFY→CLAIM) |
| 6 | [design-challenge](skills/design-challenge/SKILL.md) | Adversarially evaluate every technical proposal; steelman alternatives |
| 7 | [future-proof](skills/future-proof/SKILL.md) | Make the 2-year maintenance cost visible before committing |
| 8 | [scout](skills/scout/SKILL.md) | Leave every touched file better than you found it; produce an Improvement Record |
| 9 | [anti-slop](skills/anti-slop/SKILL.md) | Flag AI-generated boilerplate, empty handlers, and single-consumer abstractions |
| 10 | [review-gate](skills/review-gate/SKILL.md) | Severity model (CRITICAL/HIGH/MEDIUM/LOW) with rationalization trap table |
| 11 | [root-cause](skills/root-cause/SKILL.md) | Apply 5 Whys before any fix; distinguish symptom from root cause |
| 12 | [scope-discipline](skills/scope-discipline/SKILL.md) | Define IS / IS NOT scope before starting; never fix outside it |
| 13 | [architecture-evidence](skills/architecture-evidence/SKILL.md) | Every significant decision needs an ADR with 2+ alternatives evaluated |
| 14 | [naming](skills/naming/SKILL.md) | All identifiers must pass the explains-itself test; ban generic names |
| 15 | [approval-gate](skills/approval-gate/SKILL.md) | Confirm before >3 files, irreversible actions, architecture decisions, or ambiguity |
| 16 | [error-handling](skills/error-handling/SKILL.md) | Classify failures before acting: transient/permanent/corruption with retry limits |
| 17 | [test-discipline](skills/test-discipline/SKILL.md) | TDD mandate: write the failing test before any implementation code |

### L3 — Workflow Orchestration Skills (10, on-demand)

| # | Skill | Chain | Summary |
|---|-------|-------|---------|
| 18 | [x-auto](skills/x-auto/SKILL.md) | All | Entry point and workflow classifier for APEX, ONESHOT, DEBUG, and BRAINSTORM chains |
| 19 | [x-analyze](skills/x-analyze/SKILL.md) | APEX 1/6 | Assess a codebase across quality, security, performance, and architecture domains |
| 20 | [x-design](skills/x-design/SKILL.md) | APEX 2/6 | Architectural decision records (ADR) with trade-off analysis; gates before planning |
| 21 | [x-plan](skills/x-plan/SKILL.md) | APEX 3/6 | Create an implementation plan with task breakdown and acceptance criteria |
| 22 | [x-implement](skills/x-implement/SKILL.md) | APEX 4/6 | Implement planned changes following test-driven development (TDD) |
| 23 | [x-review](skills/x-review/SKILL.md) | APEX 5/6 | Post-implementation quality gate; blocks on CRITICAL and HIGH findings |
| 24 | [x-fix](skills/x-fix/SKILL.md) | ONESHOT 1/2 | Quick targeted fix for an identified bug, followed by a commit approval gate |
| 25 | [x-troubleshoot](skills/x-troubleshoot/SKILL.md) | DEBUG 1/2 | Hypothesis-driven diagnosis for errors with unknown root causes |
| 26 | [x-brainstorm](skills/x-brainstorm/SKILL.md) | BRAINSTORM 1/3 | Structured exploration of a vague idea from multiple angles |
| 27 | [x-research](skills/x-research/SKILL.md) | BRAINSTORM 2/3 | Evidence-based investigation answering specific questions before design |

### L2 — Knowledge Skills (26, on-demand)

Load a knowledge skill when the agent needs deep domain expertise for a specific task.

**Code quality**

| # | Skill | Summary |
|---|-------|---------|
| 24 | [code-api-design](skills/code-api-design/SKILL.md) | REST/GraphQL API design: resource naming, versioning, pagination, SDK patterns |
| 25 | [code-code-quality](skills/code-code-quality/SKILL.md) | SOLID, DRY, KISS, YAGNI enforcement with refactoring patterns and code review practices |
| 26 | [code-design-patterns](skills/code-design-patterns/SKILL.md) | Gang of Four creational, structural, and behavioral patterns with selection guidance |
| 27 | [code-error-handling](skills/code-error-handling/SKILL.md) | Fail-fast patterns, try-catch practices, async errors, error monitoring |

**Security**

| # | Skill | Summary |
|---|-------|---------|
| 28 | [security-git](skills/security-git/SKILL.md) | GPG signing, secret scanning, hook security, and Git repository hardening |
| 29 | [security-identity-access](skills/security-identity-access/SKILL.md) | IAM, RBAC/ABAC, OAuth flows, JWT patterns, MFA implementation |
| 30 | [security-owasp](skills/security-owasp/SKILL.md) | OWASP Top 10 2021 detection/prevention + input validation, API security, security checklist |
| 31 | [security-secrets-supply-chain](skills/security-secrets-supply-chain/SKILL.md) | Secrets rotation, dependency scanning, container security, SLSA levels |

**Quality**

| # | Skill | Summary |
|---|-------|---------|
| 32 | [quality-debugging-performance](skills/quality-debugging-performance/SKILL.md) | Systematic debugging methodology, profiling, caching, database optimization |
| 33 | [quality-observability](skills/quality-observability/SKILL.md) | Logs, metrics, traces, k6 load testing, OpenTelemetry, structured logging |
| 34 | [quality-testing](skills/quality-testing/SKILL.md) | Testing pyramid, TDD patterns, coverage gates, mocking, eval-driven development |

**Data**

| # | Skill | Summary |
|---|-------|---------|
| 35 | [data-data-persistence](skills/data-data-persistence/SKILL.md) | Relational/NoSQL schema design, caching, migrations, PostgreSQL, Redis, MongoDB |
| 36 | [data-messaging](skills/data-messaging/SKILL.md) | Message queues, event-driven patterns, Kafka, RabbitMQ |

**Delivery**

| # | Skill | Summary |
|---|-------|---------|
| 37 | [delivery-ci-cd-delivery](skills/delivery-ci-cd-delivery/SKILL.md) | CI/CD pipelines, deployment strategies, GitHub Actions, GitLab CI, rollback |
| 38 | [delivery-infrastructure](skills/delivery-infrastructure/SKILL.md) | IaC, Docker, Kubernetes, Terraform, feature flags |
| 39 | [delivery-release-git](skills/delivery-release-git/SKILL.md) | Semantic versioning, changelog generation, release automation, branching strategy |

**Architecture & Meta**

| # | Skill | Summary |
|---|-------|---------|
| 40 | [meta-analysis-architecture](skills/meta-analysis-architecture/SKILL.md) | Pareto analysis, ADRs, trade-off frameworks, architecture pattern selection |
| 41 | [meta-persuasion-principles](skills/meta-persuasion-principles/SKILL.md) | Influence psychology, anti-rationalization, enforcement gate design |
| 42 | [meta-rearchitect](skills/meta-rearchitect/SKILL.md) | Coupling audits, SOLID at scale, architectural anti-patterns, refactoring decision tree |

**Operations**

| # | Skill | Summary |
|---|-------|---------|
| 43 | [operations-incident-response](skills/operations-incident-response/SKILL.md) | Incident lifecycle, severity classification, communication templates, post-mortems |
| 44 | [operations-sre-operations](skills/operations-sre-operations/SKILL.md) | SLOs, error budgets, alerting, SRE practices, disaster recovery |

**VCS & Compliance**

| # | Skill | Summary |
|---|-------|---------|
| 45 | [vcs-conventional-commits](skills/vcs-conventional-commits/SKILL.md) | Conventional Commits spec: types, scopes, breaking changes, changelog generation |
| 46 | [vcs-forge-operations](skills/vcs-forge-operations/SKILL.md) | Cross-forge PR/issue operations (GitHub and Gitea CLI equivalences) |
| 47 | [vcs-git-workflows](skills/vcs-git-workflows/SKILL.md) | Conflict resolution, rebase strategies, history navigation, advanced Git |
| 48 | [compliance-audit-compliance](skills/compliance-audit-compliance/SKILL.md) | SOC 2, GDPR, HIPAA, PCI DSS — compliance controls, audit trails, evidence collection |

**Diagrams**

| # | Skill | Summary |
|---|-------|---------|
| 49 | [diagram-mermaid](skills/diagram-mermaid/SKILL.md) | Mermaid diagram syntax: flowcharts, sequence diagrams, entity-relationship, Gantt |

## Files

```
skills/<name>/SKILL.md   — full skill definition (agentskills.io spec-conformant)
system-prompt.md         — condensed ~500-token block for any agent (primary portability artifact)
quick-reference.md       — one-table lookup with self-check questions (primary portability artifact)
CLAUDE.md                — Claude Code convenience pointer (Claude Code only)
rules/quality-principles.md — optional reading material (Claude Code only; not auto-loaded)
```

## Always-On Delivery

Base Skills operates on two tiers optimised for different use cases.

**Tier 1 — Always-On Principal Block (`system-prompt.md`)**: A compact, provider-agnostic block of approximately 600 tokens that encodes all 17 behavioral principles as direct first-person rules. Copy this file into any agent's system instructions and the principles apply automatically to every task — no invocation, no skill loading, no configuration. This is the primary delivery vehicle for teams that need consistent behavioral governance across Claude Code, OpenAI, Gemini, local models, or any other agent runtime.

**Tier 2 — On-Demand Skills (`skills/*/SKILL.md`)**: The full corpus of 53 skills. Each L1 skill includes Why, Always, Never, Gate, and Artifact sections. Each L2 knowledge skill includes domain checklists, pattern tables, detection rules, and worked examples. Each L3 workflow skill includes a phase checklist, output template, WORKFLOW.md template, and (where required) an approval gate. Load a specific SKILL.md only when the agent needs deep domain guidance — for example, load `security-owasp` during a security audit, `quality-testing` when setting up a test strategy, or `x-design` when making an architectural decision.

**Why the two-tier model matters for token economy**: Loading all 53 skills on every task is unnecessary and expensive. The always-on block provides behavioral governance at ~600 tokens for routine tasks. The full corpus is reserved for tasks that require deep procedural guidance. Load the relevant skill only when the domain expertise or workflow structure is needed.

**When to use which tier**:
- Always: inject `system-prompt.md` into system instructions once; never remove it mid-session
- On-demand: reference a specific SKILL.md when the task needs domain expertise (security audit → `security-owasp`; API design → `code-api-design`; ADR creation → `architecture-evidence`; code review → `review-gate`)
- Never: load all 49 SKILL.md files unless building a comprehensive multi-domain agent

**Sync governance**: `system-prompt.md` is derived from the 17 behavioral SKILL.md files using `make generate`. Run `make check-drift` at any time to verify the file has not drifted from its generated baseline.

## Design

Concepts live in exactly one skill. Cross-skill references are pointers (`→ See [skill-name]`),
never restatements. The severity model (CRITICAL/HIGH/MEDIUM/LOW) is defined once in
`review-gate` and referenced everywhere else. The 3-consumer rule is defined once in
`dry-kiss-yagni`. The diff boundary is defined once in `scope-discipline`.

## Development

### Always-on block sync

```bash
# Regenerate system-prompt.md from the 17 behavioral SKILL.md files
make generate

# Verify system-prompt.md has not drifted from its generated baseline (exits 1 on drift)
make check-drift
```

`make generate` — offline, no network. Reads the first `## Always` and `## Never` bullet from each of the 17 behavioral SKILL.md files and writes `system-prompt.md`. Run after editing any behavioral skill.

`make check-drift` — fails with exit code 1 and a diff if `system-prompt.md` differs from what `make generate` would produce. Use as a pre-commit or CI gate.

Alternative without `make`: `bash scripts/generate-system-prompt.sh` (generate) or `bash scripts/generate-system-prompt.sh --check` (drift check).

**Round-trip integrity test** (four steps):
1. `make generate` — must exit 0 and write `system-prompt.md`
2. `make check-drift` — must exit 0 on the unaltered file
3. Manually alter one line in any `skills/*/SKILL.md`, then `make check-drift` — must exit 1
4. Revert the edit, run `make generate` then `make check-drift` — must exit 0 again

### Conformance gate

```bash
# Install skills-ref validator
npm install -g skills-ref

# Validate all 23 skills
make validate
```

If `skills-ref` is not yet available, run the manual check:

```bash
grep -r "user-invocable:" skills/ && echo "FAIL: non-spec key found" || echo "PASS"
grep -r "\*\*activation\*\*:" skills/ && echo "FAIL: non-spec body line found" || echo "PASS"
```

---

Compatible with all agents listed at [agentskills.io](https://agentskills.io).
