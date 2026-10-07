# Information Hierarchy Doctrine

Stack-agnostic doctrine for progressive disclosure in UI-producing projects. Informs `x-design`
(design principles validation), `x-review` (V-UX-01 audit), `x-improve-hunt`'s UX hunt/fix
modes (Information Architecture domain), and `x-analyze`'s ux mode (proactive IA audit).

## The 4-Tier Information Model

| Tier | User question it answers | Definition |
|------|---------------------------|------------|
| At-a-glance | "What's the headline?" | The single most important fact, visible with zero interaction (status badge, total, primary metric). |
| Summary | "Which item do I care about?" | A scannable list/row view with the ~3-7 fields needed to triage or select among many items. |
| Detail | "Everything about this one?" | The full record for one selected item — every field, in context, reached via an explicit navigation action. |
| Raw | "Take it elsewhere?" | Unformatted/exportable data (JSON, CSV, raw log) for tooling, debugging, or handoff — never the default view. |

## Information-Overload Anti-Patterns

| Anti-pattern | Description | Tier violated |
|---|---|---|
| Flat field dump | All fields rendered with equal visual weight, no primary/secondary distinction | At-a-glance |
| No summarization above ~7 facts/columns | List/table view exceeds ~7 visible columns/fields without grouping, collapsing, or a detail drill-down | Summary |
| Everything expanded by default | Accordions/sections/trees render fully open on load instead of collapsed-by-default with drill-down | Summary → Detail |
| Buried primary info | The single most important fact is not the most visually prominent element on the screen | At-a-glance |
| Deprecated data at equal prominence | Stale/deprecated/historical data rendered with the same visual weight as current data | At-a-glance / Summary |

## Applying the Doctrine

- A view earns tier "Detail" or "Raw" only after an explicit user action (click, expand, "view
  raw") — never as the default render.
- When auditing a diff or reviewing a design, map each surfaced UI element to a tier; flag any
  element at Summary or above that actually belongs at Detail or Raw.
- This doctrine is deliberately stack-agnostic — it describes an information model, not a
  component library, layout system, or specific framework's API.

## Rhythm ownership

Vertical gaps are owned by containers (flows, stacks, grids), not set ad-hoc on individual
elements. Type roles do not carry a margin-as-spacing contract. Stated once, here — consumers
point at this section rather than restating it.

## Composition-to-material matching

Advisory craft for choosing a visual form that matches the material's shape. No V-code, no
violation threshold — `x-design` and `x-analyze` ux may load this table as guidance; they do
not emit a finding from it.

| Material shape | Visual form |
|----------------|-------------|
| magnitude | length or bar |
| change | slope or delta |
| composition | part-to-whole |
| threshold | position vs a mark |
| process | sequence or flow |
| alternatives | side-by-side |

## Two reading speeds

A second axis on the 4-tier model, not a replacement. Tiers classify **fields**; reading speeds
classify **the path through the document**.

- **Executive path** — at-a-glance + summary, scannable in seconds.
- **Audit path** — detail + raw, inspectable.

Precedent: mercure's own artifact-output practice (`efficient-output.md` / ADR-045 executive
summary) was never written down as **UI** doctrine. The 6 efficient-output rules stay on
artifact summaries; they are not restated here.

## Consumers

| Consumer | How it uses this doctrine |
|----------|---------------------------|
| `x-design` | Design principles validation step checks UI-producing designs for progressive disclosure alongside SOLID/DRY/KISS/YAGNI. Also loads rhythm / composition-matching / two-reading-speeds as advisory (no V-code). |
| `x-review` (V-UX-01) | review-gate / `x-review` quality criteria Phase 2 audit checklist enforces this doctrine on diffs touching UI views. Also loads rhythm / composition-matching / two-reading-speeds as advisory (no V-code). |
| `x-improve-hunt` (UX hunt/fix modes) | Information Architecture domain agent scans for anti-patterns above; fix mode applies tiering corrections. Also loads rhythm / composition-matching / two-reading-speeds as advisory (no V-code). |
| `x-analyze` (ux mode) | Proactive IA audit before planning; maps views to tiers, reports V-UX-01 on UI-producing code. Also loads rhythm / composition-matching / two-reading-speeds as advisory (no V-code). |
