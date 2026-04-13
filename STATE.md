# STATE.md — Project State Snapshot

## Version

- **Current:** 2.1.2 (released 2026-04-12)
- **Target Divi version:** 5.2 (Composable Settings, Canvas system, Loop Builder, Interaction Builder)

## Plugin Components

### Commands (6)
- `/divi5-toolkit:generate` — generate Divi 5-ready CSS in four formats
- `/divi5-toolkit:validate` — validate CSS for Divi 5 compatibility
- `/divi5-toolkit:convert` — convert Divi 4 CSS patterns to Divi 5
- `/divi5-toolkit:research` — refresh Divi 5 knowledge base
- `/divi5-toolkit:scaffold` — generate complete page section templates
- `/divi5-toolkit:audit` — whole-project CSS audit with A–F scoring

### Agents (4)
- `divi5-validator` — CSS compatibility checker (PostToolUse hook)
- `divi5-error-learner` — analyzes Divi error messages and records patterns
- `divi5-researcher` — refreshes knowledge base from upstream sources
- `divi5-accessibility` — WCAG 2.1 AA checker for interactive styles

### Skills (2)
- `divi5-css-patterns`
  - `examples/` — 6 CSS files: button-variants, design-tokens, animations, dark-mode, woocommerce, accessibility
  - `references/divi-selectors.md` — selector reference
- `divi5-compatibility`
  - `references/unit-conversions.md` — CSS unit conversion reference

### CSS Examples (6)
button-variants.css, design-tokens.css, animations.css, dark-mode.css, woocommerce.css, accessibility.css

### Hooks (1 file, 2 event handlers)
`hooks/hooks.json` — PostToolUse (auto-validate CSS on Write/Edit) and SessionStart (research freshness and divi_version checks)

### Templates (1)
`templates/divi5-toolkit.local.md` — user configuration template

## Knowledge Base Topics

- Divi 5 architecture (React 18, no Shadow DOM, JSON block storage, Dynamic CSS, Critical CSS)
- CSS integration methods (Theme Options, Page-Level, Free-Form, Element fields, Code Module, Custom HTML Wrappers, Semantic Elements, Child Theme, Attributes Panel)
- Module library (40+ built-in modules, 8 new D5 modules, 17+ WooCommerce modules)
- Canvas system (Main, Local, Global, Canvas Portal, Interaction Builder)
- Design system (6 Design Variable types, 4-tier Preset hierarchy, Composable Settings)
- Responsive breakpoints (7 total, 3 active by default)
- Accessibility patterns (focus, reduced motion, ARIA, semantic elements, WCAG 2.1 AA)
- Troubleshooting (cache plugins, security plugins, WooCommerce, Divi 4→5 migration, Divi 5.2 bug fixes)

## Recent Changes

See the **Changelog** in `README.md`. v2.1.2 added end-user documentation in `docs/`: `usage.md`, `configuration.md`, `workflows.md`, and `troubleshooting.md`, plus README Quickstart and Documentation sections. v2.1.1 wired three orphan config keys (`accessibility_level`, `flag_composable_alternatives`, `scaffold_style`) into the consuming commands and agent, added `CLAUDE.md` and `STATE.md`, and ran a cross-reference / CSS-header consistency sweep. v2.1.0 added `/scaffold` and `/audit` commands, the `divi5-accessibility` agent, four new CSS example files, and full Divi 5.2 support.

## Research

- **Last research:** 2026-04-12 (matches template default in `templates/divi5-toolkit.local.md`)
- **Freshness policy:** SessionStart hook warns users when `last_research` is more than 7 days old.

## Roadmap / Open Questions

This is an evolving plugin. Divi continues to update — future work is driven by upstream changes rather than a fixed roadmap. Ongoing responsibilities:

- Track Divi 5.x releases and refresh selector/module knowledge.
- Watch for new Composable Settings options that could replace CSS patterns.
- Keep the error-learner pattern library in sync with real-world failures users report.
- Revisit cache-plugin and security-plugin interactions as those ecosystems update.
