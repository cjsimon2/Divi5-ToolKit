---
name: selector
description: Look up the right CSS selector for any Divi 5 module or sub-element (e.g. "blurb title", "toggle open state", "woo add to cart"). Returns the wrapper class, inner selectors, a paste-ready override pattern, the Free-Form CSS equivalent, and whether a builder setting could replace the CSS entirely.
argument-hint: <module-or-element>
allowed-tools: Read, Grep, Glob
---

# Divi 5 Selector Lookup

You are answering one question fast: **what do I target to style X in Divi 5?** No preamble, no long explanations — a selector card the user can paste from.

## Step 1: Read Project Config

Read `.claude/divi5-toolkit.local.md` if it exists:

```yaml
css_prefix: my          # used in the example custom class
divi_version: "5.13"    # warn if the module is newer than the project's version
```

Defaults: `my` and the newest version this plugin documents.

## Step 2: Resolve the Query

Search these sources in order (all under `${CLAUDE_PLUGIN_ROOT}/skills/`):

1. `divi5-css-patterns/references/divi-selectors.md` — primary selector tables (structural, content, forms, 5.6–5.11 modules, Free-Form patterns).
2. `divi5-css-patterns/examples/new-modules.css` — inner markup trees for Timeline, Breadcrumbs, SVG, TOC, Instagram Feed, Tooltip, Post Filter, Gravity Forms, Charts, Payment Button.
3. `divi5-css-patterns/examples/woocommerce.css` — Woo product grid, cart, checkout selectors.
4. `divi5-css-patterns/examples/forms.css` — form field, checkbox, radio, CF7 Styler selectors.
5. `divi5-css-patterns/SKILL.md` "Common Divi Module Selectors" — fallback.

Match loosely: "blurb heading" → Blurb `.et_pb_blurb` + `h4.et_pb_module_header`; "accordion open" → `.et_pb_toggle_open`; "add to cart" → `.et_pb_wc_add_to_cart` / `.single_add_to_cart_button`. If the query matches more than one module, show the best match and list the alternatives in one line. If nothing matches, say so and give the generic DevTools recipe (Step 4) — do not invent a class name.

## Step 3: Determine the Override Rules

- **Button family** (`.et_pb_button`, Payment Button, Woo add-to-cart, form submit): the override MUST use `body` prefix + `!important` on every property.
- **Other `.et_pb_*` modules**: scope with a custom class (`.et_pb_blurb.{prefix}-feature`) and add `!important` only for properties Divi sets inline.
- **Numbered classes** (`.et_pb_text_0`, `.et_pb_section_1_tb_header`): never recommend. Show the custom-class alternative instead.
- **Version gate**: if the module shipped after the project's `divi_version` (Tooltip 5.8, Post Filter 5.10, Charts / Gravity Forms / Imagely Gallery / Payment Button 5.11), say so in one line.
- **Verify-in-DevTools caveat**: for modules released 5.8 or later, note that inner selectors are based on observed markup and should be confirmed in DevTools.

Check the Composable Settings table in `${CLAUDE_PLUGIN_ROOT}/skills/divi5-compatibility/SKILL.md` — if the user's likely goal (hover color, border, spacing, aspect ratio, focus state, gradient text, grid layout, tooltip, `align-items`) has a builder-native path, include it under BUILDER INSTEAD.

## Step 4: Answer

```
SELECTOR: [Module name] — [sub-element]

WRAPPER      .et_pb_blurb
TARGET       .et_pb_blurb .et_pb_module_header
ALSO         .et_pb_blurb_content, .et_pb_blurb_description, .et_pb_main_blurb_image

OVERRIDE (Theme Options > Custom CSS)
  .et_pb_blurb.{prefix}-feature .et_pb_module_header {
    font-size: 1.25rem;
    color: #1d1f22;
  }
  → add class "{prefix}-feature" via Advanced > Attributes > class

FREE-FORM (module > Advanced > Custom CSS > Free-Form)
  selector .et_pb_module_header { font-size: 1.25rem; }

BUILDER INSTEAD   Title typography lives in Design > Title Text — no CSS needed for size/color.
SINCE             Divi 5.0 (core module)
VERIFY            [only for 5.8+ modules] Inner selectors observed, confirm in DevTools.
```

Substitute the real `css_prefix`. Keep the card under ~25 lines. If the user asked for several elements at once, output one compact card per element.

When nothing matches, output:

```
NO MATCH for "[query]"
Nearest: [up to 3 module names]
DevTools recipe: open the page on the frontend (not the builder), right-click the element → Inspect,
walk up to the nearest `.et_pb_*` wrapper, and use `.et_pb_<module>.{prefix}-<name> <inner>` as your selector.
```

## Important Notes

- Selectors only. Don't write full component CSS here — point to `/divi5-toolkit:generate` for that.
- Don't run `WebSearch`; this command is offline by design. If the module is unknown to the plugin, recommend `/divi5-toolkit:research`.
- Always show the paste location for the override and the Attributes-panel step for the custom class.
