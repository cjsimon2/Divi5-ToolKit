---
name: generate
description: Generate Divi 5-ready CSS for a component, section, or page element. Outputs in the format you specify (Theme Options, Code Module, Child Theme, or Free-Form CSS).
argument-hint: <component-or-element>
allowed-tools: Read, Write, Glob, Grep, WebSearch, WebFetch
---

# Divi 5 CSS Generator

You are generating Divi 5-compatible CSS (v5.1+). Follow these steps:

## Step 1: Understand the Request

Ask the user (if not already specified):
1. **What component/element?** (button, section, card, hero, etc.)
2. **What style?** (colors, fonts, spacing, effects)
3. **Output format?**
   - Theme Options (global CSS, no wrapper)
   - Code Module (with `<style>` tags)
   - Child Theme (standard CSS file)
   - Free-Form CSS (using `selector` keyword, for per-element styling)

## Step 2: Check Project Context

Look for existing design tokens or CSS:
- Check for `.claude/divi5-toolkit.local.md` for project preferences
- Check for existing CSS files with design tokens
- Use any existing CSS variables (e.g., `--my-*` or similar prefix)

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

## Step 5: Provide Usage Instructions

Tell the user:
1. Where to paste the CSS
2. How to add classes via **Advanced > Attributes** (not the old CSS ID & Classes field)
3. Any additional configuration needed
4. For Free-Form CSS: which module's Advanced tab to target

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
  font-family: 'Lato', Helvetica, sans-serif !important;
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
- For variants, add a custom class via **Advanced > Attributes > class** (e.g., `my-btn--secondary`)
- Target the variant: `body .et_pb_button.my-btn--secondary { ... }`
