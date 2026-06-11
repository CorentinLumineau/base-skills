---
name: base-skills
description: 15 always-on behavioural principles for AI agents — Pareto focus, SOLID gate, review severity, root cause analysis, naming discipline, and more.
---

# Base Skills

15 always-on behavioural principles. Applied automatically to every task — no invocation needed.

## Skills

| # | Name | Triggers on |
|---|------|-------------|
| 1 | [pareto-focus](skills/pareto-focus/SKILL.md) | Any multi-step task, feature, or decision |
| 2 | [hard-choice](skills/hard-choice/SKILL.md) | Committing to a solution approach |
| 3 | [solid-gate](skills/solid-gate/SKILL.md) | Writing or modifying any class, module, or function |
| 4 | [dry-kiss-yagni](skills/dry-kiss-yagni/SKILL.md) | Any code being written, reviewed, or refactored |
| 5 | [verification-evidence](skills/verification-evidence/SKILL.md) | Any completion claim or sign-off |
| 6 | [design-challenge](skills/design-challenge/SKILL.md) | Technical proposals and architecture discussions |
| 7 | [future-proof](skills/future-proof/SKILL.md) | Every decision that adds, modifies, or removes code |
| 8 | [scout](skills/scout/SKILL.md) | Every file modification |
| 9 | [anti-slop](skills/anti-slop/SKILL.md) | Code generation, review, template creation |
| 10 | [review-gate](skills/review-gate/SKILL.md) | Every code or design review |
| 11 | [root-cause](skills/root-cause/SKILL.md) | Any bug fix, test failure, or unexpected behaviour |
| 12 | [scope-discipline](skills/scope-discipline/SKILL.md) | Before starting any task |
| 13 | [architecture-evidence](skills/architecture-evidence/SKILL.md) | Significant design decisions |
| 14 | [naming](skills/naming/SKILL.md) | Every new identifier |
| 15 | [approval-gate](skills/approval-gate/SKILL.md) | Irreversible or high-impact actions |

## Always-on Rules

`rules/quality-principles.md` — consolidated behavioral rules loaded automatically by Claude Code.
These enforce the most critical behaviors from all 15 skills without requiring invocation.

## For Other Providers

Copy `system-prompt.md` into your agent's system instructions. It produces the same
behavioural effect as all 15 skills combined in under 800 tokens.
