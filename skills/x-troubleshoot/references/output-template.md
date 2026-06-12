# x-troubleshoot — Diagnosis Report Template

Write the diagnosis to `documentation/investigations/{slug}-diagnosis.md` if the directory exists,
otherwise present inline. The report must contain all five required sections.

## Required Sections

```markdown
# Diagnosis: {Problem Title}

## Symptom

{Exact description of the observed behavior. Copy error messages verbatim.}

**Reproduction steps**:
1. {Step 1}
2. {Step 2}
3. {Observed result}

## Hypotheses Tested

| Hypothesis | Result | Evidence |
|------------|--------|----------|
| {H1: proposed cause} | CONFIRMED / REFUTED | {test result or log excerpt} |
| {H2: proposed cause} | CONFIRMED / REFUTED | {test result or log excerpt} |

## Root Cause

**Root cause**: {One sentence. Format: "The bug is caused by {X} in {file/component}."}

**Evidence**: {Specific test result, log line, or stack trace excerpt that confirms this.}

## Recommended Path

**Complexity**: Simple (1–3 files) / Complex (multi-file or architectural)

| Approach | When | First step |
|----------|------|------------|
| `x-fix` | Simple fix — 1–3 files | Invoke x-fix with root cause as context |
| `x-plan` + `x-implement` | Complex fix — multi-file or refactoring needed | Start APEX workflow |
```

## Inline Format (when no documentation directory)

If `documentation/investigations/` does not exist, present the diagnosis inline in your response
using the same five sections. Do not create the directory — only use it if it already exists.
