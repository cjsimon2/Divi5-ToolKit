---
name: generate
description: Generate Divi 5-ready CSS for a component, section, or page element. Outputs in the format you specify (Theme Options, Code Module, Child Theme, or Free-Form CSS).
argument-hint: <component-or-element>
allowed-tools: Read, Write, Glob, Grep, WebSearch, WebFetch
---

# Divi 5 CSS Generator

You are generating Divi 5-compatible CSS (v5.6, current). Follow these steps:

## When to Research

Your built-in Divi 5 knowledge (selectors, breakpoints, integration methods, Composable Settings, Canvas system) covers the vast majority of generation tasks. Use `WebSearch` or `WebFetch` only when:
- The user requests styling for a Divi module or feature you're uncertain about
- You need to verify a specific Divi 5.x selector or class name (e.g., the 5.6 module classes)
- The user mentions a recent Divi update or feature you don't recognize

Prefer `help.elegantthemes.com`, `elegantthemes.com/blog`, and `victorduse.com/divi-5-changelog`. Do not search for general CSS knowledge.

## Step 1: Read Project Config

Read `.claude/divi5-toolkit.local.md` if it exists. Apply these settings (use defaults if missing):

```yaml
default_format: theme-options # output format when the user doesn't specify one
css_prefix: my                # prefix for any custom classes you introduce
divi_version: "5.6"           # disambiguates which builder-native features apply in Step 5
active_breakpoints:           # which breakpoints to cover in responsive CSS
  - phone
  - tablet
  - desktop
```

Also check for existing CSS files with design tokens and reuse any existing CSS variables (e.g., `--{prefix}-*`).

## Step 2: Understand the Request

Ask the user (if not already specified):
1. **What component/element?** (button, section, card, hero, etc.)
2. **What style?** (colors, fonts, spacing, effects)
3. **Output format?** — only ask if the request doesn't imply one; otherwise use `default_format`
   - Theme Options (global CSS, no wrapper)
   - Code Module (with `<style>` tags)
   - Child Theme (standard CSS file)
   - Free-Form CSS (using `selector` keyword, for per-element styling)

## Step 3: Generate CSS

Apply these Divi 5 requirements:

### Mandatory Rules
1. **Button overrides need:**
   - `body .et_pb_button` selector (body prefix)
   - `!important` on ALL properties
2. **CSS Variables** must be in `:root` for global scope
3. **Use Divi selectors:** `.et_pb_*` for modules
4. **Use custom classes** — never target numbered selectors (`.et_pb_text_0`)

### CSS Unit Guidelines
- All standard units work in custom CSS (`px`, `em`, `rem`, `%`, `vw`, `vh`, `ch`, `ex`, etc.)
- Builder dropdown only has: `px`, `%`, `em`, `rem`, `vw`, `vh`
- Use `clamp()` for fluid responsive values to minimize breakpoints
- Use `rem` for consistent scaling, `ch` for readable line lengths

### Responsive Approach
- 3 breakpoints active by default: Desktop (base), Tablet (980px), Phone (767px)
- Cover the breakpoints listed in the project's `active_breakpoints` config
- Use `clamp()` and fluid values to reduce breakpoint-specific CSS
- Include responsive media queries when layout behavior changes

### Output Formats

**Theme Options Format:**
```css
/* ==========================================================================
   [Component Name] - Theme Options CSS
   Paste into: Divi > Theme Options > Custom CSS
   ========================================================================== */

/* Your CSS here - no <style> tags */
```

**Code Module Format:**
```html
<style>
/* ==========================================================================
   [Component Name] - Code Module CSS
   Paste into: Divi Code Module
   ========================================================================== */

/* Your CSS here */
</style>
```

**Child Theme Format:**
```css
/* ==========================================================================
   [Component Name] - Child Theme CSS
   Add to: child-theme/style.css
   ========================================================================== */

/* Your CSS here - no <style> tags */
```

**Free-Form CSS Format (per-element):**
```css
/* Paste into: Module > Advanced > Custom CSS > Free-Form CSS */
selector {
  /* Styles for this element */
}
selector:hover {
  /* Hover state */
}
selector h2 {
  /* Target child elements */
}
```

## Step 4: Validate Output

Before presenting, verify:
- [ ] Button overrides have `body` prefix and `!important`
- [ ] CSS Variables in `:root` if needed
- [ ] Correct format for chosen output type
- [ ] Includes hover/focus states where appropriate
- [ ] Font families have fallbacks
- [ ] Uses custom classes, not numbered selectors
- [ ] Responsive behavior addressed (fluid values or media queries)

## Step 5: Check Builder-Native Alternatives

Before presenting CSS, check if the styling could be achieved without CSS:
- Simple sizing, spacing, borders on sub-elements → **Composable Settings** (5.2+)
- Focus, active, checked states on form fields → **Pseudo-class editing** (5.3+)
- Image aspect ratio / object-fit → **Aspect Ratio / Framing settings** (5.5+)
- Complex patterns, cross-element styles, animations → CSS

If a builder-native option covers it, present both options:
1. **No-code approach** — builder instructions (Composable Settings / pseudo-class editing / Aspect Ratio)
2. **CSS approach** — for child themes or more control

## Step 6: Provide Usage Instructions

Tell the user:
1. Where to paste the CSS
2. How to add classes via **Advanced > Attributes** (not the old CSS ID & Classes field)
3. Any additional configuration needed
4. For Free-Form CSS: which module's Advanced tab to target
5. **Accessibility notes**: semantic elements to set, ARIA attributes to add via Attributes panel

## Example Output

For a "primary button" request with Theme Options format:

```css
/* ==========================================================================
   Primary Button Override - Theme Options CSS
   Paste into: Divi > Theme Options > Custom CSS
   ========================================================================== */

body .et_pb_button {
  background-color: #000000 !important;
  border-radius: 0 !important;
  letter-spacing: 4px !important;
  text-transform: uppercase !important;
  font-family: 'Lato', Helvetica, Arial, sans-serif !important;
  font-weight: 400 !important;
  border: 1px solid #000000 !important;
  padding: 0.75em 1.5em !important;
  transition: all 0.3s ease !important;
}

body .et_pb_button:hover {
  background-color: #222222 !important;
  border-color: #222222 !important;
}
```

**Usage:**
- This applies to ALL buttons site-wide
- For variants, add a custom class via **Advanced > Attributes > class** (e.g., `{prefix}-btn--secondary`, where `{prefix}` is the project's `css_prefix` — `my` by default)
- Target the variant: `body .et_pb_button.{prefix}-btn--secondary { ... }`

## Generation Complete

Offer:
1. Save to file
2. Run `/divi5-toolkit:validate` to confirm compatibility
3. Generate additional format (e.g., also provide Free-Form CSS version)
4. Run `/divi5-toolkit:convert` if the user has existing CSS to migrate
5. Run `/divi5-toolkit:scaffold` for a complete section template
6. Run `/divi5-toolkit:audit` to check project-wide CSS health
