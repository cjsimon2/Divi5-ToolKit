---
# Divi5 Toolkit Configuration
# Copy this file to .claude/divi5-toolkit.local.md in your project

# Validation Mode
# - advisory: Report issues as warnings, allow proceeding
# - strict: Report issues as errors, block incompatible CSS
validation_mode: advisory

# Default Output Format
# - theme-options: Global CSS for Divi > Theme Options (no tags)
# - code-module: Page-specific CSS with <style> tags
# - child-theme: Standard CSS file for child theme
# - free-form: Per-element CSS using selector keyword
default_format: theme-options

# Auto-Validate CSS
# When true, automatically validates CSS files after Write/Edit
auto_validate: true

# Last Research Date
# Auto-updated by divi5-researcher agent
last_research: 2026-04-12

# Divi Version
# Track which Divi version this project targets
# Supported: "5.0", "5.1", "5.2"
divi_version: "5.2"

# Project Design Tokens (optional)
# Define your project's CSS variable prefix
css_prefix: my

# Active Breakpoints
# Which of Divi 5's 7 breakpoints are enabled for this project
# Default: phone (767px), tablet (980px), desktop (base)
# Optional: phone-wide (860px), tablet-wide (1024px), widescreen (1280px), ultra-wide (2560px)
active_breakpoints:
  - phone
  - tablet
  - desktop

# Accessibility Level
# Read by: /validate, /audit, divi5-accessibility agent
# - aa: WCAG 2.1 Level AA (recommended minimum, 4.5:1 contrast for normal text)
# - aaa: WCAG 2.1 Level AAA (stricter — 7:1 contrast, 2px focus rings, animation rules)
# - off: Skip accessibility checks entirely
accessibility_level: aa

# Composable Settings Awareness (Divi 5.2+)
# Read by: /validate (Check 13), /convert (Conversion 9), /audit (opportunities section)
# When true, the toolkit flags CSS that could be replaced by Divi 5.2 Composable Settings
# in the builder. Set to false to suppress these hints (e.g., on Divi 5.0 / 5.1 projects).
flag_composable_alternatives: true

# Scaffold Defaults
# Read by: /scaffold (Step 1)
# Default color scheme used by /scaffold when the user doesn't specify one.
scaffold_style: light  # "light" | "dark" | "brand"

# Learned Errors (auto-populated by divi5-error-learner)
learned_errors: []

# Research Notes (auto-populated by divi5-researcher)
research_notes: |
  Initial plugin setup. Run /divi5-toolkit:research for latest Divi 5 info.
---

# Divi5 Toolkit - Project Configuration

This file stores project-specific settings for the Divi5 Toolkit plugin.

## Quick Reference

### Commands
- /divi5-toolkit:generate - Generate Divi 5-ready CSS
- /divi5-toolkit:validate - Validate CSS compatibility
- /divi5-toolkit:convert - Convert CSS to Divi 5 format
- /divi5-toolkit:research - Research latest Divi 5 updates
- /divi5-toolkit:scaffold - Generate complete page section templates
- /divi5-toolkit:audit - Run full project CSS audit

### CSS Integration Methods (Divi 5)
1. **Theme Options** — Divi > Theme Options > Custom CSS (global, no tags)
2. **Page-Level CSS** — Page Settings > Advanced > Custom CSS
3. **Free-Form CSS** — Module > Advanced > Custom CSS > Free-Form (uses `selector` keyword)
4. **Module Elements** — Module > Advanced > Custom CSS > Title/Body/etc. (properties only)
5. **Code Module** — Add Code Module, wrap in `<style>` tags
6. **Custom HTML Wrappers** — Module > Advanced > HTML > Before/After
7. **Child Theme** — child-theme/style.css
8. **Composable Settings (5.2)** — toggle any design option on any sub-element in the builder

### Adding Classes in Divi 5
Go to **Advanced > Attributes** (not the old CSS ID & Classes field).

### Key Patterns
- Button overrides: `body .et_pb_button { ... !important; }`
- Use custom classes, not numbered selectors (`.et_pb_text_0`)
- CSS variables in `:root` for global scope
- Use `clamp()` for fluid responsive values
- Check Composable Settings before writing CSS (Divi 5.2+)
- Include `prefers-reduced-motion` with animations
- Add `:focus-visible` styles for keyboard navigation

## Project Notes

Add project-specific notes here...
