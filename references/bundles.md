# Skill Bundles

Loading all 53 skills on every task consumes approximately **30K tokens** — expensive and
usually unnecessary. Bundles let you load only what a session needs: 50–75% fewer tokens
for focused work.

## How to Use a Bundle

Install a bundle with pinned syntax so you always get verified content:

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill <name1> --skill <name2> ...
```

Or copy the relevant `skills/<name>/SKILL.md` files directly into your agent's context.
The `system-prompt.md` always-on block (~600 tokens) is separate and should be loaded in
addition to any bundle — it provides the behavioral baseline that all bundles assume.

---

## Phase Bundles (Workflow-Scoped)

Use one phase bundle per session based on what you are doing. Do not load all four.

### Foundational Bundle

**When to use**: Routine coding sessions where you need consistent quality principles without
any domain-specific guidance.

**Skills** (3 skills, ~1,800 tokens):

| Skill | Purpose |
|-------|---------|
| [review-gate](../skills/review-gate/SKILL.md) | Severity model (CRITICAL/HIGH/MEDIUM/LOW) + rationalization trap table |
| [dry-kiss-yagni](../skills/dry-kiss-yagni/SKILL.md) | No abstraction < 3 consumers; no speculative code; no deep nesting |
| [naming](../skills/naming/SKILL.md) | All identifiers must pass the explains-itself test; ban generic names |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill review-gate --skill dry-kiss-yagni --skill naming
```

---

### Design Bundle

**When to use**: Architectural decision-making, ADR creation, trade-off analysis, and
pre-implementation design work.

**Skills** (4 skills, ~1,900 tokens):

| Skill | Purpose |
|-------|---------|
| [design-challenge](../skills/design-challenge/SKILL.md) | Adversarially evaluate every proposal; steelman alternatives |
| [hard-choice](../skills/hard-choice/SKILL.md) | Evaluate easy-path (today) vs hard-path (2 years) before committing |
| [architecture-evidence](../skills/architecture-evidence/SKILL.md) | Every significant decision needs an ADR with 2+ alternatives |
| [pareto-focus](../skills/pareto-focus/SKILL.md) | Identify and protect the 20% of effort that delivers 80% of value |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill design-challenge --skill hard-choice --skill architecture-evidence --skill pareto-focus
```

---

### Execution Bundle

**When to use**: Active implementation sessions — writing code, fixing bugs, making changes
to a codebase. The most frequently used bundle.

**Skills** (5 skills, ~2,700 tokens):

| Skill | Purpose |
|-------|---------|
| [verification-evidence](../skills/verification-evidence/SKILL.md) | Never claim completion without observable evidence |
| [scout](../skills/scout/SKILL.md) | Leave every touched file better than found; produce Improvement Record |
| [scope-discipline](../skills/scope-discipline/SKILL.md) | Define IS / IS NOT scope before starting; never fix outside it |
| [anti-slop](../skills/anti-slop/SKILL.md) | Flag AI-generated boilerplate, empty handlers, single-consumer abstractions |
| [solid-gate](../skills/solid-gate/SKILL.md) | Check every class/module/function against all five SOLID principles |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill verification-evidence --skill scout --skill scope-discipline --skill anti-slop --skill solid-gate
```

---

### Review Bundle

**When to use**: Code review, bug triage, approval decisions, and post-implementation quality
gates.

**Skills** (3 skills, ~1,650 tokens):

| Skill | Purpose |
|-------|---------|
| [review-gate](../skills/review-gate/SKILL.md) | Severity model (CRITICAL/HIGH/MEDIUM/LOW) with rationalization traps |
| [root-cause](../skills/root-cause/SKILL.md) | Apply 5 Whys before any fix; distinguish symptom from root cause |
| [approval-gate](../skills/approval-gate/SKILL.md) | Confirm before >3 files, irreversible actions, or ambiguity |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill review-gate --skill root-cause --skill approval-gate
```

---

## Domain Bundles (Knowledge Layer)

Load one domain bundle when a session requires deep expertise in a specific area. Each
bundle is independent — combine with a phase bundle as needed.

Token estimates are approximate; actual token counts depend on the agent's tokenizer.

### Security Bundle

**When to use**: Security audits, authentication implementation, secrets management, or
hardening a repository's Git configuration.

**Skills** (4 skills, ~4,400 tokens):

| Skill |
|-------|
| [security-owasp](../skills/security-owasp/SKILL.md) |
| [security-identity-access](../skills/security-identity-access/SKILL.md) |
| [security-secrets-supply-chain](../skills/security-secrets-supply-chain/SKILL.md) |
| [security-git](../skills/security-git/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill security-owasp --skill security-identity-access --skill security-secrets-supply-chain --skill security-git
```

---

### Code Quality Bundle

**When to use**: Refactoring sessions, design pattern selection, or implementing structured
error handling.

**Skills** (3 skills, ~3,200 tokens):

| Skill |
|-------|
| [code-code-quality](../skills/code-code-quality/SKILL.md) |
| [code-design-patterns](../skills/code-design-patterns/SKILL.md) |
| [code-error-handling](../skills/code-error-handling/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill code-code-quality --skill code-design-patterns --skill code-error-handling
```

---

### Testing & Quality Bundle

**When to use**: Setting up a test strategy, debugging a performance bottleneck, or
implementing observability.

**Skills** (3 skills, ~3,400 tokens):

| Skill |
|-------|
| [quality-testing](../skills/quality-testing/SKILL.md) |
| [quality-debugging-performance](../skills/quality-debugging-performance/SKILL.md) |
| [quality-observability](../skills/quality-observability/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill quality-testing --skill quality-debugging-performance --skill quality-observability
```

---

### Delivery Bundle

**When to use**: Setting up CI/CD pipelines, writing release automation, or provisioning
infrastructure.

**Skills** (3 skills, ~3,100 tokens):

| Skill |
|-------|
| [delivery-ci-cd-delivery](../skills/delivery-ci-cd-delivery/SKILL.md) |
| [delivery-release-git](../skills/delivery-release-git/SKILL.md) |
| [delivery-infrastructure](../skills/delivery-infrastructure/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill delivery-ci-cd-delivery --skill delivery-release-git --skill delivery-infrastructure
```

---

### Data Bundle

**When to use**: Database schema design, caching strategy, or message queue architecture.

**Skills** (2 skills, ~2,400 tokens):

| Skill |
|-------|
| [data-data-persistence](../skills/data-data-persistence/SKILL.md) |
| [data-messaging](../skills/data-messaging/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill data-data-persistence --skill data-messaging
```

---

### Architecture Bundle

**When to use**: High-level design decisions, architectural health assessments, or API
contract design.

**Skills** (3 skills, ~3,500 tokens):

| Skill |
|-------|
| [meta-analysis-architecture](../skills/meta-analysis-architecture/SKILL.md) |
| [meta-rearchitect](../skills/meta-rearchitect/SKILL.md) |
| [code-api-design](../skills/code-api-design/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill meta-analysis-architecture --skill meta-rearchitect --skill code-api-design
```

---

### Operations Bundle

**When to use**: Incident response, SRE practice setup, or disaster recovery planning.

**Skills** (2 skills, ~2,600 tokens):

| Skill |
|-------|
| [operations-incident-response](../skills/operations-incident-response/SKILL.md) |
| [operations-sre-operations](../skills/operations-sre-operations/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill operations-incident-response --skill operations-sre-operations
```

---

### VCS Bundle

**When to use**: Git conflict resolution, changelog generation, or PR/issue operations
across forges.

**Skills** (3 skills, ~2,800 tokens):

| Skill |
|-------|
| [vcs-git-workflows](../skills/vcs-git-workflows/SKILL.md) |
| [vcs-conventional-commits](../skills/vcs-conventional-commits/SKILL.md) |
| [vcs-forge-operations](../skills/vcs-forge-operations/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill vcs-git-workflows --skill vcs-conventional-commits --skill vcs-forge-operations
```

---

### Compliance Bundle

**When to use**: SOC 2, GDPR, HIPAA, or PCI DSS audit preparation.

**Skills** (1 skill, ~1,800 tokens):

| Skill |
|-------|
| [compliance-audit-compliance](../skills/compliance-audit-compliance/SKILL.md) |

```bash
npx skills add CorentinLumineau/base-skills@v0.2.1 --skill compliance-audit-compliance
```

---

## Bundle Selection Guide

| Session type | Recommended bundles | Approx. tokens |
|--------------|--------------------|--------------------|
| Routine coding | system-prompt.md + Execution | ~3,300 |
| Architecture / ADR | system-prompt.md + Design | ~2,500 |
| Security audit | system-prompt.md + Security | ~6,100 |
| Code review | system-prompt.md + Review | ~2,250 |
| Test strategy | system-prompt.md + Testing & Quality | ~4,000 |
| Release / CI setup | system-prompt.md + Delivery | ~3,700 |
| Full multi-domain session | All 53 skills | ~30,000 |

**Token economy**: Loading the Execution bundle instead of all 53 skills reduces context
consumption by ~91% while covering the most common implementation tasks.

## Token Estimate Methodology

Estimates use ~15 tokens per line of SKILL.md content as a conservative average across
Claude, GPT-4, and Gemini tokenizers. Actual values vary ±20% depending on the tokenizer
and exact file content. Re-calculate after adding new skills:

```bash
wc -l skills/<name>/SKILL.md  # lines × 15 ≈ token estimate
```
