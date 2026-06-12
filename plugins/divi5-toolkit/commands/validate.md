---
name: validate
description: Validate CSS for Divi 5 compatibility. Checks for button specificity, selector issues, format correctness, and other common problems. Use ultrathink mode for thorough analysis.
argument-hint: <file-or-css>
allowed-tools: Read, Glob, Grep
context: fork
---

# Divi 5 CSS Validator

You are validating CSS for Divi 5 compatibility. **Use ultrathink mode** — be extremely thorough.

This command performs a deep, single-file/CSS-block validation. For lightweight,
automatic background validation on file save, the `divi5-validator` agent is
invoked by the PostToolUse hook. For a full project-wide audit across many
files, use `/divi5-toolkit:audit` instead.

## Step 1: Read Project Config

Check `.claude/divi5-toolkit.local.md` for these settings (use defaults if file or key is missing):

```yaml
validation_mode: advisory                # "advisory" (warnings) or "strict" (blocking)
accessibility_level: aa                   # "aa" | "aaa" | "off"
flag_composable_alternatives: true        # true | false
```

**Behavior:**

- `validation_mode`
  - **Advisory (default):** Report issues as warnings, suggest fixes
  - **Strict:** Report issues as errors, require fixes
- `accessibility_level`
  - **`aa` (default):** Run Checks 11–12 at WCAG 2.1 AA strictness
  - **`aaa`:** Also flag missing `prefers-color-scheme`, contrast below 7:1 for normal text, focus indicators thinner than 2px
  - **`off`:** Skip Checks 11 and 12 entirely
- `flag_composable_alternatives`
  - **`true` (default):** Run Check 13 (Composable Settings opportunities)
  - **`false`:** Skip Check 13 entirely

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
Variables defined outside `:root`. Locate custom property declarations with `^\s*--[a-z][\w-]*\s*:` (the Grep tool doesn't support lookaheads), then check each declaration's enclosing selector — flag any that isn't `:root`:

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

### Check 11: Accessibility — Focus Indicators (P1 - High)
**Skip if `accessibility_level: off`.**
Check for `outline: none` or `outline: 0` without replacement focus styles:

**Report:**
```
WARNING: Focus indicator removed without replacement
Line X: `*:focus { outline: none; }`
Fix: Add :focus-visible styles with visible outline
WCAG: 2.4.7 Focus Visible (Level AA)
```

### Check 12: Accessibility — Reduced Motion (P2 - Medium)
**Skip if `accessibility_level: off`.** **If `accessibility_level: aaa`, also flag any animation triggered by user interaction (hover/focus) without a reduced-motion fallback as P1 instead of P2.**
If CSS contains animations or transitions, check for `prefers-reduced-motion`:

**Report:**
```
SUGGESTION: Animations without reduced-motion fallback
Found: X animation/transition declarations
Missing: @media (prefers-reduced-motion: reduce) query
Fix: Add reduced-motion media query to disable or simplify animations
```

### Check 13: Builder-Native Alternatives (P3 - Info)
**Skip entirely if `flag_composable_alternatives: false`.**
Flag CSS that could be replaced by builder-native features:
- Width/height/sizing on sub-elements (titles, buttons, images) → Composable Settings (5.2+)
- Simple borders, animations, or transforms on sub-elements → Composable Settings (5.2+)
- Focus/active/checked states on form fields → pseudo-class editing (5.3+)
- Image aspect ratio or object-fit → Aspect Ratio / Framing settings (5.5+)

**Report:**
```
INFO: This CSS may be unnecessary with Divi's builder-native settings
Line X: `.et_pb_blurb .et_pb_main_blurb_image { width: 80px; }`
Alternative: Enable Sizing options on blurb image via Compose Settings (5.2+)
```

### Check 14: Hardcoded Colors (P2 - Medium)
Flag hex/rgb colors that should use CSS variables for maintainability:

**Report:**
```
SUGGESTION: Hardcoded color — consider using a CSS variable
Line X: `color: #2ea3f2;`
Consider: `color: var(--color-primary);` with `:root { --color-primary: #2ea3f2; }`
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
4. For ambiguous symptoms (styles apply in builder but not frontend, unexpected specificity conflicts), suggest `/divi5-toolkit:diagnose` for guided triage
