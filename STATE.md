# STATE.md — Project State Snapshot

## Version

- **Current:** 2.2.0 (released 2026-05-27)
- **Target Divi version:** 5.6 (5 new modules — Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed — plus Aspect Ratio / Framing on images, Sizing Variable Generator, Relative Colorscheme Generator, Color Scale Generator, Color Harmony Generator, pseudo-class editing (`:checked`/`:focus`/`:active`), Contact Form 7 Styler, Nested Option Presets, Composable Settings, Canvas system, Loop Builder, Interaction Builder)

## Plugin Components

### Commands (7)
- `/divi5-toolkit:generate` — generate Divi 5-ready CSS in four formats
- `/divi5-toolkit:validate` — validate CSS for Divi 5 compatibility
- `/divi5-toolkit:convert` — convert Divi 4 CSS patterns to Divi 5
- `/divi5-toolkit:diagnose` — diagnose a symptom/error and return root cause + fix (NEW v2.2.0)
- `/divi5-toolkit:research` — refresh Divi 5 knowledge base
- `/divi5-toolkit:scaffold` — generate complete page section templates
- `/divi5-toolkit:audit` — whole-project CSS audit with A–F scoring

### Agents (5)
- `divi5-validator` — CSS compatibility checker (PostToolUse hook)
- `divi5-error-learner` — analyzes Divi error messages and records patterns
- `divi5-researcher` — refreshes knowledge base from upstream sources
- `divi5-accessibility` — WCAG 2.1 AA checker for interactive styles
- `divi5-performance` — Core Web Vitals auditor (LCP, INP, CLS, render-blocking CSS, font/image loading, cache plugin compatibility) (NEW v2.2.0)

### Skills (3)
- `divi5-css-patterns`
  - `examples/` — 10 CSS files: button-variants, design-tokens, animations, dark-mode, woocommerce, accessibility, responsive-7-breakpoints, loop-builder (NEW), forms (NEW), new-modules (NEW)
  - `references/` — divi-selectors.md, responsive-breakpoints-2025.md
- `divi5-compatibility`
  - `references/unit-conversions.md` — CSS unit conversion reference
- `divi5-performance` (NEW v2.2.0)
  - `examples/` — critical-css.css, font-loading.css
  - `references/core-web-vitals.md` — full LCP/INP/CLS reference with Divi-specific causes

### CSS Examples (12)
button-variants.css, design-tokens.css, animations.css, dark-mode.css, woocommerce.css, accessibility.css, responsive-7-breakpoints.css, loop-builder.css (NEW), forms.css (NEW), new-modules.css (NEW), critical-css.css (NEW — in performance skill), font-loading.css (NEW — in performance skill)

### Hooks (2 files, 1 event handler)
`hooks/hooks.json` — PostToolUse on Write/Edit, dispatches to `hooks/css-validate.sh`. The shell script (added in v2.1.7) deterministically filters by file extension and exits silently for anything that isn't a `.css`/`.scss`/`.sass`/`.less` file in a project that has `auto_validate: true`. The earlier `prompt`-type implementation was replaced because LLM-backed hooks narrated their decisions instead of staying silent, blocking non-CSS edits. The SessionStart hook was removed in v2.1.6 because Claude Code's `prompt`-type hooks require a `ToolUseContext`, which doesn't exist at session start.

### Templates (1)
`templates/divi5-toolkit.local.md` — user configuration template

## Knowledge Base Topics

- Divi 5 architecture (React 18, no Shadow DOM, JSON block storage, Dynamic CSS, Critical CSS, Inline Stylesheets)
- CSS integration methods (Theme Options, Page-Level, Free-Form, Element fields, Code Module, Custom HTML Wrappers, Semantic Elements, Child Theme, Attributes Panel)
- Module library (40+ built-in modules, 8 new D5 modules, 17+ WooCommerce modules, Contact Form 7 Styler from 5.3, 5 new 5.6 modules: Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed)
- Canvas system (Main, Local, Global, Canvas Portal, Interaction Builder)
- Design system (6 Design Variable types, 4-tier Preset hierarchy + Nested Option Presets from 5.3, Composable Settings, Variable Generators from 5.4–5.6)
- Pseudo-class editing in builder (`:checked`, `:focus`, `:active`) from 5.3
- Aspect Ratio + Framing settings (5.5) for CLS prevention
- Responsive breakpoints (7 total, 3 active by default)
- Accessibility patterns (focus, reduced motion, ARIA, semantic elements, WCAG 2.1 AA)
- Performance optimization (Critical CSS, Dynamic CSS pipeline, local font loading with metric overrides, lazy-loading background images, cache plugin compatibility matrix, Core Web Vitals)
- Troubleshooting (cache plugins, security plugins, WooCommerce, Divi 4→5 migration, Divi 5.2 / 5.3 / 5.5 / 5.6 bug fix history)

## Recent Changes

See the **Changelog** in `README.md`. v2.2.0 catches the plugin up to **Divi 5.6** (May 25, 2026) from the previous v2.1.x targeting Divi 5.2. Four minor Divi releases shipped in 6 weeks (5.3 → 5.6), introducing the Contact Form 7 Styler + pseudo-class editing (5.3), Sizing/Colorscheme Variable Generators (5.4), Aspect Ratio + Framing + SVG sanitization (5.5), and 5 new modules (Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed) plus Color Scale + Harmony Generators (5.6). The release adds a `divi5-performance` skill (Critical CSS, Dynamic CSS pipeline, local font loading with `size-adjust`/`ascent-override` for CLS prevention, lazy-loading background images, cache plugin compatibility) with a Core Web Vitals reference doc; a `divi5-performance` agent for performance auditing; a `/divi5-toolkit:diagnose` command that routes symptoms/errors to the right specialist agent; and 3 new CSS examples (`loop-builder.css`, `forms.css` covering 5.3 pseudo-class editing, `new-modules.css` covering the 5 new 5.6 modules). Both existing SKILL.md files are refreshed: the css-patterns skill documents 5.3–5.6 additions and routes users to Composable Settings / pseudo-class editing / Aspect Ratio before reaching for custom CSS; the compatibility skill's "Composable Settings Compatibility" table grows to include 5.3–5.5 builder-native equivalents, and a per-version "Known Divi 5.x CSS Bug Fixes" section spans 5.2 through 5.6. `templates/divi5-toolkit.local.md` default `divi_version` bumped from `"5.2"` to `"5.6"`; `last_research` bumped to `2026-05-27`. v2.1.7 replaced the `PostToolUse` Write/Edit hook implementation: it was a `prompt`-type hook that asked an LLM to stay silent for non-CSS edits, but the LLM kept narrating its decision and surfacing it as a blocking message on every Edit across every project. The new implementation is a deterministic shell script (`hooks/css-validate.sh`) that filters by file extension and only fires when the file is genuinely a stylesheet AND the project's `auto_validate` flag is on. v2.1.6 removed the `SessionStart` hook entry from `hooks/hooks.json` because Claude Code's `prompt`-type hooks require a `ToolUseContext`, which doesn't exist before any tool has run. The hook was firing a "ToolUseContext is required for prompt hooks" error every time a session started in a project that had the plugin enabled. The freshness reminder it provided is now documented in `docs/workflows.md` instead. v2.1.5 restructured the repo so the plugin lives in `plugins/divi5-toolkit/` (a subdirectory of the marketplace root). v2.1.4 attempted to put the plugin at the marketplace root with `source: "./"` but Claude Code rejected it because the two `.claude-plugin/` manifests cannot coexist in the same directory. v2.1.5 also fixed schema errors caught by `claude plugin validate` (removed top-level `$schema`, moved `description` into `metadata`). The marketplace now passes validation. Per-session `--plugin-dir` users must point at `<repo>/plugins/divi5-toolkit` instead of the repo root; marketplace-based loading via `extraKnownMarketplaces` is unchanged. v2.1.2 added end-user documentation in `docs/`. v2.1.1 wired three orphan config keys into the consuming commands and agent, added `CLAUDE.md` and `STATE.md`. v2.1.0 added `/scaffold` and `/audit` commands, the `divi5-accessibility` agent, four new CSS example files, and full Divi 5.2 support.

## Research

- **Last research:** 2026-05-27 (matches template default in `templates/divi5-toolkit.local.md`). Knowledge base verified against Divi 5.3 / 5.4 / 5.5 / 5.6 release notes and Core Web Vitals 2026 guidance.
- **Freshness policy:** Run `/divi5-toolkit:research` if `last_research` in `.claude/divi5-toolkit.local.md` is more than 7 days old. (Previously surfaced via a SessionStart hook; removed in v2.1.6 due to a Claude Code constraint on `prompt`-type hooks.)

## Roadmap / Open Questions

This is an evolving plugin. Divi continues to update — future work is driven by upstream changes rather than a fixed roadmap. Ongoing responsibilities:

- Track Divi 5.x releases and refresh selector/module knowledge.
- Watch for new Composable Settings options that could replace CSS patterns.
- Keep the error-learner pattern library in sync with real-world failures users report.
- Revisit cache-plugin and security-plugin interactions as those ecosystems update.
