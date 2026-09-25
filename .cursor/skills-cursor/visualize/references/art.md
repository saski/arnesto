# Artwork and illustration
Read this file for a picture, artwork, illustration, decorative scene, or poster.
Do not read the chart, component, mockup, or diagram references for artwork.
This fork replaces the Design posture and Color sections in `foundations.md`.
## Route by intent
- Route on the user intent and verb, not only the subject.
- A request to draw, illustrate, or make a picture, poster, scene, or decorative SVG is artwork.
- A request to understand a mechanism is a diagram, not artwork.
- A chart, tool, or UI mockup is not artwork.
## Aesthetic
Use SVG. Keep the viewBox and safe-area rules below. Use a different aesthetic from diagrams:
- Fill the canvas. Art should feel rich, not sparse.
- Use bold colors. Mix semantic and category tokens such as `--muted-foreground`, `--blue`, `--green`, and `--orange` for variety.
- Custom `<style>` color blocks are allowed. Freestyle colors are allowed. Use `light-dark(<light>, <dark>)` when you use custom colors.
- Layer overlapping opaque shapes for depth.
- Use organic forms with `<path>` curves, `<ellipse>`, and `<circle>`.
- Make texture with repetition: parallel lines, dots, or hatching. Do not use raster images, blur, or SVG filters.
- Use geometric patterns with `<g transform="rotate(...)">` for radial symmetry.
## SVG setup
- Emit one root SVG with `width="100%"` and a `viewBox` that contains the finished drawing.
- Keep a unique root `id` on the SVG or a wrapping element.
- Do not set a fixed outer pixel width. Do not use `chart.draw` or `.vis-chart`.
- Set `role="img"` and give the drawing a `<title>` and `<desc>`.
- Keep every mark inside the viewBox. Do not use negative `x` or `y`.
- After layout, set viewBox height from the lowest mark plus a small buffer.
- Keep a safe inset of about 40 viewBox units from each edge.
- Replace a broken SVG. Do not append a second SVG.
- One SVG per fragment.
## Review
- Does the canvas feel filled rather than sparse?
- Do custom colors use `light-dark(<light>, <dark>)` when they are not host tokens?
