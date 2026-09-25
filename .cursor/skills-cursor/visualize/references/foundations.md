# HTML foundations
Read this file for every HTML visualization. It implements the constitution in `SKILL.md`.
## Composition mechanics
- Keep the root transparent and unframed unless the UI mockup carveout applies.
- Do not add item counts, source metadata, or branch and build captions unless they affect a user decision.
## Design posture
- Make the visualization feel native to the host instead of embedded from another product.
- Artwork follows `references/art.md` for posture and color instead of this section.
- Never put a colored one-sided border on a rounded surface. Use spacing, a divider, or one complete neutral border.
- A sequential color scale or physical-property gradient is valid only when it encodes data or mechanism.
- Friendly character belongs in concise copy and useful interaction, not extra chrome.
## Layout
- Use one root `.vis-section-stack` for the major regions unless the UI mockup carveout applies.
- Use `.vis-column` for ordered elements inside one region.
- Use `.vis-row` for compact related values or actions that can wrap.
- Use `.vis-grid` only for equal-width peer comparisons; do not put controls in it.
- Use `.vis-controls` only for responsive labeled fields; put each `.vis-form-label` directly inside it.
- Use 24px between major regions, 12px inside a region, and 8px for compact label-value groups.
- Give each region one job: controls, peer metrics, primary visual, or selected detail.
- Keep one control and its label, value, input, and validation message in the same region.
- Give peer components equal columns, outer geometry, padding, and internal order.
- Reject fixed-width roots, horizontal page spill, nested scroll regions, CSS `position: fixed`, and viewport-sized shells.
- The host supplies the edge inset and lets charts span the full width. Do not add duplicate root padding, chart insets, or negative outer margins.
- Use `minmax(0, 1fr)` for a grid track that must stay inside its container.
- Use `.vis-table-responsive` only when table columns cannot fit after reasonable wrapping.
- Size every chart SVG from its actual container through the host chart API in `references/charts.md`. Size a diagram SVG from its measured container per `references/diagrams.md`. Artwork uses the SVG setup in `references/art.md`.
- At narrow widths, reduce ticks and optional annotations. Keep visible text at least 11 screen pixels.
## Accessibility
- Start a complex interactive HTML view with one `.vis-sr-only` sentence that summarizes its purpose.
- Keep native tab order. Do not add positive `tabindex` values or suppress focus styles.
- Keep important information visible without hover.
- Make pointer targets large enough to use. Add transparent hit targets when a small mark needs interaction.
## Typography
- Use normal text by default and `.vis-text-small` only for secondary annotations.
- Add one concise heading only when the visualization needs it for interpretation.
- Do not add a redundant heading to a chart, table, tool, mockup, or structured view whose purpose is clear.
- Do not apply text size, weight, color, or utility classes to `h1`–`h6`.
- Do not set custom font sizes or line heights outside a UI mockup. The host sizes chart titles, labels, and legends.
- Do not use all caps for decoration or bold words inside a sentence.
- Do not use emoji as icons or decoration. Use an approved host icon when one exists.
- Use `.vis-text-muted` for necessary supporting copy and `.vis-text-tertiary` for placeholders and timestamps.
- Put caveats in an accessible description or metric label, not a visible caption.
- Do not apply opacity to normal text for hierarchy. Use the documented text class.
- Keep the host type defaults. Reserve monospace type for code identifiers.
## Color
- Assign color in this order: neutral structure, semantic state, stable category, then physical property.
- Keep generic steps, boundaries, containers, connectors, axes, grids, and inactive content neutral.
- Use semantic tones only for their named meanings.
- Keep one category hue stable across marks, labels, legends, controls, selected details, and related views.
- Do not assign color by sequence, rank, or visual variety unless an ordered scale encodes a numeric value.
- Outside charts, avoid red, yellow, and green for arbitrary categories. Chart series use stable identities and ramp roles from `references/charts.md`.
- For a physical mechanism, warm hues can encode heat or energy, cool hues can encode cold, and green can encode organic material.
- Keep large-area fills subtle. Keep structural grids and inactive marks thin and neutral.
- Keep values, axes, and direct labels neutral. Apply series color to marks and matching legend swatches.
- Check text contrast against its actual surface, especially muted text on filled surfaces.
## Motion
- Keep the first paint static and complete.
- Move marks to their new values. Do not use fade-only transitions, looping motion, or decorative entrance animation.
- A requested moving first paint permits one finite settling animation. Never reverse it automatically or start a loop.
- Keep the outer stage at a fixed height. Animate transforms inside it.
- Never animate width, height, margin, padding, or other document-flow properties.
- Honor `prefers-reduced-motion`.
## Interface copy
- Write an error as one sentence that states what happened and the next action. Do not show raw exceptions or an `Error:` prefix.
- Use a direct completed-state label such as “Saved.” Do not add “successfully.”
- Use a realistic valid placeholder value. Do not prefix it with “e.g.” or repeat the visible label.
- Explain what can appear in an empty area and name the next useful action. Do not use “Nothing here yet.”
- In system UI, use “your” for user-owned objects and never speak as “I.” Use direct past-tense confirmations.
- Do not add links or navigation. Keep every interaction inside the visualization.
- Start button labels with a verb. Use one through three words and no terminal punctuation.
## Interaction and scripts
- Format every computed number before display with `Math.round`, `toFixed`, or `Intl.NumberFormat`.
- Apply this rule to control readouts, totals, labels, axes, tooltips, and derived values.
- Validate required input in the action handler. On invalid input, stop and show a clear inline error beside the control.
- Clear a validation error when the user edits the related input.
- Do not use fullscreen APIs or controls. For expansion, toggle an in-flow layout and update the control label synchronously.
- Never load an external script, style, or module. Host runtimes are injected, not loaded; the exact D3 marker in `references/charts.md` is the only opt-in hook.
- Place the inline behavior script after every HTML element that it queries or changes.
- Mutate existing interactive elements. Do not replace them with `innerHTML` after listeners are attached.
- Omit HTML and CSS comments from generated fragments.
