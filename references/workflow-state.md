# WORKFLOW.md State Schema

Each workflow skill writes `WORKFLOW.md` at phase completion. The next skill reads it
at start for context. The file grows append-only: `prev_phases` accumulates full chain history.

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `workflow` | string | `apex`, `oneshot`, `debug`, or `brainstorm` |
| `current_phase` | string | Phase that wrote this entry (e.g. `analyze`, `plan`, `fix`) |
| `status` | string | `in_progress` (chain continues) or `complete` (terminal phase done) |
| `prev_phases` | list | Prior phases, each with `phase` + `summary` fields |
| `approval_required_before` | string\|null | Next gated phase name, or `null` if none |
| `started` | date | ISO 8601 date the chain started (set by x-auto or first skill) |

## Example 1 — Fresh Start (after x-analyze)

```yaml
workflow: apex
current_phase: analyze
status: in_progress
prev_phases: []
approval_required_before: design
started: 2026-06-12
```

## Example 2 — Mid-chain (after x-plan, approved)

```yaml
workflow: apex
current_phase: plan
status: in_progress
prev_phases:
  - phase: analyze
    summary: "15 quality findings; 3 HIGH security issues in auth module"
  - phase: design
    summary: "Chose Repository pattern; ADR-001 written; 4 files affected"
approval_required_before: implement
started: 2026-06-12
```

## Example 3 — Complete (after x-review)

```yaml
workflow: apex
current_phase: review
status: complete
prev_phases:
  - phase: analyze
    summary: "15 quality findings; 3 HIGH issues in auth module"
  - phase: design
    summary: "Chose Repository pattern; ADR-001 written"
  - phase: plan
    summary: "8 tasks; 3 files affected; no blockers"
  - phase: implement
    summary: "All tests green; lint clean; 3 files changed"
approval_required_before: null
started: 2026-06-12
```

## Write Protocol

1. After approval (or immediately when no gate): copy the skill's `assets/WORKFLOW.md.template`
2. Set `current_phase` to this skill's phase name
3. Fill `summary` with one sentence describing the key outcome or decision
4. Move the prior `current_phase` + `summary` into `prev_phases` as a new entry
5. Set `approval_required_before` to the next gated phase name, or `null`
6. Set `status: complete` only at the terminal phase (last phase before commit)

In headless / automated contexts: add `approval: auto-headless` as an extra key.
