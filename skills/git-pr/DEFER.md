# DEFER — git-pr

**Decision**: DEFERRED — do not port as a base skill at this time.
**Evaluated against**: F0 anti-hollow bar + critic C4 (ADR-084 §3 forge-portability test).

---

## Forge Dependencies Found

The mercure-plugin `git-pr/SKILL.md` contains these non-portable dependencies:

1. **9 `mcp__plugin_mercure_mercure-context__*` MCP tools** (frontmatter `allowed-tools`): The
   skill requires `list_prs`, `get_pr_activity`, `ci_status`, `git_context`, `project_context`,
   `list_labels`, `update_comment`, `create_comment`, `add_labels`, `remove_labels`,
   `list_failing_jobs`, `get_failing_step_logs`, `get_job_logs` — all Gitea/mercure-context
   specific. No generic equivalents. A base-skills port with these removed has no PR creation
   or CI-status capability.

2. **`references/forge-commands.md`** (referenced in SKILL.md body, line ~78): The reference
   file contains platform-specific CLI syntax for `tea` (Gitea CLI) — `tea pr create`,
   `tea pr merge`, `tea issue list`. The file is Gitea-specific; porting requires parallel
   versions for GitHub (`gh`), GitLab (`glab`), and Bitbucket (`bb`).

3. **`workclaude` / `auto_review.py` backward compatibility** (lines ~24–27): The `ci` mode
   must produce a `REVIEW_SCHEMA` JSON conforming to mercure's `workclaude/auto_review.py`.
   This is a mercure-internal contract with no generic equivalent. Porting requires either
   dropping CI mode or defining a new portable schema.

---

## F0 Bar Assessment

What remains after stripping all 3 forge dependencies:

- A mode-detection table (create/review/fix/merge) — portable but trivial
- References to 20+ mode-specific reference files — none of which are in base-skills
- A success criteria checklist with 2 forge-specific items

The portable residue is an empty shell: a mode router with no route bodies. It fails F0 because
a blank-slate agent receives no actionable guidance — the entire behavior lives in the reference
files that are forge-specific.

---

## Why the F0 Bar Is Not Met

- **All substantive behavior is in references/**: `mode-create.md`, `mode-review.md`,
  `mode-fix.md`, `mode-merge.md` etc. are all forge-specific and not ported.
- **CI status requires forge API**: The review and fix modes read CI status via
  `mcp__plugin_mercure_mercure-context__ci_status` — no generic git alternative provides
  per-job log access needed to diagnose CI failures.
- **Label taxonomy is mercure-specific**: The `list_labels` / `add_labels` / `remove_labels`
  operations manage an `ai-review:NEEDS_CHANGES` label taxonomy specific to mercure's workflow.
  A portable skill cannot replicate this without defining a new cross-forge label contract.

---

## What a Future Implementor Needs

To ship a portable `git-pr` base skill:

1. **Define a forge-agnostic CLI abstraction layer**: Map create/review/merge operations to
   `gh` (GitHub), `tea` (Gitea), `glab` (GitLab) and expose them via a `references/forge-cli.md`
   that agents detect at runtime with `command -v gh || command -v tea || command -v glab`.

2. **Define a portable PR review protocol** in `references/mode-review.md` that uses only
   `git diff` and file read — no CI status API. CI status checking becomes an optional
   enhancement when a forge context MCP is available.

3. **Drop CI mode** (workclaude backward compatibility) — it is an implementation-specific
   contract. A base-skills version serves a different audience.

4. **Define a minimal label contract**: Use only the cross-forge labels that all platforms
   support natively (e.g., "reviewed", "needs-changes") instead of mercure's taxonomy.

Once those 4 items are done, a minimal `git-pr create` + `git-pr review` base skill is feasible.
The full 6-mode composite should remain in mercure until forge abstraction is proven.
