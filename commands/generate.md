---
name: generate
description: Generate Divi 5-ready CSS for a component, section, or page element. Outputs in the format you specify (Theme Options, Code Module, or Child Theme).
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - WebSearch
  - WebFetch
---

# Divi 5 CSS Generator

You are generating Divi 5-compatible CSS. Follow these steps:

## Step 1: Understand the Request

Ask the user (if not already specified):
1. **What component/element?** (button, section, card, hero, etc.)
2. **What style?** (colors, fonts, spacing, effects)
3. **Output format?**
   - Theme Options (global CSS, no wrapper)
   - Code Module (with `<style>` tags)
   - Child Theme (standard CSS file)

## Step 2: Check Project Context

Look for existing design tokens or CSS:
- Check for `.claude/divi5-toolkit.local.md` for project preferences
- Check for existing CSS files with design tokens
- Use any existing `--cjs-*` or similar CSS variables

## Step 3: Generate CSS

Apply these Divi 5 requirements:

### Mandatory Rules
1. **No `ch` or `ex` units** - Use `rem` instead (75ch -> 60rem)
2. **Button overrides need:**
   - `body .et_pb_button` selector (body prefix)
   - `!important` on ALL properties
3. **CSS Variables** must be in `:root` for global scope
4. **Use Divi selectors:** `.et_pb_*` for modules

### Output Format

**Theme Options Format:**
```css
/* ==========================================================================
   [Component Name] - Theme Options CSS
   Paste into: Divi -> Theme Options -> Custom CSS
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

## Step 4: Validate Output

Before presenting, verify:
- [ ] No `ch` or `ex` units
- [ ] Button overrides have `body` prefix and `!important`
- [ ] CSS Variables in `:root` if needed
- [ ] Correct format for chosen output type
- [ ] Includes hover states where appropriate
- [ ] Font families have fallbacks

## Step 5: Provide Usage Instructions

Tell the user:
1. Where to paste the CSS
2. What classes to add to Divi modules (via Advanced -> Attributes)
3. Any additional configuration needed

## Example Output

For a "primary button" request with Theme Options format:

```css
/* ==========================================================================
   Primary Button Override - Theme Options CSS
   Paste into: Divi -> Theme Options -> Custom CSS
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

**Usage:** This applies to ALL buttons site-wide. For variants, add a custom class like `my-btn--secondary` via Advanced -> Attributes -> class.
