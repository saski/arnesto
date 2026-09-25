---
name: visualize
description: >-
  Use /visualize for creating compact charts, diagrams, or other visuals inline
  as part of the conversation itself. It chooses among Markdown tables, Mermaid,
  inline HTML, and other supported in-transcript forms. Use Canvas for durable
  artifacts outside the transcript that users may revisit, refine, or share.
metadata:
  surfaces:
    - ide
environments:
  - local
  - cloud
---
# Visualize
## Mission
Help the user complete the job with the smallest truthful result.
Choose Markdown, Mermaid, or inline HTML before you author the content.
The host supplies styles and runtime behavior to HTML fragments.
This entry file controls routing, output, conduct, design, and review. Its references add specialized rules and cannot override it.
## Workflow
1. Route the request with the detailed rules below.
2. Identify the primary question. Preserve values, labels, units, order, uncertainty, and scope.
3. Plan the hierarchy and only the necessary interaction.
4. Complete the selected route: return Markdown or Mermaid, or follow the HTML lifecycle.
5. Review the result against its source, then stop.

## Routing
Choose one representation:
- Use a Markdown table for ordinary rows and columns. Return it directly and write no files.
- Use fenced Mermaid for static labeled relationships, ERDs, database schemas, and class diagrams. Return it directly and write no files.
- Use inline HTML when interaction, spatial layout, a chart, a simulation, a mockup, a structured view, or artwork adds material value.
- Geographic maps are out of scope. The sandbox cannot load map data or mapping libraries; never hand-draw geographic outlines and present them as a map. Offer the closest truthful non-geographic view instead.
- If an explanation depends on sequence, containment, or mechanism, treat it as a diagram.
- If the user asks for a picture, artwork, illustration, decorative scene, or poster, treat it as artwork.
- A request to preview or explore a proposed UI in the conversation is an inline HTML visualization request.
- A request for a new standalone file, website, app page, component, or other project change is **not** an in-transcript visual output. Build that in the open project.
- Use `/visualize` when the output should be immutable and live inside the transcript. When `/canvas` is available, use it when the output should be a durable artifact outside the transcript that the user may revisit, refine, or share.
For inline HTML, read every applicable reference:
- Every HTML visualization MUST read `references/foundations.md`.
- Every chart, plot, part-to-whole view, or parallel timeline MUST read `references/charts.md`.
- Every form, tool, comparison, card, table, structured view, simulation, explainer, or dense categorical grid MUST read `references/components.md`.
- Every UI mockup or prototype MUST read `references/mockups.md`.
- Every HTML flowchart, structural diagram, or illustrative mechanism MUST read `references/diagrams.md`.
- Every artwork, illustration, decorative scene, or poster MUST read `references/art.md`.
- Exact icons or an unlisted token or class MUST read `references/catalog.md`.
- Read every applicable file. Read no unrelated file.

## Apply shared rules
### Conduct
- Work silently. Do not announce that you will read the skill, choose a format, or write files.
- Return the answer directly. Do not announce the skill, HTML, Markdown, Mermaid, artifacts, or implementation details.
- Keep explanatory prose outside HTML. Include only necessary labels, legends, values, controls, and accessible text.

### Composition and access
These invariants apply to every inline HTML visualization. Only a rule that names the UI mockup or artwork carveout can relax one.
1. Put the primary question and its answer first, with a clear hierarchy.
2. Choose the smallest composition that completes the job.
3. Add only requested controls. Do not invent search, filters, reset actions, toolbars, scores, or filler elements.
4. Use position, length, area, and color only when each encoding has meaning.
5. Make the first paint useful without input, hover, or setup.
6. Use semantic HTML and native controls, each with a visible label or accessible name.
7. Do not invent data, content, metrics, or states, except as `references/mockups.md` allows.
8. Keep every color theme-aware through public catalog tokens; keep structure neutral and give each hue one job.
9. Keep the treatment flat and host-native. Do not use gradients, textures, blur, glow, or decorative shadows outside mockups and artwork.
10. Use the host type scale, font weights 400 and 500, and sentence case.
11. Match information density to the available width. Compose for widths near 736px and down to 320px; stack before content overlaps or clips.
12. Keep motion user-triggered, transform-based, finite, and reduced-motion safe.
13. Give every chart, SVG, and interactive view an accessible name. Pair color with text, shape, or position.
14. Do not repeat the prompt, restate visible information, or add narrative callouts.

### Data integrity
- Use source values and labels exactly unless the user requests a transformation.
- Do not infer missing values or present an estimate as an observation.
- Label a derived value when its method is not obvious.
- For a requested simulation, clearly label every assumption and all illustrative data.

## Create inline HTML
Use this lifecycle only after routing selects HTML.

### Allocate
**Location.** Use `CURSOR_AGENT_STORE_FILES_DIR` when it is set; otherwise use the path labeled "Current agent's store" in your context. Call it `<store-root>`. Write the fragment to `<store-root>/visualizations/<slug>.html`. Create the `visualizations/` directory beneath `<store-root>` if it does not exist. Use the write file tool; do not only show the path or code in chat. If neither store location is available, do not guess another location; tell the user that inline visualizations are unavailable in this environment.

**Naming.** `<slug>` is a short descriptive name for the visualization: lowercase ASCII letters, digits, and interior hyphens only, at most 64 characters, starting and ending with a letter or digit — for example `revenue-by-quarter`. No other characters, dots, slashes, or spaces. List the existing files under `<store-root>/visualizations/` first and pick a name that is not taken; when the natural name is taken, append `-2`, `-3`, and so on.

**File rules:**
- Exactly one `.html` fragment file per visualization. Never create helper files, style files, supporting modules, or `meta.json`.
- Never overwrite an existing file under `visualizations/` — a previously emitted tag must keep rendering the content it referenced.
- Never reuse or modify a path after emitting its content-reference tag. Updates use a fresh file name (suffix the slug) and a new tag.

### Author
- Emit a literal HTML fragment only. Do not include `<!doctype>`, `<html>`, `<head>`, or `<body>`.
- Store raw markup with actual line breaks. Do not serialize the fragment as an escaped language string. Inspect the saved file and remove encoded quotes or newline text.
- Use one unique root element with an `id`; scope custom CSS and JavaScript to it.
- Do not rely on `document.currentScript`.
- Keep the fragment under 1 MB and embed all data.
- The sandbox has no network access of any kind. There is no CDN allowlist; never write a script `src`, an `import` of an external module, or any external URL.
- The only host runtime hook is the exact D3 marker documented in `references/charts.md`. It is required for every chart and any other use of `d3`.
- Do not call `fetch`, `XMLHttpRequest`, `WebSocket`, or `navigator.sendBeacon`.
- Do not create links, submit forms, open windows, or navigate the iframe.
- The host uses `sandbox="allow-scripts"` without `allow-same-origin`. Do not depend on same-origin or parent-document access.
- Conversation callbacks are unavailable. Do not invoke host bridges, parent-frame messaging, or undocumented global functions.
- Do not load external styles, images, fonts, media, frames, workers, or any other network resource.
- Embed custom images and fonts as `data:` URLs. Use `blob:` URLs only for generated images.
- Do not use React, shadcn, Radix, Tailwind utilities, or component-kit imports.
- Use host tokens and classes before custom CSS, except inside a UI mockup.

### Validate
- Do not add visible eyebrows, method notes, source footers, or artifact-type labels.
- Do not leave an empty element in a flex or grid container. Toggle `hidden` together with content.
- Do not draw the same data in a second chart form, a repeated table, or a background band.
- Do not group repeated peers with card chrome when spacing and dividers already group them.

### Publish
After the file write completes, emit this content-reference tag on its own line in that same turn's final response. The virtual `src` contains the visualization file name from the managed file path, but never exposes the absolute path:

```html
<cursor-content kind="visualization" src="visualizations/<slug>.html"></cursor-content>
```

Emit the exact tag shown only after the write completes, with no other attributes. Updates emit their new tag in the same turn.

**Completion gate.** If you wrote or updated an HTML visualization in this turn, do not finish until the final response contains exactly one content-reference tag for that file. Verify that the tag's `src` uses the same file name as the successful write and that the tag is on its own line. A prose description, file path, or successful write without the matching tag is incomplete.

## Review and return
- Return Markdown and Mermaid as complete assistant text. Use GitHub-flavored Markdown and a fenced `mermaid` block.
- Do not create a visualization file for a Markdown or Mermaid result.
- Did you choose the smallest format, and does the result answer the main question first?
- Do values, labels, units, and order match the source?
For inline HTML, also check:
- Does any element compete with that answer without a user need?
- Is the first paint useful, and does the composition hold at 320–360px and about 736px?
- Are all selectors, classes, tokens, functions, and identifiers defined, with valid semantic HTML and accessible names?
- Does the final response contain exactly one content-reference tag matching the written file name on its own line?

Stop after you return Markdown or Mermaid, or after you write the `.html` file and emit its content-reference tag.
Do not start servers, open browsers, or follow unrelated skills.
