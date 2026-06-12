# x-troubleshoot — Hypothesis Testing Checklist

Load trigger: Read this file before forming any hypothesis.

## Phase Start

- [ ] Read WORKFLOW.md if it exists — extract prior context and recent change summaries
- [ ] State the symptom in one sentence: "The observed behavior is {X} when {Y}"
- [ ] Gather the exact error message and stack trace (copy verbatim — no paraphrasing)

## Reproduction

- [ ] Identify the exact steps to reproduce the issue
- [ ] Verify the issue is reproducible before proceeding
- [ ] Note: environment, version, recent changes, any intermittency patterns
- [ ] If not reproducible: stop and ask the user for reproduction steps before proceeding

## Hypothesis Generation

- [ ] Generate at least 3 distinct hypotheses ranked by probability (most likely first)
- [ ] For each hypothesis: state "The bug is caused by {X} in {component}" as a testable claim
- [ ] Document evidence FOR each hypothesis (what supports it)
- [ ] Document evidence AGAINST each hypothesis (what argues against it)
- [ ] Identify the cheapest minimal test for each hypothesis

## Hypothesis Testing

- [ ] Test hypothesis 1 first (most likely): design a targeted test, execute it, record result
- [ ] Mark hypothesis as CONFIRMED or REFUTED with evidence
- [ ] If refuted: test hypothesis 2; if confirmed: stop — do NOT test others unnecessarily
- [ ] If all 3 hypotheses refuted: re-examine assumptions; generate 2 more hypotheses
- [ ] Never declare root cause without direct evidence confirming the hypothesis

## Root Cause Statement

- [ ] Write the confirmed root cause in one sentence: "Root cause: {X} in {file}:{line/function}"
- [ ] Cite the evidence: "Evidence: {test result / log line / stack trace excerpt}"
- [ ] Classify fix complexity: simple (1–3 files) → x-fix; complex (multi-file) → x-plan+x-implement

## Output

- [ ] Write diagnosis report using `references/output-template.md`
- [ ] Fill WORKFLOW.md from `assets/WORKFLOW.md.template` with confirmed root cause as summary
