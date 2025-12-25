---
# Divi5 Toolkit Configuration
# Copy this file to .claude/divi5-toolkit.local.md in your project

# Validation Mode
# - advisory: Report issues as warnings, allow proceeding
# - strict: Report issues as errors, block incompatible CSS
validation_mode: advisory

# Default Output Format
# - theme-options: Global CSS for Divi → Theme Options (no tags)
# - code-module: Page-specific CSS with <style> tags
# - child-theme: Standard CSS file for child theme
default_format: theme-options

# Auto-Validate CSS
# When true, automatically validates CSS files after Write/Edit
auto_validate: true

# Last Research Date
# Auto-updated by divi5-researcher agent
last_research: 2024-12-25

# Project Design Tokens (optional)
# Define your project's CSS variable prefix
css_prefix: cjs

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
- `/divi5-toolkit:generate` - Generate Divi 5-ready CSS
- `/divi5-toolkit:validate` - Validate CSS compatibility
- `/divi5-toolkit:convert` - Convert CSS to Divi 5 format
- `/divi5-toolkit:research` - Research latest Divi 5 updates

### Design Tokens
Your project uses the `--cjs-*` prefix for CSS variables.

### Validation Rules
- No `ch` or `ex` units (use `rem`)
- Button overrides need `body` prefix and `!important`
- CSS variables must be in `:root`

## Project Notes

Add project-specific notes here...
