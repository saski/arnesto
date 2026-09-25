# Component recipes
Read this file for every form, tool, comparison, card, table, structured view, simulation, explainer, or dense categorical grid.
Start with semantic content. Add the smallest composition that completes the user job.
Do not invent dashboards, filler metrics, search, filters, reset actions, controls, values, options, labels, or states.
## Composition
- Choose one composition recipe before writing HTML:
  - Chart or simulation: put chart controls before one dominant chart; put simulation controls after one fixed-height stage.
  - Interactive explainer: requested controls and one dominant visual; add selected detail only when requested.
  - Bounded object: one `.vis-card` around the complete receipt, profile, record, or object.
  - Comparison: two through four equal peers with identical internal structure; use a table when precise row comparison matters.
- When no recipe fits, use unframed editorial flow for explanation or one `.vis-card` for a bounded object.
- Use `.vis-card` for a discrete bounded block, such as a metric, callout, summary, detail panel, or related control group.
- Keep ordinary cards neutral. Use `.vis-category-surface` only when its hue encodes category identity or a physical property.
- Use `class="vis-card vis-stat-card"` only with direct `.vis-stat-label` and `.vis-stat-value` children, in that order.
- Never add a third stat-card line, note, caption, icon, badge, or sparkline.
- Before adding custom fill, border, radius, or shadow to a container, use `.vis-card` or leave it transparent.
- Keep charts, diagrams, tables, controls, and the whole visualization unframed.
- Do not nest cards.
- For requested or source-backed summary metrics, use two through four equal-width peer cards when they improve scanning.
- Structure groups with spacing, layout, dividers, or visual marks instead of repeated containers.
- Render dense repeated items as rows with dividers. Do not wrap every item in a separate card.
## Simulations and explainers
- Use compact controls and one dominant visual. Add selected-state detail only when requested.
- Put live values in control labels or on the visual before adding summary cards.
- Treat maxima as limits, not targets.
- Add only requested step controls. Update one current visual instead of showing every step side by side.
- Do not add formulas, parameter panels, metric cards, or secondary views unless the user needs them.
- Put “Estimated” in metric labels or the accessible description. Do not add a visible method caption.
- Keep an animated mechanism inside one fixed-size stage. Animate transforms, not document flow.
## Dense categorical grids
- When selection reveals useful detail, place one compact horizontal selected-item summary before the grid and one small legend after it.
- Otherwise omit the selected-item summary.
- Show exactly one readable identifier per cell.
- Expose each cell's non-identifier details through its accessible name or the selected-item summary. Do not place badges or fact grids in cells.
- Allow selection only unless the user requests more interaction.
- Use a stable order and preserve readable labels at narrow widths.
## Tables
Use a table for values that users must scan or compare precisely.
Reduce optional columns before you add horizontal scrolling.
Wrap a table in `.vis-table-responsive` only when required columns still cannot fit, and put `.vis-table` on the `<table>`.
Use explicit column widths when the source has a clear column hierarchy.
Row dividers are always present. Add `.vis-interactive` to `<tbody>` only when row selection performs an action.
Use `.vis-text-end` for numeric cells.
Use `.vis-badge` for a short result or status cell. Do not stack a loose icon and text.
A direct `.vis-table` or `.vis-table-responsive` child removes card padding.
- Use sentence case for headers and tabular figures for end-aligned numbers.
- Use dense rows only when the source needs them. Do not reduce text size to fit more rows.
- Add `.vis-table-sm` only when source-backed rows need compact padding. It does not reduce the text size.
## Buttons and controls
Use `.vis-controls` only when the job needs a responsive group of controls.
Group controls by the visual they change. Use one control for one state.
Derive selection from native `checked`, `selected`, or `:has`; keep hover, focus, selection, and recommendation distinct.
Use `aria-pressed` for a toggle button. The host supplies its selected style. A selected `.vis-btn-tile` keeps its surface and gains a ring.
Do not disable an action for a correctable input error. Keep it enabled and validate inline after use.
Use native `disabled` only when the action is genuinely unavailable; show its reason as visible nearby text, not only a tooltip.
Wrap every text, select, or range control directly in one `.vis-form-label`; do not separate them with `.vis-column` or `.vis-row`.
Use `.vis-form-select` on `<select>` and `.vis-form-range` on `input[type="range"]`.
Outside mockups, use `.vis-form-value` for values beside controls and `.vis-stat-value` for stat-card values; both render monospace.
For a range value, use direct children `<span>Label</span>`, `<output class="vis-form-value">Value</output>`, then the `.vis-form-range`; this makes two rows.
Use `textarea.vis-form-control` for multi-line input.
For checkbox and radio rows, `.vis-form-item` directly contains the input followed by its matching label.
For an immediate setting, add `.vis-switch` to the checkbox in that structure.
- Set a range input `step` that matches the displayed precision.
- Start with `.vis-btn`. Use at most one `.vis-btn-primary` in the complete view; use `.vis-btn` or `.vis-btn-ghost` for other actions.
- Add `.vis-btn-block` for full width, `.vis-btn-tile` for a wrapping choice, or `.vis-btn-icon` only for an icon-only button.
- Use host component classes unchanged. Do not restyle their descendants, pseudo-elements, geometry, colors, or states.
- Use a `<button type="button">` for an action.
- Do not use `<a>` links or navigation. Keep every interaction inside the visualization.
Give optional inline messages `hidden` until text exists, then toggle content and `hidden` together.
## Feedback
Use `.vis-badge` for a short label and `.vis-alert` for a static callout.
Use a tone class only on its documented compatible component.
A `.vis-status` dot supplements visible text and stays `aria-hidden="true"`.
For determinate progress, use `.vis-progress[role="progressbar"]` with a direct `.vis-progress-bar`.
Set `aria-label`, `aria-valuemin`, `aria-valuemax`, and `aria-valuenow`; match the bar width to the value.
Use `.vis-progress-segmented` on the parent for source-defined segments.
Keep each segment width consistent with its represented value.
A `.vis-spinner` means active work; hide it from assistive technology and add visible text to its `role="status"` region.
For one 0–100 value, use `.vis-gauge[role="progressbar"]` with the four progress ARIA attributes.
Keep `--value`, visible text, and `aria-valuenow` equal.
Use `.vis-gauge.vis-small` or `.vis-gauge.vis-large` only when the surrounding density requires it.
## Selection and disclosure
Use tabs only when each view answers a related question.
Do not hide requested peer metrics or series behind tabs or toggles when they can fit together.
Keep every `input`, `label`, and `.vis-card` as direct children in this exact order:
```html
<div class="vis-tabs">
  <input id="summary" name="view" type="radio" checked /><label for="summary">Summary</label><div class="vis-card">Summary content</div>
  <input id="details" name="view" type="radio" /><label for="details">Details</label><div class="vis-card">Detail content</div>
</div>
```
For button-style tabs, add `.vis-secondary` to `.vis-tabs` and `.vis-btn` to every direct label.
For one small fixed choice, put `.vis-toggle-group[role="radiogroup"]` inside one `.vis-form-label`; directly alternate radio inputs and labels.
Use `<details class="vis-collapsible">` with a direct `<summary>` for optional detail.
Use `open` only when the first paint needs the disclosed content.
## Code and icons
For one command or path, `.vis-snippet` contains an optional hidden `.vis-snippet-prompt` and `<code>`.
For multi-line source, `figure.vis-code-block` contains an optional `<figcaption>` and required `<pre><code>`.
Use `.vis-text-destructive` only for errors or validation the user must notice.
Give every icon button an `aria-label`; set `aria-hidden="true"` on every decorative icon.
Use only approved `data-lucide` icons. Keep inline icons at 16–20px and decorative icons at 24px or less.
Do not hand-draw an SVG path to replace an approved host icon.
