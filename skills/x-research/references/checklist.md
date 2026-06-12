# x-research — Evidence-Gathering Checklist

Load trigger: Read this file before gathering any evidence.

## Phase Start

- [ ] Read WORKFLOW.md if it exists — extract the open questions from x-brainstorm
- [ ] If WORKFLOW.md is absent: ask the user to state the research question explicitly
- [ ] List all questions to answer before starting (prevents scope creep mid-research)

## Codebase Search

- [ ] Search for existing implementations of the topic: `Grep` for key identifiers and patterns
- [ ] Read relevant files in full — do not quote from partial reads
- [ ] For each finding: record as `{file}:{line} — {finding}` (citation format)
- [ ] Look for existing conventions, helper utilities, and similar solved problems
- [ ] Note what is NOT in the codebase (absence of pattern is also evidence)

## Documentation Search

- [ ] Search `documentation/` for prior decisions, ADRs, and analysis reports
- [ ] Look for ADRs that already addressed this question — cite them if found
- [ ] Check README, CONTRIBUTING, and any project-level docs for relevant guidance

## External Evidence (when applicable)

- [ ] Use web search only when codebase + documentation lack the answer
- [ ] Cite external sources as full URLs with retrieval date
- [ ] Cross-reference web claims against codebase actuals — don't accept external claims unchecked

## Evidence Validation

- [ ] Each key claim has at least 1 source citation (file:line, doc section, or URL)
- [ ] Conflicting evidence is noted — don't silently resolve contradictions
- [ ] Uncertain findings are marked explicitly: "unclear — {what's missing}"
- [ ] New questions discovered during research are listed (for x-brainstorm, not answered here)

## Output

- [ ] Write research report using `references/output-template.md`
- [ ] List unresolved questions that require x-brainstorm iteration
- [ ] Fill WORKFLOW.md from `assets/WORKFLOW.md.template` with findings summary
