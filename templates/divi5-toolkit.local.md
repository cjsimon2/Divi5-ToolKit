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
last_research: 2026-03-18

# Divi Version
# Track which Divi version this project targets
divi_version: "5.1"

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

### CSS Integration Methods (Divi 5)
1. **Theme Options** — Divi > Theme Options > Custom CSS (global, no tags)
2. **Page-Level CSS** — Page Settings > Advanced > Custom CSS
3. **Free-Form CSS** — Module > Advanced > Custom CSS > Free-Form (uses `selector` keyword)
4. **Module Elements** — Module > Advanced > Custom CSS > Title/Body/etc. (properties only)
5. **Code Module** — Add Code Module, wrap in `<style>` tags
6. **Custom HTML Wrappers** — Module > Advanced > HTML > Before/After
7. **Child Theme** — child-theme/style.css

### Adding Classes in Divi 5
Go to **Advanced > Attributes** (not the old CSS ID & Classes field).

### Key Patterns
- Button overrides: `body .et_pb_button { ... !important; }`
- Use custom classes, not numbered selectors (`.et_pb_text_0`)
- CSS variables in `:root` for global scope
- Use `clamp()` for fluid responsive values

## Project Notes

Add project-specific notes here...
