---
name: convert
description: Convert existing CSS to Divi 5-compatible format. Fixes unsupported units, adds proper specificity, wraps for Code Module or strips tags for Theme Options.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Divi 5 CSS Converter

You are converting CSS to be Divi 5 compatible. Apply all necessary transformations.

## Step 1: Get Source CSS

Options:
1. User provides CSS directly
2. User specifies file path
3. User points to file to read

## Step 2: Determine Target Format

Ask if not specified:
- **Theme Options** - Global CSS, no `<style>` tags
- **Code Module** - Page-specific, WITH `<style>` tags
- **Child Theme** - Standard CSS file, no tags

## Step 3: Apply Conversions

### Conversion 1: Unit Replacement
```
75ch → 60rem
60ch → 48rem
45ch → 36rem
30ch → 24rem
Xch → (X * 0.8)rem

Xex → (X * 0.5)em
```

### Conversion 2: Button Specificity
Transform:
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

### Conversion 3: Divi Module Overrides
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
/* Converted CSS here - no tags */
```

**For Child Theme:**
```css
/*
Theme Name: Child Theme
Template: Divi
*/

/* Converted CSS here */
```

### Conversion 6: Container Query Replacement
```css
/* Before */
@container (min-width: 400px) {
  .card { padding: 2rem; }
}

/* After - approximation with media query */
@media (min-width: 400px) {
  .card { padding: 2rem; }
}
/* NOTE: Container queries not supported in Divi 5.
   Using media query as fallback - behavior may differ. */
```

### Conversion 7: Add Hover States
If button/interactive element lacks hover:
```css
/* Add corresponding hover */
body .et_pb_button:hover {
  background: #222222 !important;
  /* Darken by ~10-15% or use design token */
}
```

## Step 4: Add Header Comment

```css
/* ==========================================================================
   DIVI 5 CONVERTED CSS

   Original: [source file or "provided directly"]
   Format: [Theme Options | Code Module | Child Theme]
   Converted: [date]

   Changes made:
   - Replaced Xch units with Xrem
   - Added !important to Divi overrides
   - [other changes]
   ========================================================================== */
```

## Step 5: Validate Converted CSS

Run validation checks to ensure all issues are resolved:
- No `ch`/`ex` units remaining
- All button overrides have `body` prefix
- All Divi overrides have `!important`
- Correct wrapping for format

## Step 6: Output Results

Provide:
1. **Converted CSS** (ready to use)
2. **Changelog** (what was modified)
3. **Usage instructions** (where to paste)

### Example Output:

```
========================================
DIVI 5 CSS CONVERSION COMPLETE
========================================

Changes Made:
1. Line 12: 75ch → 60rem
2. Line 23: Added body prefix and !important to button
3. Line 45: Added !important to section background
4. Lines 1-5: Wrapped in <style> tags for Code Module

Original: 156 lines
Converted: 162 lines

CONVERTED CSS:
----------------------------------------
<style>
/* ==========================================================================
   DIVI 5 CONVERTED CSS
   Format: Code Module
   Converted: 2024-12-25
   ========================================================================== */

:root {
  --accent: gold;
}

body .et_pb_button {
  background: #000000 !important;
  border-radius: 0 !important;
}

/* ... rest of CSS ... */
</style>
----------------------------------------

USAGE:
1. Copy the CSS above (including <style> tags)
2. In Divi Builder, add a Code Module
3. Paste the CSS
4. Save and preview

Would you like me to save this to a file?
```

## Conversion Complete

Offer:
1. Save to file
2. Run validation to confirm
3. Generate additional format (e.g., also Theme Options version)
