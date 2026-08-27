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
divi_version: "5.11"                      # target Divi version
```

**Behavior:**
- `accessibility_level: off` — Skip Category E entirely. Reweight remaining categories proportionally so the total still maxes at 100.
- `accessibility_level: aaa` — Use stricter thresholds: 7:1 contrast for normal text (vs. 4.5:1), focus indicators must be ≥ 2px, flag any animation triggered by hover/focus without reduced-motion fallback.
- `flag_composable_alternatives: false` — Skip the "Composable Settings Opportunities" report section in Step 6.
- `divi_version: "5.0"` or `"5.1"` — Mention in the report that Composable Settings (5.2+), pseudo-class editing (5.3+), Aspect Ratio/Framing (5.5+), and certain bug fixes are not available on the user's target version.

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

Each category has a point budget (A 40, B 20, C 15, D 10, E 15 — total 100) and is scored independently: **deduction categories** (A, D) start at their max and lose points per finding; **award categories** (B, C, E) earn points per criterion met. Every category is floored at 0 and capped at its max.

### Category A: Divi 5 Compatibility (max 40 — start at 40, deduct per finding)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| A1 | Button selectors have `body` prefix + `!important` | Critical | -10 each |
| A2 | No numbered selectors (`.et_pb_*_0`) | Critical | -8 each |
| A3 | CSS variables in `:root` scope | High | -4 each |
| A4 | Code Module CSS wrapped in `<style>` tags | High | -5 each |
| A5 | Theme Options CSS has no `<style>` tags | High | -5 each |
| A6 | Module Element fields have properties only (no selectors) | High | -5 each |
| A7 | `.et_pb_*` overrides use `!important` | Medium | -2 each |
| A8 | No shortcode references (`[et_pb_*]`) — D4 artifact | High | -5 each |

### Category B: Design System Quality (max 20 — award per criterion)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| B1 | Design tokens defined (CSS variables in `:root`) | High | +6 |
| B2 | Consistent spacing scale (not random pixel values) | Medium | +3 |
| B3 | Color values use variables, not hardcoded hex | Medium | +4 (reduce proportionally per hardcoded color) |
| B4 | Font stacks have fallbacks | Medium | +3 |
| B5 | Naming convention follows BEM or consistent pattern | Low | +2 |
| B6 | Custom class prefix used (avoids Divi conflicts) | Medium | +2 |

### Category C: Responsive Design (max 15 — award per criterion)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| C1 | Uses fluid values (`clamp()`, `min()`/`max()`, `vw`, `calc()`) where appropriate | Medium | +6 |
| C2 | Media queries align with the project's active Divi breakpoints (defaults: 767, 980) | Medium | +4 |
| C3 | No `!important` in media queries that could be avoided | Low | +2 |
| C4 | No fixed pixel font sizes without responsive alternative | Medium | +3 |

### Category D: Performance (max 10 — start at 10, deduct per finding)

| # | Check | Severity | Points |
|---|-------|----------|--------|
| D1 | Total CSS size (flag if > 50KB custom CSS) | Medium | -4 if over |
| D2 | Duplicate selectors | Medium | -1 each (max -3) |
| D3 | Unused selectors (classes not found in templates) | Low | -1 each (max -2) |
| D4 | Overly broad selectors (`* {}`, `div {}`) | Medium | -2 each |
| D5 | Excessive `!important` (> 30% of declarations) | Low | -3 |

### Category E: Accessibility (max 15 — award per criterion, with one critical deduction)

**Skipped entirely if `accessibility_level: off`** (rescale: final score = (A+B+C+D) × 100/85).
**Stricter thresholds applied if `accessibility_level: aaa`.**

| # | Check | Severity | Points |
|---|-------|----------|--------|
| E1 | Focus styles present (`:focus`, `:focus-visible`) | High | +5 |
| E2 | `prefers-reduced-motion` query present (auto-award if no animations exist) | Medium | +4 |
| E3 | `prefers-color-scheme` support (dark mode) | Low | +1 |
| E4 | Text color contrast appears WCAG-compliant | High | +3 (deduct 1 per likely violation) |
| E5 | Touch targets suggest adequate size (padding on buttons) | Medium | +2 |
| E6 | `outline: none` without replacement focus indicator | Critical | -5 each |

## Step 5: Calculate Score

```
Category score = clamp(category points, 0, category max)
Total Score    = A + B + C + D + E          (0–100)
                 (if accessibility_level: off → (A+B+C+D) × 100/85, rounded)
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
║  These CSS rules could be replaced by Divi 5.2+ Composable   ║
║  Settings or 5.3+ pseudo-class editing (no custom CSS):      ║
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
8. **Performance deep-dive** — If Category D flags major issues, spawn the `divi5-performance` agent for Critical CSS, font loading, and Dynamic CSS analysis. Or run `/divi5-toolkit:diagnose` for ambiguous performance symptoms.
9. **Device-level verification** — If Category C scored poorly, run `/divi5-toolkit:responsive` to test the live page (or the CSS statically) across the 9-size device matrix.
