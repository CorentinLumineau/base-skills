# DEFER — git-commit

**Decision**: DEFERRED — do not port as a base skill at this time.
**Evaluated against**: F0 anti-hollow bar + critic C4 (ADR-084 §3 forge-portability test).

---

## Forge Dependencies Found

The mercure-plugin `git-commit/SKILL.md` contains these non-portable dependencies:

1. **`mcp__plugin_mercure_mercure-context__git_context` MCP tool** (line ~47): The skill calls
   this Gitea/mercure-specific MCP tool for forge detection, CLI availability, and repo state.
   No generic equivalent exists — this is a mercure-infrastructure-specific data source.

2. **`vcs-conventional-commits` behavioral skill** (line ~36): The commit message format
   enforcement delegates to a mercure skill that references mercure-specific commit scopes,
   V-BRANCH codes, and the mercure contribution guide. The portable equivalent (`skill-vcs-conventional-commits`)
   exists in base-skills but the orchestration layer is woven around mercure conventions.

3. **Hook integration — `PreToolUse` on Bash** (line ~40): The skill expects Claude Code hooks
   (`PreToolUse`/`PostToolUse` events) that are Claude Code-specific. A generic agent running
   this skill without Claude Code hooks silently loses the pre-commit safety net.

---

## F0 Bar Assessment

What remains after stripping all 3 forge dependencies:

```
1. git status --porcelain
2. git add <files>
3. git commit -m "<conventional message>"
```

This is trivially obvious — any git-capable agent performs these steps without a skill. The
portable residue does not meet the F0 bar ("changes agent behavior on a primitive-less agent"):
the residue adds no domain-specific guidance that a blank-slate agent lacks.

---

## Why the F0 Bar Is Not Met

- **No domain-specific checklist**: The substantive protocol (sensitive file scanning, smart
  grouping algorithm, issue-closing awareness, branch safety) all depend on forge context
  returned by `mcp__plugin_mercure_mercure-context__git_context`.
- **No portable approval gate**: The commit gate depends on x-review completing first — which
  is already handled by x-review's own `references/approval-gate.md` in base-skills.
- **Generic alternative is sufficient**: Agents following the base-skills x-review → commit
  pattern can use native `git commit` after the review gate passes. No skill adds value here.

---

## What a Future Implementor Needs

To ship a portable `git-commit` base skill:

1. **Replace `mcp__plugin_mercure_mercure-context__git_context`** with a fallback-only protocol
   using standard `git` commands (`git status`, `git log`, `git diff`). The fallback already
   exists in the mercure skill body but is annotated as secondary.

2. **Extract the sensitive-file scan** (the `.env*`, `credentials*`, `*.key` pattern list) into
   a standalone `references/sensitive-file-patterns.md` — this IS portable and adds real value.

3. **Extract the smart-grouping algorithm** into a `references/grouping-protocol.md` — the
   path-based grouping logic (config / root / collection / other) is forge-independent.

4. **Remove hook integration** from SKILL.md body — document it as a Claude Code–specific
   enhancement in a `references/hook-integration.md` file so non-Claude Code agents skip it.

Once those 4 items are done, the skill will meet F0 bar independently of forge tooling.
