# HTML diagram reference
Read this file for HTML flowcharts, structural diagrams, technical schematics, data layouts, and illustrative mechanisms.
Use Mermaid for static labeled relationships, ERDs, database schemas, and class diagrams.
## Route by intent
- Route on the user intent and verb, not only the subject. A reference request needs a map: a flowchart for sequence, a structural diagram for containment. An intuition request needs a mental model: an illustrative mechanism.
- Default “How does X work?” to illustrative unless the user asks for architecture, steps, flow, or another reference form. Do not retreat to labeled process boxes when the user asks to understand a mechanism.
- A request for a picture, artwork, poster, or decorative scene is artwork. Read `references/art.md` instead.
- Use one diagram family per view.
## Plan before drawing
1. State the diagram’s one main point.
2. Select a family that exposes that point.
3. Choose the visual variable for each meaning: position, connection, containment, shape, or color.
Prefer one clear overview plus a focused detail over one dense mega-visual. Use no more than two panels side by side; stack further detail vertically.
## Header lockup and legend
Diagrams use the same header lockup as charts, so both read as one system.
- Start every figure, and every side-by-side panel, with one header lockup placed immediately before its drawing, inside the same `.vis-column`:

```html
<div class="vis-chart-meta">
  <div class="vis-chart-meta-copy">
    <h3>Distant object</h3>
    <span>Lens thin, rays nearly parallel</span>
  </div>
  <div class="vis-legend">
    <span class="vis-legend-item"><span class="vis-swatch vis-blue"></span>Light</span>
  </div>
</div>
```

- The `h3` is the title. The `span` is one optional subtitle of at most six words with no period. The host sizes both; do not add margins, font sizes, or a bare `h3`/`p` pair anywhere in the fragment.
- When color carries meaning, put one `.vis-legend` inside `.vis-chart-meta` after `.vis-chart-meta-copy`, as charts do. Use `span.vis-legend-item` with `.vis-swatch` and a palette modifier. No legend for a single hue; no legend below the drawing.
- Do not give the diagram SVG the `.vis-chart` class or wrap it in `figure.vis-chart-figure`; those set chart heights and margins.
## No prose inside the diagram
Explanation belongs in the chat response, not in the fragment.
- Do not put sentences, paragraphs, bullet lists, numbered step lists, notes, takeaways, or caveats inside the visualization. Do not end a figure with a summary line.
- Inside the diagram use only: the header lockup, direct labels, values with units, callouts of at most six words, and the legend.
- Number steps with small numerals placed on the drawing, not with a list beside it.
- In SVG, give each `<text>` the `.vis-chart-text` class. SVG text does not wrap; use explicit rows and short labels.
- Keep at least 8px between text and unrelated marks. Never let a stroke cross text.
## Sizing
The chat column is about 736px wide and shrinks to 320px. The host scales an SVG to its container, so a fixed `viewBox` scales text with it.
- Lay out a full-width figure from the measured container width and re-run on resize. A static 736 `viewBox` halves label size in a narrow column.
- Match a static `viewBox` to its rendered width: about 350 for one of two grid panels, 736 for a full-width figure. Never set a pixel height; keep every mark inside the viewBox.
## Geometry
- Size a node to its text plus 24px padding: about `max(title characters × 8, subtitle characters × 7) + 24` wide, 56px tall for two lines.
- Count named components first. Place at most four full-size nodes in one horizontal tier; for six or more components, group or split the explanation.
- Calculate each tier width before assigning coordinates. Wrap, stack, or split before nodes overlap. Keep at least 20px between unconnected peers and about 48px between connected flow nodes.
## Surfaces and strokes
The drawing must read clearly at a glance. Faint outlines look hesitant and are hard to read.
- Use `.vis-card` for HTML nodes and detail regions. Add `.vis-category-surface` plus one palette modifier only when color carries meaning.
- Stroke tokens by role: `var(--foreground)` for the subject's silhouette and primary structure; `var(--muted-foreground)` for secondary structure and internal detail; `var(--border)` only for guides, dimension lines, leaders, and frames. Never draw the subject's outline in `var(--border)`.
- Draw a solid object as a closed shape with a fill and a `var(--foreground)` outline: `var(--muted)` or `var(--card)` when neutral, a light tint when color has meaning. Reserve `fill="none"` for wires, paths, rays, connectors, and guides.
- Use 1px strokes by default; the main silhouette may use 1.5px. Add `vector-effect="non-scaling-stroke"` so responsive scaling does not thicken lines.
## Connector routing
- Test each connector route against every node and label. Use a direct route only when it crosses no node interior; otherwise use one orthogonal detour.
- Stop connectors at node edges with `fill="none"`. Do not draw through a node and hide the line with fill.
- Use a short labeled return cue when a physical feedback path would traverse the whole layout.
## Color as meaning
- Color must explain category, state, direction, quantity, or the current subject. Use at most two non-neutral hue families unless the data requires distinct categories and a legend.
- For a colored HTML node, combine `.vis-card`, `.vis-category-surface`, and one palette modifier. For a colored SVG node, put `.vis-category-surface` and one palette modifier on a `<g>` with direct shape and text children.
- Use `.vis-success` and `.vis-danger` only for true success/failure or kept/dropped states. Use warm or cool hues for physical properties only when the mapping is truthful.
## Family cues
- Flow: one direction, four or five focused stages, edge labels for branches, a clear return cue for feedback.
- Structure: containment only when location matters, at most three levels, external inputs and outputs outside.
- Data layout: size fields proportionally, label units, expose one concrete example value.
- Technical schematic: stroke-first construction, reference guides, dimensions, fill only for material, region, or state.
- Illustrative mechanism: draw the mechanism itself with a cross-section, cutaway, or spatial metaphor, not generic boxes.
- Before-and-after: a shared frame and object identity; show only the change.
## Interaction
- Keep the diagram’s main meaning available without interaction. Do not make every node clickable or call undefined host functions.
- If selection adds value, use one accessible in-page control and update one nearby detail region. For an explicitly interactive explainer, expose at most one real system control. Static explanations get no controls.
## Review
- Check label fit, text size, and connector intersections at 736px and 360px.
- Check that the subject's outline reads clearly against the background.
