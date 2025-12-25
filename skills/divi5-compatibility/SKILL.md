---
name: Divi 5 Compatibility
description: Use this skill when validating CSS for Divi 5 compatibility, checking for unsupported features, troubleshooting Divi CSS issues, or when the user mentions CSS not working in Divi. Provides compatibility rules, validation patterns, and fixes for common issues.
version: 1.0.0
---

# Divi 5 Compatibility Reference

## Quick Compatibility Check

When reviewing CSS for Divi 5, check for these issues:

### CRITICAL: Not Supported

| Feature | Status | Fix |
|---------|--------|-----|
| `ch` unit | NOT SUPPORTED | Use `rem` (75ch -> 60rem) |
| `ex` unit | NOT SUPPORTED | Use `em` or `rem` |
| Container Queries | NOT YET | Coming in future update |
| `@container` | NOT YET | Use media queries |

### Supported Features

| Feature | Status | Notes |
|---------|--------|-------|
| CSS Variables | SUPPORTED | Must be in `:root` for global scope |
| `calc()` | SUPPORTED | Full support |
| `clamp()` | SUPPORTED | Full support |
| `min()` | SUPPORTED | Full support |
| `max()` | SUPPORTED | Full support |
| Flexbox | SUPPORTED | Native to Divi 5 layout |
| CSS Grid | SUPPORTED | Full support |
| `px` | SUPPORTED | Standard unit |
| `em` | SUPPORTED | Relative to parent font |
| `rem` | SUPPORTED | Relative to root font |
| `%` | SUPPORTED | Percentage |
| `vw` | SUPPORTED | Viewport width |
| `vh` | SUPPORTED | Viewport height |
| `vmin` | SUPPORTED | Viewport minimum |
| `vmax` | SUPPORTED | Viewport maximum |

## Validation Rules

### Rule 1: Character Units
```css
/* INVALID - ch not supported */
max-width: 75ch;
width: 60ch;

/* VALID - use rem instead */
max-width: 60rem;  /* 75ch -> 60rem */
width: 48rem;      /* 60ch -> 48rem */
```

**Conversion formula:** 1ch -> approx. 0.8rem (varies by font)

### Rule 2: Button Specificity
```css
/* WILL NOT WORK - Divi overrides this */
.et_pb_button {
  background-color: #000000;
}

/* WILL WORK - proper override */
body .et_pb_button {
  background-color: #000000 !important;
}
```

**Required for buttons:**
- `body` prefix for specificity
- `!important` on all properties

### Rule 3: CSS Variable Scope
```css
/* WILL NOT WORK - wrong scope */
.my-section {
  --my-color: #2ea3f2;
}
.other-element {
  color: var(--my-color);  /* Undefined! */
}

/* WILL WORK - :root scope */
:root {
  --my-color: #2ea3f2;
}
.other-element {
  color: var(--my-color);  /* Works! */
}
```

### Rule 4: Code Module Wrapping
```html
<!-- INVALID - raw CSS in Code Module -->
.my-class { color: red; }

<!-- VALID - wrapped in style tags -->
<style>
.my-class { color: red; }
</style>
```

### Rule 5: Theme Options Format
```css
/* VALID for Theme Options - no tags */
:root {
  --my-color: #2ea3f2;
}
body .et_pb_button {
  background-color: var(--my-color) !important;
}

<!-- INVALID for Theme Options - has tags -->
<style>
:root { --my-color: #2ea3f2; }
</style>
```

## Common Issues & Fixes

### Issue: Button styles not applying
**Symptom:** Custom button colors/styles ignored
**Cause:** Low specificity, missing !important
**Fix:**
```css
body .et_pb_button {
  background-color: #000000 !important;
  border-radius: 0 !important;
  /* ALL properties need !important */
}
```

### Issue: Text too wide on large screens
**Symptom:** Text stretches across entire screen
**Cause:** Using `ch` unit or no max-width
**Fix:**
```css
.et_pb_text_inner p {
  max-width: 60rem;  /* NOT 75ch */
}
```

### Issue: CSS Variables not working
**Symptom:** Variables undefined or not applying
**Cause:** Wrong scope or wrong syntax
**Fix:**
```css
/* Variables MUST be in :root */
:root {
  --my-color: #2ea3f2;
}

/* Reference with var() */
.element {
  color: var(--my-color);
}
```

### Issue: Hover states not working
**Symptom:** Hover effects ignored
**Cause:** Divi's inline styles override
**Fix:**
```css
body .et_pb_button:hover {
  background-color: #222222 !important;
  /* Include ALL hover properties */
}
```

### Issue: Font not loading
**Symptom:** Fallback font displays instead
**Cause:** Font not loaded or wrong name
**Fix:**
```css
/* Ensure font is loaded via Google Fonts or @font-face */
/* Use exact font name with proper fallbacks */
font-family: 'Fira Sans', system-ui, sans-serif !important;
```

### Issue: Section background wrong
**Symptom:** Background color different than expected
**Cause:** Divi's inline styles
**Fix:**
```css
.et_pb_section.my-dark-section {
  background-color: #1d1f22 !important;
}
```

### Issue: Flexbox layout breaking
**Symptom:** Layout doesn't match design
**Cause:** Divi 5 uses Flexbox by default, conflicts with custom
**Fix:** Work with Divi's Flexbox, don't fight it
```css
/* Use Divi's built-in flex controls in Visual Builder */
/* Or override completely */
.et_pb_row {
  display: flex !important;
  flex-direction: row !important;
  gap: 2rem !important;
}
```

## Validation Checklist

When reviewing CSS for Divi 5, verify:

- [ ] No `ch` or `ex` units
- [ ] No `@container` queries
- [ ] All button overrides have `body` prefix and `!important`
- [ ] CSS Variables defined in `:root`
- [ ] Code Module CSS wrapped in `<style>` tags
- [ ] Theme Options CSS has NO `<style>` tags
- [ ] Hover states include `!important`
- [ ] Font families include fallbacks
- [ ] Max-width uses `rem` not `ch`

## Error Messages Reference

### "Property ignored"
Usually means low specificity. Add `!important`.

### "Unknown property"
Check for typos or unsupported properties.

### "Unknown unit"
Using `ch` or `ex`. Replace with `rem` or `em`.

### "Unexpected token"
Syntax error. Check for missing semicolons, braces, or quotes.

### Styles not applying at all
Check:
1. Is CSS in correct location? (Theme Options vs Code Module)
2. Are style tags correct? (needed for Code Module, NOT for Theme Options)
3. Is selector correct? Check in browser DevTools

## Divi-Specific CSS Debugging

### Using Browser DevTools
1. Right-click element -> Inspect
2. Look at Styles panel
3. Check for:
   - Crossed-out styles (being overridden)
   - Grayed-out styles (invalid)
   - Inline styles (Divi's defaults)

### Common Override Pattern
```css
/* If Divi uses: */
style="background-color: blue !important;"

/* You need higher specificity: */
body .et_pb_section#my-id {
  background-color: red !important;
}
/* Or use ID selector for highest specificity */
```

## Compatibility Mode Reference

### Advisory Mode (Default)
- Reports issues as warnings
- Suggests fixes
- Allows proceeding with warnings

### Strict Mode
- Reports issues as errors
- Requires fixes before proceeding
- Blocks incompatible CSS

Configure in `.claude/divi5-toolkit.local.md`:
```yaml
---
validation_mode: advisory  # or "strict"
---
```

## Resources

When issues aren't resolved:
1. Check Elegant Themes documentation: https://help.elegantthemes.com
2. Research on Context7 for latest Divi 5 updates
3. Use `/divi5-toolkit:research` command for current info
4. Consult Codex or ChatGPT for complex CSS questions
