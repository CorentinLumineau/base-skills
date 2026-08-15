# Base Skills — Agent Instructions

Portable skill set for AI coding agents, conformant to the
[agentskills.io](https://agentskills.io) spec. Agent-agnostic entry point
(`AGENTS.md` convention; `CLAUDE.md` is a symlink to this file).

**Merged from the best of Mercure (v9.12.0) + Blackhole (v0.x)** —
two production-grade agent orchestration systems battle-tested across
hundreds of real PRs.

## Always-on behaviour

Inject [`system-prompt.md`](system-prompt.md) into your system instructions once.
It encodes all 22 behavioural principles in ~900 tokens and applies to every task —
no per-task loading, no configuration.

## On-demand skills

Load a single skill only when the task needs its domain depth:

- Definitions live at `skills/<name>/SKILL.md`
- Spec-standard discovery path: `.agents/skills/<name>` (symlink into `skills/`)

Pick the relevant skill (e.g. `security-owasp` for an audit, `x-design` for an ADR)
rather than loading the whole corpus.

## Skill Tiers

### L1 — Behavioural (17 skills) — always-on
Applied automatically via system-prompt.md. No per-task loading needed.

| Skill | What it does |
|-------|-------------|
| `pareto-focus` | 20/80 analysis before starting |
| `solid-gate` | SOLID compliance check |
| `dry-kiss-yagni` | Duplication, simplicity, no-speculation |
| `review-gate` | Canonical severity model for code review |
| `root-cause` | 5 Whys before any fix |
| `verification-evidence` | 5-step gate: identify→run→read→verify→claim |
| `error-handling` | Classify then act: transient/permanent/corruption |
| `hard-choice` | Easy path vs hard path comparison |
| `design-challenge` | Steelman every rejected alternative |
| `scout` | Leave files better than found, within diff |
| `naming` | Explains-itself test for every identifier |
| `scope-discipline` | IS/IS NOT scope before starting |
| `future-proof` | 2-year maintenance cost visibility |
| `approval-gate` | Confirm before destructive/ambiguous actions |
| `anti-slop` | Flag AI-generated patterns with no business value |
| `architecture-evidence` | ADR for every significant design decision |
| `meta-persuasion-principles` | Detect rationalization in reasoning |

### L2 — Knowledge (26 skills) — on-demand
Loaded when the task touches that domain.

Security: `security-owasp`, `security-identity-access`, `security-secrets-supply-chain`, `security-git`
Code quality: `code-code-quality`, `code-api-design`, `code-design-patterns`, `code-error-handling`
Testing: `quality-testing`, `quality-debugging-performance`, `quality-observability`
Delivery: `delivery-ci-cd-delivery`, `delivery-infrastructure`, `delivery-release-git`
Data: `data-data-persistence`, `data-messaging`
Architecture: `meta-rearchitect`, `meta-analysis-architecture`, `diagram-mermaid`
Operations: `operations-incident-response`, `operations-sre-operations`, `compliance-audit-compliance`

### L3 — Workflow orchestration (10 skills)
Structured APEX/ONESHOT/DEBUG/BRAINSTORM workflows:

| Skill | Phase | Purpose |
|-------|-------|---------|
| `x-auto` | Entry | Classify task → route to correct workflow |
| `x-analyze` | Analyze | Codebase analysis, evidence gathering |
| `x-design` | Design | ADR production, trade-off documentation |
| `x-plan` | Plan | Task breakdown with acceptance criteria |
| `x-implement` | Implement | TDD-driven implementation |
| `x-review` | Review | Post-implementation quality gate |
| `x-fix` | Fix | Targeted bugfix with root cause |
| `x-troubleshoot` | Debug | Systematic error investigation |
| `x-brainstorm` | Explore | Structured idea exploration |
| `x-research` | Research | Evidence-based technical investigation |

## Concepts from Mercure not in individual skills

These are embedded in `system-prompt.md` and the skill definitions above:

- **Output Style** (ADHD-friendly): lead with action, number steps, end with next action, no preamble
- **Extension Tax**: every extension is a debit against SRP; PR must declare when triggers fire
- **Comment Discipline**: comments earn their place by carrying invariants; no TODO, no PR# in code
- **Reviewer Iron Law**: no BLOCK finding suppressed without evidence; confidence-based filtering
- **Context Anxiety Countermeasures**: increase rigor in second half; never batch remaining tasks

## Concepts from Blackhole not in individual skills

- **State Management**: SSOT, single-writer invariant, snapshot→tmp→validate→install
- **Worktree Hygiene**: explicit `-C` targeting, post-push verification, automated pruning
- **Kaizen Hunt**: proactive discovery loop with CONFIRMED verification gate
- **V-Code System**: 80+ violation codes with BLOCK/WARN/INFO severity (see `references/vcodes.md`)

## Documentation

- [`README.md`](README.md) — full 55-skill catalogue, install, three-tier model
- [`quick-reference.md`](quick-reference.md) — one-table lookup with self-check questions
- [`references/`](references/) — skill bundles, workflow chains, V-codes, resync SOP
- [`CHECKSUMS.md`](CHECKSUMS.md) / [`SECURITY.md`](SECURITY.md) — integrity & disclosure
