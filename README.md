---
name: base-skills
description: 23 always-on behavioural principles for AI coding agents — Pareto focus, SOLID gate, review severity, root cause analysis, naming discipline, and more.
---

# Base Skills

23 **always-on behavioural principles** for AI coding agents. Each skill defines concrete rules, decision gates, and artifacts. Applied automatically — no invocation needed.

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

Copy `system-prompt.md` into your agent's system instructions. It produces the same behavioural effect as all 23 skills in under 500 tokens.

## Skills

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
| 18 | [x-auto](skills/x-auto/SKILL.md) | Entry point and workflow classifier for APEX, ONESHOT, DEBUG, and BRAINSTORM chains |
| 19 | [x-analyze](skills/x-analyze/SKILL.md) | Assess a codebase across quality, security, performance, and architecture domains |
| 20 | [x-fix](skills/x-fix/SKILL.md) | Quick targeted fix for an identified bug, followed by a commit approval gate |
| 21 | [x-implement](skills/x-implement/SKILL.md) | Implement planned changes following test-driven development (TDD) |
| 22 | [x-plan](skills/x-plan/SKILL.md) | Create an implementation plan with task breakdown and acceptance criteria |
| 23 | [x-review](skills/x-review/SKILL.md) | Post-implementation quality gate; blocks on CRITICAL and HIGH findings |

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

**Tier 2 — On-Demand Behavioral Skills (`skills/*/SKILL.md`)**: The full corpus of 23 skills totalling approximately 8,500 tokens. Each skill includes Why, Always, Never, Gate, and Artifact sections with detailed decision criteria, rationalization trap tables, worked examples, and cross-skill references. Load a specific SKILL.md only when the agent needs to reason about the principle in depth — for example, load `skills/architecture-evidence/SKILL.md` when the agent is creating an ADR, or `skills/review-gate/SKILL.md` during a structured code review.

**Why the two-tier model matters for token economy**: Loading all 23 skills on every task would cost approximately 8,500 tokens per context window — roughly 14× the always-on block. For routine tasks (write a function, fix a bug, refactor a class), the always-on block provides sufficient behavioral governance at ~600 tokens. The full corpus is reserved for tasks that require deep procedural guidance. Over hundreds of tasks, the compression from ~8,500 to ~600 tokens saves significant inference cost while maintaining the full behavioral contract.

**When to use which tier**:
- Always: inject `system-prompt.md` into system instructions once; never remove it mid-session
- On-demand: reference a specific SKILL.md when the task explicitly invokes a workflow (ADR creation → `architecture-evidence`; code review → `review-gate`; bug fix → `root-cause`)
- Never: load all 23 SKILL.md files unless you are building a comprehensive agent that operates across all domains simultaneously

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
