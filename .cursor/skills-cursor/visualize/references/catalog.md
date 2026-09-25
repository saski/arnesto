# Host catalog
This file is the closed lookup for host-provided names.
If a host token, class, icon, or behavior is absent, the host does not provide it.
Every host-provided class starts with `vis-`. Use these classes before custom CSS, and do not redefine them.
A root-scoped custom selector is valid only when the fragment defines it.
Scope custom SVG rules to `svg.vis-chart` or the custom diagram ID or class. Never target every descendant `svg` in a root that can contain Lucide icons.
## Tokens
Only these custom properties are public author tokens:
- Base: `--background`, `--foreground`
- Card: `--card`, `--card-foreground`
- Primary: `--primary`, `--primary-foreground`
- Muted: `--muted`, `--muted-foreground`, `--tertiary-foreground`
- Accent: `--accent`, `--accent-foreground`
- Semantic: `--success`, `--warning`, `--danger`
- Border: `--border`
- Palette: `--brown`, `--red`, `--orange`, `--yellow`, `--green`
- Palette: `--cyan`, `--blue`, `--purple`, `--magenta`
## Internal implementation tokens
All other custom properties are internal. Do not use them in fragment CSS.
## Styled elements
- `a`; `h1`–`h6`; `p`; `ul` and `ol` through three levels; inline `code`
- `small`, `b`, `strong`, `th`, `hr`, `svg`
## Classes
- Layout: `.vis-section-stack`, `.vis-grid`, `.vis-row`, `.vis-column`, `.vis-center`
- Surfaces: `.vis-card`, `.vis-card-footer`, `.vis-category-surface`, `.vis-stat-card`, `.vis-stat-label`, `.vis-stat-value`, `.vis-chart-figure`
- Text: `.vis-text-small`, `.vis-text-muted`, `.vis-text-tertiary`, `.vis-text-warning`, `.vis-text-destructive`, `.vis-chart-text`
- Alignment: `.vis-text-end`, `.vis-text-center`, `.vis-text-nowrap`, `.vis-sr-only`, `.vis-separator-vertical`
- Controls: `.vis-controls`, `.vis-btn`, `.vis-btn-primary`, `.vis-btn-ghost`, `.vis-btn-icon`, `.vis-btn-block`, `.vis-btn-tile`
- Forms: `.vis-form-label`, `.vis-form-value`, `.vis-form-control`, `.vis-form-select`, `.vis-form-range`, `.vis-form-item`, `.vis-switch`
- Tables: `.vis-table-responsive`, `.vis-table`, `.vis-table-sm`; put `.vis-interactive` on `<tbody>` only for actionable rows
- Table attributes: `align="right"`, `align="center"`
- Feedback: `.vis-badge`, `.vis-alert`, `.vis-progress`, `.vis-progress-bar`, `.vis-progress-segmented`, `.vis-spinner`, `.vis-status`
- Gauge: `.vis-gauge`, `.vis-gauge.vis-small` (48px), `.vis-gauge.vis-large` (96px)
- Disclosure: `.vis-collapsible`, `.vis-tabs`, `.vis-tabs.vis-secondary`, `.vis-toggle-group`
- Chart: `.vis-chart`, `.vis-chart-meta`, `.vis-chart-meta-copy`
- Chart marks: `.vis-axis`, `.vis-grid-x`, `.vis-grid-y`, `.vis-mark`, `.vis-mark.vis-line`, `.vis-data-series`, `.vis-segment-gap`, `.vis-track`, `.vis-selection-guide`, `.vis-reference-guide`, `.vis-hover-guide`, `.vis-label`
- Legend: `.vis-legend`, `.vis-legend-item`, `.vis-swatch`
- Tooltip: `.vis-tooltip`, `.vis-chart-tooltip`, `.vis-tooltip-context`, `.vis-tooltip-row`, `.vis-tooltip-label`, `.vis-tooltip-value`
- Code: `.vis-snippet`, `.vis-snippet-prompt`, `.vis-code-block`
Class structures, element restrictions, and behavior are in the selected recipe file.
`--value` is a `.vis-gauge` parameter from `0` through `100`, not a global color token.
## Tone compatibility
Tone classes are component modifiers. They are not container or layout classes.
- `.vis-accent`, `.vis-success`, `.vis-warn`, `.vis-danger`: compatible with `.vis-badge`, `.vis-alert`, `.vis-status`, `.vis-gauge`, and chart tones.
- `.vis-inverted`: compatible with `.vis-badge`.
- `.vis-fg`, `.vis-fg-60`, `.vis-fg-30`: compatible with chart `.vis-mark`, `.vis-label`, and `.vis-swatch`.
- `.vis-fill-20`: compatible with chart `.vis-mark` and `.vis-swatch`; use it for an area, range, uncertainty, or box fill.
- `.vis-brown`, `.vis-red`, `.vis-orange`, `.vis-yellow`, `.vis-green`: compatible with `.vis-category-surface`, chart `.vis-mark`, `.vis-label`, and `.vis-swatch`.
- `.vis-cyan`, `.vis-blue`, `.vis-purple`, `.vis-magenta`: compatible with `.vis-category-surface`, chart `.vis-mark`, `.vis-label`, and `.vis-swatch`.
- `.vis-tone-secondary`, `.vis-tone-tertiary`: compatible with chart `.vis-mark`, `.vis-label`, and `.vis-swatch` that also has a palette or semantic tone class. Use them for lighter or darker fills of one series, not to tell line series apart.
Use semantic tones only for the named meaning.
## Host data attributes
- `data-tooltip="text"`: adds a host tooltip to its element.
- `data-tooltip-label="text"` with `data-tooltip-value="text"`: formats the host tooltip as one label-value row.
- `data-lucide="name"`: hydrates an approved icon name inside `<i aria-hidden="true">`.
A tooltip does not supply an accessible name.
Use `aria-hidden="true"` on a decorative icon.
No other author data attribute invokes host behavior.
Approved icon names:
- `search`, `arrow-up-right`, `check`, `x`, `info`, `alert`, `chart`
- `refresh`, `settings`, `plus`, `minus`
- `chevron-down`, `chevron-up`, `chevron-left`, `chevron-right`
- `copy`, `download`, `upload`, `link`, `mail`
- `user`, `users`, `calendar`, `clock`
- `star`, `heart`, `home`
- `file`, `folder`, `image`
- `play`, `pause`, `trash`, `pencil`, `lock`
The host creates tooltips and hydrates icons.
Do not add tooltip libraries or icon packages.
