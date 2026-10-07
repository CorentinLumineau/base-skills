# Data Encoding Doctrine

Stack-agnostic doctrine for whether a chart, sparkline, metric tile, or numeric
column tells the truth. Distinct from `information-hierarchy-doctrine.md`, which
governs *what is shown at which tier*; this file governs *whether what is shown
is true*. Informs `x-review` / review-gate (V-UX-05), `x-analyze` ux mode, and `x-improve-hunt`
ux hunt/fix modes.

## Observables

Emit `V-UX-05` (HIGH) only when a named row fails. Do not emit V-UX-05 from a
subjective "chart is misleading" verdict — name the failed observable.

| Observable | Pass | Fail |
|------------|------|------|
| Axis origin | Length-based bar/area encodings start at zero | Truncated or non-zero baseline on a length-based encoding |
| Context adjacency | Magnitude shown with its unit, period, or population next to the figure | Bare magnitude with unit, period, or population missing or detached |
| Precision consistency | Same decimal/significant-figure policy within a column | Mixed precision in one column (e.g. 1.2 beside 1.234) |

## Out of scope

- Direct-labels-versus-legends (investigation deferred craft, not a V-code)
- Accessibility / Lighthouse / Visual Evidence plumbing (issue #327)
- Theme parity, motion discipline, visual anti-slop (issue #329)

Do not invent a fourth observable. Do not split HIGH/MEDIUM legs in this file
(`V-UX-05a` is a later split-if-noisy follow-up).

## Consumers

| Consumer | How it uses this doctrine |
|----------|---------------------------|
| `x-review` | review-gate / `x-review` quality criteria Phase 2 Data Encoding Audit checklist; Phase 3 HIGH list. |
| `x-analyze` (ux mode) | `x-analyze` UX mode notes loads this file and flags V-UX-05 by citing the observables table. |
| `x-improve-hunt` (UX hunt/fix) | severity `V-UX-05 → HIGH`; fix mode `(f)` restores pass-state per the table. |
