# Base Skills — Agent Instructions

Portable skill set for AI coding agents, conformant to the
[agentskills.io](https://agentskills.io) spec. Agent-agnostic entry point
(`AGENTS.md` convention; `CLAUDE.md` is a symlink to this file).

## Always-on behaviour

Inject [`system-prompt.md`](system-prompt.md) into your system instructions once.
It encodes all 17 behavioural principles in ~600 tokens and applies to every task —
no per-task loading, no configuration.

## On-demand skills

Load a single skill only when the task needs its domain depth:

- Definitions live at `skills/<name>/SKILL.md`
- Spec-standard discovery path: `.agents/skills/<name>` (symlink into `skills/`)

Pick the relevant skill (e.g. `security-owasp` for an audit, `x-design` for an ADR)
rather than loading the whole corpus.

## Documentation

- [`README.md`](README.md) — full 53-skill catalogue, install, two-tier model
- [`quick-reference.md`](quick-reference.md) — one-table lookup with self-check questions
- [`references/`](references/) — skill bundles, workflow chains, resync SOP
- [`CHECKSUMS.md`](CHECKSUMS.md) / [`SECURITY.md`](SECURITY.md) — integrity & disclosure
