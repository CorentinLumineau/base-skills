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

## Design

Concepts live in exactly one skill. Cross-skill references are pointers (`→ See [skill-name]`),
never restatements. The severity model (CRITICAL/HIGH/MEDIUM/LOW) is defined once in
`review-gate` and referenced everywhere else. The 3-consumer rule is defined once in
`dry-kiss-yagni`. The diff boundary is defined once in `scope-discipline`.

## Development

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
