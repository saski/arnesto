# UI mockups and prototypes
Read this file when the user explicitly asks to preview or explore a prototype, mockup, UI design, component, screen, or application surface.
This is the carveout module: rules here relax the host-token, typography, and invented-data rules in `SKILL.md` and `references/foundations.md`.
The interface copy rules in `references/foundations.md` still apply.
## Product identity
- Match the product context in the request, including its chrome, navigation, typography, colors, and content.
- If the product design is unavailable, infer a coherent design from the platform and request.
- For Cursor or another host-product mockup, use host classes and tokens unchanged.
- For an external product, create an original root-scoped visual language. Use embedded or system fonts; never load an external font.
## Surfaces and theming
- Leave the chat-adjacent area transparent. Apply an opaque fill to every depicted product surface, including dialogs and floating menus.
- Place temporary layers above the primary product content.
- Support both themes with product-specific `light-dark(<light>, <dark>)` colors unless the user requests one theme.
- Keep ordinary and action text contrast at least 4.5:1, and large text at least 3:1.
- At component scale, show one feature or mobile view inside a bounded product context.
- At application scale, use the available width for the shell or page. Do not add a separate outer card.
## Structure and content
- Put application-wide controls in the application chrome and local controls in their component.
- Choose one compact or comfortable density and apply its control height, padding, and spacing consistently.
- Do not stack a popover on another popover. Use one dialog or an in-flow detail region for the next decision layer.
- When source content is absent, use realistic illustrative copy, content, and states. Do not present them as observed facts.
- Never add a badge or label that names the artifact as a mockup, prototype, UI, diagram, or demo.
- Omit filler dashboards, filler cards, oversized icons, and controls with only one possible option.
- Use semantic controls, realistic spacing, and deliberate product-specific details. Do not fake a screenshot when inspectable UI is needed.
