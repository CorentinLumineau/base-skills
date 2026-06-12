---
name: x-analyze
description: >
  Assess a codebase across quality, security, performance, and architecture domains,
  producing a ranked audit report. Use at the start of a feature cycle or before
  planning to understand current health
  (x-analyze, analyze, audit, codebase assessment, pre-planning review, code review,
  before planning, what's wrong with the code, assess the codebase).
compatibility: >
  Designed for any AI agent with file read access. Requires file write access for
  WORKFLOW.md and the audit report artifact. Compatible with all agentskills.io clients.
metadata:
  workflow: apex
  phase: analyze
  position: "1/6"
  approval_required: before-design
---

# x-analyze — Codebase Assessment (APEX Phase 1/6)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Analyze the codebase across 4 domains. Produce a ranked findings report.
Gate before proceeding to design.

## Key Steps

1. If WORKFLOW.md exists, read it for prior context
2. Read `references/checklist.md` — follow the 4-domain analysis protocol
3. For each domain, read the corresponding file:
   - `references/domains/quality.md` (SOLID, DRY, KISS, complexity)
   - `references/domains/security.md` (OWASP Top 10)
   - `references/domains/performance.md` (N+1, memory, caching)
   - `references/domains/architecture.md` (coupling, layer violations)
4. Rank findings by severity: CRITICAL → HIGH → MEDIUM → LOW
5. Read `references/output-template.md` when writing the audit report
6. **Read `references/approval-gate.md` before presenting findings to the user**

## Workflow Navigation

You just completed the **Analyze** phase (1/6).

**STOP — APPROVAL REQUIRED before proceeding to Design.**
Read [references/approval-gate.md](references/approval-gate.md) for the exact
user message and gate conditions.

On approval: copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:
> "Analysis complete. Invoke `x-design` with these findings as context."

## Gotchas

- Don't report every finding — Pareto: surface the 20% that explains 80% of the risk
- Don't skip domains because "this codebase looks clean" — each domain may reveal surprises
- Don't conflate analysis breadth with depth — cover all 4 domains shallowly first,
  then go deep on CRITICAL findings
- Do NOT write WORKFLOW.md before the user approves proceeding
