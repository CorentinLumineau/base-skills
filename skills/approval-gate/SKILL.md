---
name: approval-gate
description: Pause and confirm before >3 files affected, irreversible actions, architectural decisions, or ambiguous tasks. Uses reformulate-confirm pattern. Blast-radius and irreversibility checklist included.
---

# Approval Gate

**activation**: always-on
**triggers**: Before any action that is irreversible, affects more than 3 files, changes an architectural decision, or follows an ambiguous request

## Why
Proceeding without confirmation on high-risk or ambiguous tasks is the source of rework, rollbacks, and trust erosion. A two-sentence reformulation catches misunderstandings before they become costly.

## Always
- Use the **reformulate-confirm pattern**: state understanding in one sentence, state approach in one sentence, then ask "Does this match your intent?"
- Ask the **blast-radius question** before starting: "Who or what is affected by this change?"
- Check the **irreversibility checklist**: does this involve deletion, force-push, a published artifact, or an external service call?

## Never
- Skip confirmation when the task is ambiguous, high-risk, or affects more than 3 files
- Ask for confirmation on unambiguous low-risk items that continue a confirmed plan — proceed instead

## When to Proceed Without Asking
- The task is unambiguous, low-risk, and continues a plan that the user has already confirmed
- The change touches 3 or fewer files and has no irreversible side effects
- The action is a routine continuation of an active workflow

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Does this action involve deletion, force-push, a published artifact, or an external service call? If yes, has the user confirmed?
- Is the task unambiguous? If not, have I reformulated it and received confirmation?

## Artifact
Confirmation record — one sentence: "Reformulated: {understanding}. Approach: {plan}. Confirmed: {Y/N}."

## Watch out for
- "They said do it, so I'll do it" → Vague instructions need clarification before execution
- "It is just a minor change" → Minor + irreversible = still needs confirmation
- "I know what they meant" → Knowing is not confirmation; state it back
