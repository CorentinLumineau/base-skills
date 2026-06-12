# x-implement — Completion Gate

This is NOT a user approval gate. It is a self-verification gate before chaining to x-review.

## Gate Conditions

All of the following must be true before proceeding:

- [ ] Full test suite passes (zero failures — not just the new tests)
- [ ] No lint errors introduced by this implementation
- [ ] No type errors introduced (if project uses a type checker)
- [ ] Every task acceptance criterion in the plan is observably met
- [ ] No TODO, FIXME, or placeholder comments left in delivered code
- [ ] WORKFLOW.md written with `current_phase: implement` and `status: complete`

## If Any Check Fails

Do NOT proceed to x-review. Fix the failing check first.

Common resolutions:
- **Test failure**: return to Green phase — identify which acceptance criterion is not met
- **Lint error**: fix the style or structural issue; do not suppress warnings with inline comments unless pre-existing
- **Type error**: fix the type annotation or implementation — do not cast to `any`/`unknown` as a shortcut
- **Missing acceptance criterion**: check if the task was skipped or the criterion was misunderstood

## After Gate Passes

1. Produce the evidence statement per `references/output-template.md`
2. Write WORKFLOW.md at repo root
3. Invoke x-review to begin the quality gate phase

## Headless / Automated Context

If operating without human interaction:
- All gate conditions still apply — no exceptions
- On gate failure: log the specific failing check with evidence, stop, and surface the failure
- Do NOT silently skip failed checks and chain to x-review
