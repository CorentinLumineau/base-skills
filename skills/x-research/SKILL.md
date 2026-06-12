---
name: x-research
description: >
  Evidence-based technical investigation answering specific questions from codebase,
  documentation, and external sources. Use when a topic needs thorough investigation
  with cited evidence before design decisions can be made.
  (x-research, research, investigate, find evidence, look it up, how does X work,
  what does the codebase do for X, deep dive, technical investigation, gather evidence).
license: MIT
compatibility: >
  Designed for any AI agent with file read access and optional web access.
  Compatible with all agentskills.io clients.
metadata:
  workflow: brainstorm
  phase: research
  position: "2/3"
allowed-tools: Read Grep Glob Bash
---

<!-- ported from mercure-plugin/skills/x-research/ -->

# x-research — Evidence Gathering (BRAINSTORM Phase 2/3)

**Read `references/checklist.md` at phase start.**

## Phase Overview

Define questions → gather evidence from codebase / docs / external → cite sources → report.

## Key Steps

1. If WORKFLOW.md exists, read it for brainstorm context and open questions
2. Read `references/checklist.md` — follow the evidence-gathering protocol
3. For each question: gather evidence from codebase (file:line), docs (section), or external (URL)
4. Cross-reference at least 2 sources per key claim
5. State uncertainty explicitly when evidence is incomplete
6. Read `references/output-template.md` when writing the research report

→ See `skill-architecture-evidence` for evidence documentation format.
→ See `skill-verification-evidence` for evidence-based claim standards.

## Workflow Navigation

You just completed the **Research** phase (2/3). No user approval gate.

Copy `assets/WORKFLOW.md.template`, fill `summary`. Tell the user:

- If new questions emerged: "Invoke `x-brainstorm` to explore the new questions."
- If evidence supports a clear direction: "Invoke `x-design` to make the architectural decision."

## Gotchas

- Don't confuse research with implementation — research produces evidence and citations, never code
- Don't declare findings without citing sources — every claim needs file:line, doc section, or URL
- Don't re-brainstorm when new questions arise — note them for x-brainstorm iteration, don't speculate
- Do NOT write WORKFLOW.md until all research questions are answered with evidence
