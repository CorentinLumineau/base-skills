# x-auto — Classification Checklist

Load trigger: Read this file when the intent signal is weak or multiple workflows are plausible.

## Phase Start

- [ ] Read the user's full request before classifying — do not cut off mid-sentence
- [ ] Check for prior context: does WORKFLOW.md already exist at repo root? If yes, skip x-auto
- [ ] Identify the dominant signal: new feature vs known bug vs unknown error vs exploration

## Classification Protocol

- [ ] Apply the intent table in SKILL.md exactly — check all four rows before deciding
- [ ] If request mentions "improve", "enhance", "add" → APEX regardless of bug language
- [ ] If request mentions "broken", "not working" without a known root cause → DEBUG, not ONESHOT
- [ ] If request mentions "brainstorm", "explore", "options", "how should I" → BRAINSTORM
- [ ] If request gives a specific identified bug with a clear fix location → ONESHOT

## Ambiguity Resolution

- [ ] If two workflows score equally, ask exactly one clarifying question
- [ ] "Do you know the root cause?" → YES: ONESHOT; NO: DEBUG
- [ ] "Are you adding something new or fixing something broken?" → new: APEX; broken: DEBUG/ONESHOT
- [ ] Never ask more than one question — make the best call if a second question would arise

## WORKFLOW.md Creation

- [ ] Create WORKFLOW.md from assets/WORKFLOW.md.template — do NOT write freeform YAML
- [ ] Fill only `workflow:` (apex|oneshot|debug|brainstorm) and `started:` (ISO date)
- [ ] Leave all other fields at template defaults — downstream phase skills fill their own fields

## Output Check

- [ ] State the chosen workflow explicitly: "Routing to the {WORKFLOW} chain, starting with `{skill}`."
- [ ] Tell the user the next invocation: "Invoke `{first-skill}` to begin."
