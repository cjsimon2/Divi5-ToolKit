---
name: validate
description: Validate CSS for Divi 5 compatibility. Checks for button specificity, selector issues, format correctness, and other common problems. Use ultrathink mode for thorough analysis.
argument-hint: <file-or-css>
allowed-tools: Read, Glob, Grep
context: fork
---

# Divi 5 CSS Validator

You are validating CSS for Divi 5 compatibility. **Use ultrathink mode** — be extremely thorough.

## Step 1: Get Validation Mode

Check `.claude/divi5-toolkit.local.md` for:
```yaml
validation_mode: advisory  # or "strict"
```

- **Advisory (default):** Report issues as warnings, suggest fixes
- **Strict:** Report issues as errors, require fixes

## Step 2: Gather CSS to Validate

Options:
1. User provides CSS directly
2. User specifies file path
3. Scan project for CSS files (`**/*.css`)

## Step 3: Ultrathink Validation

**CRITICAL: Analyze every line carefully. Do not miss issues.**

### Check 1: Button Specificity (P0 - Critical)
Look for `.et_pb_button` without:
- `body` prefix
- `!important`

**Report:**
```
CRITICAL: Button override missing specificity
Line X: `.et_pb_button { background: red; }`
Fix: `body .et_pb_button { background: red !important; }`
```

### Check 2: Numbered Selector Usage (P0 - Critical)
Scan for positional selectors that break when modules are reordered:
```regex
\.et_pb_\w+_\d+
```

**Report:**
```
CRITICAL: Fragile numbered selector — breaks when modules reorder
Line X: `.et_pb_text_0 { color: red; }`
Fix: Add a custom class via Advanced > Attributes > class instead
```

### Check 3: CSS Variables Scope (P1 - High)
Variables defined outside `:root`:
```regex
^(?!:root)[^{]+{[^}]*--[a-z]
```

**Report:**
```
WARNING: CSS Variable may be scoped incorrectly
Line X: `.section { --my-color: red; }`
Fix: Move to `:root { --my-color: red; }` for global access
```

### Check 4: Missing !important on Divi Overrides (P1 - High)
Check `.et_pb_*` selectors for missing `!important`:

**Report:**
```
WARNING: Divi override may be ignored without !important
Line X: `.et_pb_section { background: #000; }`
Fix: `.et_pb_section { background: #000 !important; }`
```

### Check 5: Code Module Format (P1 - High)
If file is intended for Code Module, verify `<style>` wrapper.

### Check 6: Theme Options Format (P1 - High)
If file is intended for Theme Options, verify NO `<style>` wrapper.

### Check 7: Module Element CSS with Selectors (P1 - High)
Detect full CSS rulesets that look like they belong in Free-Form CSS but were placed in a Module Element field (Title, Body, Main Element):

**Report:**
```
WARNING: Module Element CSS fields accept property declarations only
If you need full rulesets with selectors, use Free-Form CSS instead
```

### Check 8: Font Stack (P2 - Medium)
Check for font-family without fallbacks:

**Report:**
```
SUGGESTION: Font family missing fallbacks
Line X: `font-family: 'Custom Font';`
Fix: `font-family: 'Custom Font', system-ui, sans-serif;`
```

### Check 9: Hover States (P2 - Medium)
If interactive element has styles, check for corresponding :hover:

**Report:**
```
SUGGESTION: Element may need hover state
Line X: `.my-button { background: #000; }`
Consider: `.my-button:hover { background: #222; }`
```

### Check 10: Responsive Coverage (P2 - Medium)
If CSS has fixed sizes, check for responsive handling:

**Report:**
```
SUGGESTION: Consider fluid values or media queries
Line X: `font-size: 3rem;`
Consider: `font-size: clamp(1.5rem, 3vw, 3rem);`
```

## Step 4: Generate Report

### Advisory Mode:
```
========================================
DIVI 5 COMPATIBILITY REPORT (Advisory)
========================================

CRITICAL ISSUES (must fix):
1. ...

WARNINGS (should fix):
1. ...

SUGGESTIONS (optional):
1. ...

SUMMARY:
- X critical issue(s)
- X warning(s)
- X suggestion(s)

Status: PASSED / NEEDS ATTENTION
========================================
```

### Strict Mode:
```
========================================
DIVI 5 COMPATIBILITY REPORT (Strict)
========================================

ERRORS (blocking):
1. ... [BLOCKING]

SUMMARY:
- X blocking error(s)

Status: PASSED / FAILED
========================================
```

## Step 5: Offer Fixes

Ask user:
> "Would you like me to automatically fix these issues?"

If yes, apply fixes and re-validate to confirm.

## Validation Complete

End with:
1. Summary of findings
2. Next steps recommendation
3. Offer to run `/divi5-toolkit:convert` if major changes needed
