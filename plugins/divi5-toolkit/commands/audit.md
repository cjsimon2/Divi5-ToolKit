---
name: audit
description: Perform a comprehensive CSS audit across all project files. Scores overall Divi 5 compatibility, identifies patterns and anti-patterns, and produces an actionable improvement report with prioritized fixes.
argument-hint: [directory-or-file]
allowed-tools: Read, Glob, Grep, Write
context: fork
---

# Divi 5 CSS Audit

You are performing a comprehensive CSS audit for Divi 5 compatibility. **Use ultrathink mode** for thorough analysis. This goes far beyond single-file validation — it analyzes the entire project holistically.

## Step 1: Read Project Config

Read `.claude/divi5-toolkit.local.md` if it exists. Apply these settings (use defaults if missing):

```yaml
accessibility_level: aa                   # "aa" | "aaa" | "off"
flag_composable_alternatives: true        # true | false
css_prefix: my                            # custom class prefix
divi_version: "5.2"                       # target Divi version
```

**Behavior:**
- `accessibility_level: off` — Skip Category E entirely. Reweight remaining categories proportionally so the total still maxes at 100.
- `accessibility_level: aaa` — Use stricter thresholds: 7:1 contrast for normal text (vs. 4.5:1), focus indicators must be ≥ 2px, flag any animation triggered by hover/focus without reduced-motion fallback.
- `flag_composable_alternatives: false` — Skip the "Composable Settings Opportunities" report section in Step 6.
- `divi_version: "5.0"` or `"5.1"` — Mention in the report that Composable Settings (5.2) and certain bug fixes are not available on the user's target version.

## Step 2: Discover CSS Sources

Scan the project for all CSS:
```
**/*.css
**/*.scss
**/*.less
**/style.css
**/custom.css
**/functions.php  (for wp_enqueue_style and inline CSS)
**/*.html          (for <style> blocks)
**/*.php           (for inline styles)
```

Also check for any design token files.

## Step 3: Collect Metrics

For each CSS file, gather:
- Total lines of CSS
- Number of selectors
- Number of `!important` declarations
- Number of `.et_pb_*` selectors
- Number of CSS variables defined/used
- Number of media queries
- Number of `clamp()`/`min()`/`max()` usage
- Number of hardcoded colors vs. variable references

## Step 4: Run Audit Checks

### Category A: Divi 5 Compatibility (Weight: 40%)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| A1 | Button selectors have `body` prefix + `!important` | Critical | -20 each |
| A2 | No numbered selectors (`.et_pb_*_0`) | Critical | -15 each |
| A3 | CSS variables in `:root` scope | High | -10 each |
| A4 | Code Module CSS wrapped in `<style>` tags | High | -10 each |
| A5 | Theme Options CSS has no `<style>` tags | High | -10 each |
| A6 | Module Element fields have properties only (no selectors) | High | -10 each |
| A7 | `.et_pb_*` overrides use `!important` | Medium | -5 each |
| A8 | No shortcode references (`[et_pb_*]`) — D4 artifact | High | -10 each |

### Category B: Design System Quality (Weight: 20%)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| B1 | Design tokens defined (CSS variables in `:root`) | High | +15 if present |
| B2 | Consistent spacing scale (not random pixel values) | Medium | +10 if consistent |
| B3 | Color values use variables, not hardcoded hex | Medium | -3 per hardcoded |
| B4 | Font stacks have fallbacks | Medium | -5 each missing |
| B5 | Naming convention follows BEM or consistent pattern | Low | +10 if consistent |
| B6 | Custom class prefix used (avoids Divi conflicts) | Medium | +10 if present |

### Category C: Responsive Design (Weight: 15%)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| C1 | Uses fluid values (`clamp()`, `vw`, `calc()`) | Medium | +5 per usage |
| C2 | Media queries target Divi 5 breakpoints (767, 980) | Medium | +5 if aligned |
| C3 | No `!important` in media queries that could be avoided | Low | -2 each |
| C4 | Fixed pixel font sizes without responsive alternative | Medium | -3 each |
| C5 | Uses `min()`/`max()` for layout constraints | Low | +3 per usage |

### Category D: Performance (Weight: 10%)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| D1 | Total CSS size (flag if > 50KB custom CSS) | Medium | -10 if over |
| D2 | Duplicate selectors | Medium | -3 each |
| D3 | Unused selectors (classes not found in templates) | Low | -2 each |
| D4 | Overly broad selectors (`* {}`, `div {}`) | Medium | -5 each |
| D5 | Excessive `!important` (> 30% of declarations) | Low | -5 |

### Category E: Accessibility (Weight: 15%)

**Skipped entirely if `accessibility_level: off`** (reweight other categories to total 100%).
**Stricter thresholds applied if `accessibility_level: aaa`.**

| # | Check | Severity | Points |
|---|-------|----------|--------|
| E1 | Focus styles present (`:focus`, `:focus-visible`) | High | +10 if present, -15 if missing |
| E2 | `prefers-reduced-motion` media query present | Medium | +10 if present |
| E3 | `prefers-color-scheme` support (dark mode) | Low | +5 if present |
| E4 | Text color contrast appears WCAG-compliant | High | -10 per likely violation |
| E5 | Touch targets suggest adequate size (padding on buttons) | Medium | -5 if too small |
| E6 | `outline: none` without replacement focus indicator | Critical | -20 each |

## Step 5: Calculate Score

```
Score = 100 + (sum of all points)
Capped at: 0 (minimum) — 100 (maximum)
```

### Grade Scale

| Score | Grade | Meaning |
|-------|-------|---------|
| 90-100 | A | Excellent — production-ready, well-structured |
| 80-89 | B | Good — minor improvements recommended |
| 70-79 | C | Fair — several issues need attention |
| 60-69 | D | Poor — significant compatibility or quality issues |
| 0-59 | F | Critical — major rework needed |

## Step 6: Generate Report

```
╔══════════════════════════════════════════════════════════════╗
║                   DIVI 5 CSS AUDIT REPORT                   ║
║                      Project: [name]                        ║
║                      Date: [today]                          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  OVERALL SCORE: [XX]/100  Grade: [A-F]                      ║
║                                                              ║
║  ████████████░░░░░░░░  [XX]%                                ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  CATEGORY BREAKDOWN                                          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Divi 5 Compatibility  [XX]/40   ████████░░░░  [status]     ║
║  Design System         [XX]/20   ██████░░░░░░  [status]     ║
║  Responsive Design     [XX]/15   ████░░░░░░░░  [status]     ║
║  Performance           [XX]/10   ██████████░░  [status]     ║
║  Accessibility         [XX]/15   ████████░░░░  [status]     ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  FILES ANALYZED                                              ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  [filename.css]         [XX] lines  [XX] selectors           ║
║  [filename.css]         [XX] lines  [XX] selectors           ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  METRICS SUMMARY                                             ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Total CSS Lines:       [XX]                                 ║
║  Total Selectors:       [XX]                                 ║
║  CSS Variables:         [XX] defined / [XX] used             ║
║  !important Usage:      [XX] ([XX]% of declarations)         ║
║  Fluid Values:          [XX] (clamp/min/max/calc)            ║
║  Media Queries:         [XX]                                 ║
║  Hardcoded Colors:      [XX]                                 ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  CRITICAL ISSUES (fix immediately)                           ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  1. [file:line] [description]                                ║
║     Fix: [solution]                                          ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  WARNINGS (should fix)                                       ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  1. [file:line] [description]                                ║
║     Fix: [solution]                                          ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  SUGGESTIONS (nice to have)                                  ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  1. [description]                                            ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  QUICK WINS (highest impact, lowest effort)                  ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  1. [action] → [expected score improvement]                  ║
║  2. [action] → [expected score improvement]                  ║
║  3. [action] → [expected score improvement]                  ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  COMPOSABLE SETTINGS OPPORTUNITIES                           ║
║  (omitted if flag_composable_alternatives: false)            ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  These CSS rules could be replaced by Divi 5.2's             ║
║  Composable Settings (no custom CSS needed):                 ║
║                                                              ║
║  1. [selector] → [which Composable Setting replaces it]      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

**Omit the entire COMPOSABLE SETTINGS OPPORTUNITIES block if `flag_composable_alternatives: false` in the project config.**

## Step 7: Offer Actions

After presenting the report:
1. **Auto-fix critical issues** — Run `/divi5-toolkit:convert` on affected files
2. **Validate individual files** — Run `/divi5-toolkit:validate` on the worst offenders
3. **Generate missing design tokens** — Create `:root` variables from hardcoded values
4. **Add accessibility CSS** — Generate focus indicators and reduced-motion queries
5. **Scaffold missing sections** — Run `/divi5-toolkit:scaffold` to generate clean, audited section templates
6. **Export report** — Save audit report to file
7. **Re-audit** — Run again after fixes to verify improvement
