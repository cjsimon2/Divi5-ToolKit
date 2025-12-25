---
name: validate
description: Validate CSS for Divi 5 compatibility. Checks for unsupported units, missing !important, specificity issues, and other common problems. Use ultrathink mode for thorough analysis.
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Divi 5 CSS Validator

You are validating CSS for Divi 5 compatibility. **Use ultrathink mode** - be extremely thorough in your analysis.

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

### Check 1: Unsupported Units (P0 - Critical)
Scan for:
```regex
\d+ch|\d+ex
```
These WILL break in Divi 5.

**Report:**
```
CRITICAL: Unsupported unit found
Line X: `max-width: 75ch;`
Fix: `max-width: 60rem;` (75ch ≈ 60rem)
```

### Check 2: Button Specificity (P0 - Critical)
Look for `.et_pb_button` without:
- `body` prefix
- `!important`

**Report:**
```
CRITICAL: Button override missing specificity
Line X: `.et_pb_button { background: red; }`
Fix: `body .et_pb_button { background: red !important; }`
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

### Check 4: Container Queries (P0 - Critical)
Scan for:
```regex
@container
```

**Report:**
```
CRITICAL: Container queries not supported in Divi 5
Line X: `@container (min-width: 400px) { }`
Fix: Use @media queries instead
```

### Check 5: Missing !important on Divi Overrides (P1 - High)
Check `.et_pb_*` selectors for missing `!important`:

**Report:**
```
WARNING: Divi override may be ignored without !important
Line X: `.et_pb_section { background: #000; }`
Fix: `.et_pb_section { background: #000 !important; }`
```

### Check 6: Code Module Format (P1 - High)
If file is intended for Code Module, verify `<style>` wrapper.

### Check 7: Theme Options Format (P1 - High)
If file is intended for Theme Options, verify NO `<style>` wrapper.

### Check 8: Font Stack (P2 - Medium)
Check for font-family without fallbacks:

**Report:**
```
SUGGESTION: Font family missing fallbacks
Line X: `font-family: 'Custom Font';`
Fix: `font-family: 'Custom Font', system-ui, sans-serif;`
```

### Check 9: Hover States (P2 - Medium)
If element has styles, check for corresponding :hover:

**Report:**
```
SUGGESTION: Element may need hover state
Line X: `.my-button { background: #000; }`
Consider adding: `.my-button:hover { background: #222; }`
```

## Step 4: Generate Report

### Advisory Mode Report:
```
========================================
DIVI 5 COMPATIBILITY REPORT (Advisory)
========================================

CRITICAL ISSUES (must fix):
1. Line 45: `ch` unit not supported
   - Current: max-width: 75ch
   - Fix: max-width: 60rem

WARNINGS (should fix):
1. Line 23: Missing !important on button
   - Current: .et_pb_button { background: red }
   - Fix: body .et_pb_button { background: red !important }

SUGGESTIONS (optional):
1. Line 67: Consider adding hover state

SUMMARY:
- 1 critical issue(s)
- 1 warning(s)
- 1 suggestion(s)

Status: NEEDS ATTENTION
========================================
```

### Strict Mode Report:
```
========================================
DIVI 5 COMPATIBILITY REPORT (Strict)
========================================

ERRORS (blocking):
1. Line 45: `ch` unit not supported [BLOCKING]
   - Current: max-width: 75ch
   - Fix: max-width: 60rem

2. Line 23: Missing !important on button [BLOCKING]
   - Current: .et_pb_button { background: red }
   - Fix: body .et_pb_button { background: red !important }

SUMMARY:
- 2 blocking error(s)

Status: FAILED - Fix errors before using in Divi 5
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
