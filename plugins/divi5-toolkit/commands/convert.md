---
name: convert
description: Convert existing CSS to Divi 5-compatible format. Fixes specificity issues, adds proper overrides, handles format wrapping, and supports Divi 4 to Divi 5 migration.
argument-hint: <file-or-css>
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Divi 5 CSS Converter

You are converting CSS to be Divi 5 compatible. Apply all necessary transformations.

## Step 0: Read Project Config

Read `.claude/divi5-toolkit.local.md` if it exists. Apply these settings (use defaults if missing):

```yaml
default_format: theme-options             # default target format
flag_composable_alternatives: true        # whether to suggest builder-native alternatives
css_prefix: my                            # custom class prefix
```

**Behavior:**
- If the user does not specify a target format in Step 2, use `default_format`.
- If `flag_composable_alternatives: false`, **skip Conversion 9 entirely** (do not suggest Composable Settings alternatives).
- Use `css_prefix` when introducing new custom classes.

## Step 1: Get Source CSS

Options:
1. User provides CSS directly
2. User specifies file path
3. User points to file to read

## Step 2: Determine Target Format

Ask if not specified:
- **Theme Options** — Global CSS, no `<style>` tags
- **Code Module** — Page-specific, WITH `<style>` tags
- **Child Theme** — Standard CSS file, no tags
- **Free-Form CSS** — Using `selector` keyword, for per-element styling

## Step 3: Detect Migration Context

Check if the CSS appears to be from Divi 4:
- Contains shortcode references (`[et_pb_*]`)
- Uses old CSS ID & Classes patterns
- Targets selectors that changed between D4 and D5

If migrating from D4, note specific changes needed.

## Step 4: Apply Conversions

### Conversion 1: Button Specificity
```css
/* Before */
.et_pb_button {
  background: red;
  border-radius: 5px;
}

/* After */
body .et_pb_button {
  background: red !important;
  border-radius: 5px !important;
}
```

### Conversion 2: Divi Module Overrides
Add `!important` to all `.et_pb_*` selectors:
```css
/* Before */
.et_pb_section {
  background: #1d1f22;
}

/* After */
.et_pb_section {
  background: #1d1f22 !important;
}
```

### Conversion 3: Numbered Selectors to Custom Classes
```css
/* Before — fragile */
.et_pb_text_0 { color: red; }

/* After — stable */
.my-intro-text { color: red; }
/* Note: Add class via Advanced > Attributes > class */
```

### Conversion 4: CSS Variable Hoisting
Move variables to `:root`:
```css
/* Before */
.my-component {
  --accent: gold;
  color: var(--accent);
}

/* After */
:root {
  --accent: gold;
}
.my-component {
  color: var(--accent);
}
```

### Conversion 5: Format Wrapping

**For Code Module:**
```html
<style>
/* Converted CSS here */
</style>
```

**For Theme Options:**
```css
/* Converted CSS here — no tags */
```

**For Free-Form CSS:**
```css
/* Replace specific selectors with `selector` keyword */
selector { /* styles */ }
selector:hover { /* hover styles */ }
```

### Conversion 6: Fluid Responsive Values
Where fixed sizes are used, suggest fluid alternatives:
```css
/* Before */
font-size: 3rem;
padding: 4rem;

/* After — fluid */
font-size: clamp(1.5rem, 3vw, 3rem);
padding: clamp(1rem, 3vw, 4rem);
```

### Conversion 7: Add Hover States
If button/interactive element lacks hover:
```css
body .et_pb_button:hover {
  background: #222222 !important;
}
```

## Step 5: Add Header Comment

```css
/* ==========================================================================
   DIVI 5 CONVERTED CSS

   Original: [source file or "provided directly"]
   Format: [Theme Options | Code Module | Child Theme | Free-Form CSS]
   Converted: [date]

   Changes made:
   - [list of changes]
   ========================================================================== */
```

## Step 6: Validate Converted CSS

Run validation checks to ensure all issues are resolved:
- All button overrides have `body` prefix
- All Divi overrides have `!important`
- No numbered selectors
- Correct wrapping for format
- CSS variables in `:root`

After conversion, recommend running `/divi5-toolkit:validate` to confirm the
converted output passes full compatibility checks.

## Step 7: Output Results

Provide:
1. **Converted CSS** (ready to use)
2. **Changelog** (what was modified)
3. **Usage instructions** (where to paste, how to add classes via Attributes panel)

### Conversion 8: Accessibility Additions
If CSS has animations or interactive elements, add:
```css
/* Add if missing */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Add focus indicators if missing */
:focus-visible {
  outline: 2px solid var(--color-primary, #2ea3f2);
  outline-offset: 2px;
}
```

### Conversion 9: Builder-Native Alternatives (Divi 5.2+)
**Skip entirely if `flag_composable_alternatives: false`.**
Flag CSS that could be replaced by builder-native features:
```
BUILDER-NATIVE OPPORTUNITIES:
- Line X: `.et_pb_blurb .et_pb_main_blurb_image { width: 80px; }`
  → Enable Sizing on blurb image sub-element via Compose Settings (5.2+)
- Line Y: `.et_pb_button { border-radius: 50px; }`
  → Set border-radius on button sub-element in builder (5.2+)
- Line Z: `.et_pb_contact_field:focus { ... }`
  → Use pseudo-class editing (:focus tab in design panel) (5.3+)
```

Note these as optional — the CSS still works, but builder-native is preferred.

## Conversion Complete

Offer:
1. Save to file
2. Run `/divi5-toolkit:validate` to confirm compatibility
3. Generate additional format (e.g., also provide Free-Form CSS version)
4. Run `/divi5-toolkit:audit` for full project health check
