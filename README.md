---
name: base-skills
description: 15 always-on behavioural principles for AI coding agents — Pareto focus, SOLID gate, review severity, root cause analysis, naming discipline, and more.
---

# Base Skills

A comprehensive set of 15 **always-on behavioural principles** for AI coding agents. Each skill defines concrete rules, gates, and artifacts that guide the agent's thinking without needing to be asked.

## Install

```bash
npx skills add CorentinLumineau/base-skills
```

Install individual skills:

```bash
npx skills add CorentinLumineau/base-skills --skill pareto-focus
npx skills add CorentinLumineau/base-skills --skill review-gate --skill naming --skill solid-gate
npx skills add CorentinLumineau/base-skills --skill '*'     # all skills
```

List available skills without installing:

```bash
npx skills add CorentinLumineau/base-skills --list
```

## Skills Overview

| # | Skill | One-line summary |
|---|-------|------------------|
| 1 | **pareto-focus** | Identify and protect the 20% of effort that delivers 80% of value |
| 2 | **hard-choice** | Evaluate easy-path (today) vs hard-path (2 years) before committing |
| 3 | **solid-gate** | Check every class/module/function against all five SOLID principles |
| 4 | **dry-kiss-yagni** | No abstraction without 3 consumers, no speculative code, no deep nesting |
| 5 | **verification-evidence** | Never claim completion without observable evidence (IDENTIFY→RUN→READ→VERIFY→CLAIM) |
| 6 | **design-challenge** | Adversarially evaluate every technical proposal; steelman alternatives |
| 7 | **future-proof** | Make the 2-year maintenance cost visible before committing |
| 8 | **scout** | Leave every touched file better than you found it; produce an Improvement Record |
| 9 | **anti-slop** | Flag AI-generated boilerplate, empty handlers, and single-consumer abstractions |
| 10 | **review-gate** | Severity model (CRITICAL/HIGH/MEDIUM/LOW) with rationalization trap table |
| 11 | **root-cause** | Apply 5 Whys before any fix; distinguish symptom from root cause |
| 12 | **scope-discipline** | Define IS / IS NOT scope before starting; never fix outside it |
| 13 | **architecture-evidence** | Every significant decision needs an ADR with 2+ alternatives evaluated |
| 14 | **naming** | All identifiers must pass the explains-itself test; ban generic names |
| 15 | **approval-gate** | Confirm before >3 files, irreversible actions, architecture decisions, or ambiguity |

## Deduplication

Concepts live in exactly one skill. Cross-references use `→ See skill-{name}` pointers — no concept is redefined in multiple places.

## Files

- `skills/<name>/SKILL.md` — each skill's full definition
- `quick-reference.md` — one-table lookup for all 15 skills
- `system-prompt.md` — condensed first-person version (~440 tokens) for injection into any agent's system prompt

## System Prompt

For agents that don't load skills directly, copy `system-prompt.md` into your agent's system instructions. It produces the same behavioural effect as all 15 skills combined.

---

Compatible with all agents listed at [skills.sh](https://skills.sh).
