---
name: base-skills
description: 15 always-on behavioural principles for AI coding agents — Pareto focus, SOLID gate, review severity, root cause analysis, naming discipline, and more.
---

# Base Skills

15 **always-on behavioural principles** for AI coding agents. Each skill defines concrete rules, decision gates, and artifacts. Applied automatically — no invocation needed.

## Install

### skills.sh (any compatible agent)

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

### Claude Code (plugin)

```bash
claude mcp install CorentinLumineau/base-skills
```

Or clone and install locally:

```bash
git clone https://github.com/CorentinLumineau/base-skills
claude mcp install ./base-skills
```

The plugin loads `rules/quality-principles.md` as always-on rules and registers all 15 skills.

### Any other agent

Copy `system-prompt.md` into your agent's system instructions. It produces the same behavioural effect as all 15 skills in under 500 tokens.

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

## Files

```
skills/<name>/SKILL.md   — full skill definition (skills.sh + Claude Code compatible)
rules/quality-principles.md — always-on rules for Claude Code auto-loading
CLAUDE.md                — Claude Code entry point
system-prompt.md         — condensed ~500-token block for any other agent
quick-reference.md       — one-table lookup with self-check questions
```

## Design

Concepts live in exactly one skill. Cross-skill references are pointers (`→ See [skill-name]`),
never restatements. The severity model (CRITICAL/HIGH/MEDIUM/LOW) is defined once in
`review-gate` and referenced everywhere else. The 3-consumer rule is defined once in
`dry-kiss-yagni`. The diff boundary is defined once in `scope-discipline`.

---

Compatible with all agents listed at [skills.sh](https://skills.sh).
