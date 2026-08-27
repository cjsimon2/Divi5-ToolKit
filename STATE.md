# STATE.md — Project State Snapshot

## Version

- **Current:** 2.4.0 (released 2026-08-26)
- **Target Divi version:** 5.11 (August 15, 2026; weekly release cadence). Adds on top of 5.6: Gradient Variables + gradient/image text fills + text-stroke (5.7), Workspaces + Tooltip module (5.8), Variable Fonts + new typography controls + CSS Grid Editor (5.9), Post Filter + Post Filter Item modules + native lazy loading (5.10), Charts + Gravity Forms + Imagely Gallery + Payment Button modules + flexbox `alignItems` classes (5.11). Carries forward 5.6-era knowledge: Timeline/Breadcrumbs/SVG/TOC/Instagram Feed modules, Aspect Ratio / Framing, Variable Generators, pseudo-class editing, Contact Form 7 Styler, Nested Option Presets, Composable Settings, Canvas system, Loop Builder, Interaction Builder.

## Plugin Components

### Commands (8)
- `/divi5-toolkit:generate` — generate Divi 5-ready CSS in four formats
- `/divi5-toolkit:validate` — validate CSS for Divi 5 compatibility
- `/divi5-toolkit:convert` — convert Divi 4 CSS patterns to Divi 5
- `/divi5-toolkit:diagnose` — diagnose a symptom/error and return root cause + fix (NEW v2.2.0)
- `/divi5-toolkit:research` — refresh Divi 5 knowledge base
- `/divi5-toolkit:scaffold` — generate complete page section templates
- `/divi5-toolkit:audit` — whole-project CSS audit with A–F scoring
- `/divi5-toolkit:responsive` — device-matrix check across 9 viewports (360px–2560px); live browser testing via Chrome DevTools/Playwright MCP or static CSS risk analysis (NEW v2.3.0)

### Agents (5)
- `divi5-validator` — CSS compatibility checker (PostToolUse hook)
- `divi5-error-learner` — analyzes Divi error messages and records patterns
- `divi5-researcher` — refreshes knowledge base from upstream sources
- `divi5-accessibility` — WCAG 2.1 AA checker for interactive styles
- `divi5-performance` — Core Web Vitals auditor (LCP, INP, CLS, render-blocking CSS, font/image loading, cache plugin compatibility) (NEW v2.2.0)

### Skills (3)
- `divi5-css-patterns`
  - `examples/` — 10 CSS files: button-variants, design-tokens, animations, dark-mode, woocommerce, accessibility, responsive-7-breakpoints, loop-builder, forms, new-modules (extended in v2.4.0 with Tooltip / Post Filter / Gravity Forms / Charts / Payment Button sections)
  - `references/` — divi-selectors.md (5.8–5.11 module selector table added in v2.4.0), responsive-breakpoints-2025.md
- `divi5-compatibility`
  - `references/unit-conversions.md` — CSS unit conversion reference
- `divi5-performance` (NEW v2.2.0)
  - `examples/` — critical-css.css, font-loading.css
  - `references/core-web-vitals.md` — full LCP/INP/CLS reference with Divi-specific causes

### CSS Examples (12)
button-variants.css, design-tokens.css, animations.css, dark-mode.css, woocommerce.css, accessibility.css, responsive-7-breakpoints.css, loop-builder.css (NEW), forms.css (NEW), new-modules.css (NEW), critical-css.css (NEW — in performance skill), font-loading.css (NEW — in performance skill)

### Hooks (2 files, 1 event handler)
`hooks/hooks.json` — PostToolUse on Write/Edit, dispatches to `hooks/css-validate.sh`. The shell script (added in v2.1.7, made cross-platform in v2.2.2) deterministically filters by file extension and exits silently for anything that isn't a `.css`/`.scss`/`.sass`/`.less` file in a project that has `auto_validate: true`. v2.2.2 removed the hard `python3` dependency (extraction falls back jq → python3/python/py → sed), normalized Windows backslash paths so the config walk works, and pinned `*.sh` to LF via `.gitattributes`; the script never exits non-zero. The earlier `prompt`-type implementation was replaced because LLM-backed hooks narrated their decisions instead of staying silent, blocking non-CSS edits. The SessionStart hook was removed in v2.1.6 because Claude Code's `prompt`-type hooks require a `ToolUseContext`, which doesn't exist at session start.

### Templates (1)
`templates/divi5-toolkit.local.md` — user configuration template

## Knowledge Base Topics

- Divi 5 architecture (React 18, no Shadow DOM, JSON block storage, Dynamic CSS, Critical CSS, Inline Stylesheets)
- CSS integration methods (Theme Options, Page-Level, Free-Form, Element fields, Code Module, Custom HTML Wrappers, Semantic Elements, Child Theme, Attributes Panel)
- Module library (40+ built-in modules, 20+ D5-native modules, 17+ WooCommerce modules, Contact Form 7 Styler from 5.3, 5.6 modules: Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed; Tooltip from 5.8; Post Filter + Post Filter Item from 5.10; Charts, Gravity Forms, Imagely Gallery, Payment Button from 5.11)
- Canvas system (Main, Local, Global, Canvas Portal, Interaction Builder)
- Design system (7 Design Variable types including Gradients from 5.7, 4-tier Preset hierarchy + Nested Option Presets from 5.3, Composable Settings, Variable Generators from 5.4–5.6)
- Pseudo-class editing in builder (`:checked`, `:focus`, `:active`) from 5.3
- Aspect Ratio + Framing settings (5.5) for CLS prevention
- Gradient system + text effects (5.7): gradient picker overhaul, gradient/image text fills, text-stroke
- Variable Fonts + advanced typography (5.9): drop caps, text columns, hyphenation, text direction
- CSS Grid Editor (5.9): visual grid layouts with start/end/span offsets and number variables
- Loop Filters (5.10): Post Filter modules with bookmarkable URL parameters
- Flexbox `alignItems` CSS classes on Column/Section/Row/Group (5.11)
- Responsive breakpoints (7 total, 3 active by default; 5.10 corrected VB fluid preview sizing)
- Accessibility patterns (focus, reduced motion, ARIA, semantic elements, WCAG 2.1 AA)
- Performance optimization (Critical CSS, Dynamic CSS pipeline, local font loading with metric overrides + variable fonts from 5.9, native row-granular lazy loading + deferred local videos from 5.10, lazy-loading background images, cache plugin compatibility matrix, Core Web Vitals)
- Troubleshooting (cache plugins, security plugins, WooCommerce incl. the 11.0 Shop fix in 5.11, Divi 4→5 migration, Divi 5.2 through 5.11 bug fix history)

## Recent Changes

See the **Changelog** in `README.md`. v2.4.0 (2026-08-26) catches the plugin up to **Divi 5.11** (August 15, 2026) from v2.2.x/v2.3.0 targeting Divi 5.6. Five minor Divi releases shipped on the new weekly cadence: Gradient Variables + gradient/image text fills + text-stroke (5.7, June 10), Workspaces + Tooltip module (5.8, June 20), Variable Fonts + new typography controls + visual CSS Grid Editor (5.9, July 13), Post Filter + Post Filter Item modules + native row-granular lazy loading + deferred local videos (5.10, August 11), and Charts + Gravity Forms + Imagely Gallery + Payment Button modules + flexbox `alignItems` classes (5.11, August 15). The release refreshes both core SKILL.md files (css-patterns adds a 5.7–5.11 section with builder-first guidance; compatibility extends the Composable Settings table with 9 new rows and the bug-fix history through 5.11 — including the 5.8 CSS-linter false-positive fix, the 5.8/5.9 cache-related style-loss fixes, and the 5.11 WooCommerce 11.0 Shop fix), updates the performance skill (5.10 native lazy loading, 5.9 variable fonts), extends `new-modules.css` with Tooltip / Post Filter / Gravity Forms / Charts / Payment Button sections, adds a 5.8–5.11 selector table to `divi-selectors.md`, adds 4 troubleshooting entries, and bumps every agent/command/template reference from 5.6 to 5.11 (`divi_version` default `"5.11"`, `last_research` `2026-08-26`). No new commands, agents, or skills; no breaking changes. v2.3.0 (2026-06-12) adds the `/divi5-toolkit:responsive` command: a responsive device check that verifies a page at 9 real viewport sizes (small Android 360×800 through ultrawide 2560×1440, mapped to Divi's breakpoint zones). Live mode drives a browser MCP server (Chrome DevTools MCP or Playwright MCP) — resize, screenshot, in-page horizontal-overflow probe, navigation/touch-target/legibility checks, and 1px-either-side breakpoint boundary spot-checks. Static mode (no browser server) scans CSS for 13 risk patterns (S1–S13: misaligned media queries, unguarded fixed widths, 100vw/100vh traps, vw-only font sizes, absolute-position offsets, missing overflow handling, touch-target padding, etc.). Reads `active_breakpoints`, `divi_version`, `accessibility_level`, `css_prefix`; resolves customized vs. default Divi breakpoint widths before judging media-query alignment. Cross-wired: `/diagnose` routes size-specific symptoms to it, `/audit` offers it when Category C scores poorly, `/validate` and `/scaffold` suggest it as follow-up; documented in README, usage.md, and a new workflows.md walkthrough; README config "Read by" table corrected (also now lists `/diagnose` and `divi5-performance` consumers). v2.2.2 (2026-06-12) is a bug-fix release from a full-plugin audit: cross-platform rewrite of the PostToolUse hook (no `python3` hard dependency, Windows path handling, LF-pinned via `.gitattributes`, quoted `${CLAUDE_PLUGIN_ROOT}`); resolution of the breakpoint contradiction between the css-patterns skill / 2025 reference (recommended custom widths) and the compatibility skill / selector reference (Divi defaults 767/860/980/1024/1280/2560) — defaults now lead, recommendations clearly labeled; corrected WCAG target-size citations in 5 files (44px = 2.1 SC 2.5.5 AAA, not 2.5.8; 2.2 SC 2.5.8 AA = 24px floor); command fixes (`/scaffold` no-op clamp, `/diagnose` ToolUseContext leftover, `/validate` + validator lookahead regexes Grep can't run, `/convert` conversion ordering, `/audit` scoring made per-category coherent); `/generate` now actually reads `default_format`/`css_prefix`/`divi_version`/`active_breakpoints`; stale `templates/` copy paths and the pre-v2.1.5 `--plugin-dir` path fixed across README/docs/CLAUDE.md. v2.2.1 is a content-only doc catch-up after v2.2.0 — a parallel three-agent doc sweep updated `CLAUDE.md` (stale 5.2 ref + missing divi5-performance entry in the skills diagram), `docs/troubleshooting.md` (5 new entries for Loop Builder, 5.6 modules, Contact Form 7 Styler, Core Web Vitals), and 9 older agent/command files plus the divi-selectors reference and two older CSS example headers, all of which still referenced Divi 5.2 as current or lacked cross-references to the new /diagnose command and divi5-performance agent shipped in v2.2.0. No new features, no breaking changes, plugin.json validates. v2.2.0 catches the plugin up to **Divi 5.6** (May 25, 2026) from the previous v2.1.x targeting Divi 5.2. Four minor Divi releases shipped in 6 weeks (5.3 → 5.6), introducing the Contact Form 7 Styler + pseudo-class editing (5.3), Sizing/Colorscheme Variable Generators (5.4), Aspect Ratio + Framing + SVG sanitization (5.5), and 5 new modules (Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed) plus Color Scale + Harmony Generators (5.6). The release adds a `divi5-performance` skill (Critical CSS, Dynamic CSS pipeline, local font loading with `size-adjust`/`ascent-override` for CLS prevention, lazy-loading background images, cache plugin compatibility) with a Core Web Vitals reference doc; a `divi5-performance` agent for performance auditing; a `/divi5-toolkit:diagnose` command that routes symptoms/errors to the right specialist agent; and 3 new CSS examples (`loop-builder.css`, `forms.css` covering 5.3 pseudo-class editing, `new-modules.css` covering the 5 new 5.6 modules). Both existing SKILL.md files are refreshed: the css-patterns skill documents 5.3–5.6 additions and routes users to Composable Settings / pseudo-class editing / Aspect Ratio before reaching for custom CSS; the compatibility skill's "Composable Settings Compatibility" table grows to include 5.3–5.5 builder-native equivalents, and a per-version "Known Divi 5.x CSS Bug Fixes" section spans 5.2 through 5.6. `templates/divi5-toolkit.local.md` default `divi_version` bumped from `"5.2"` to `"5.6"`; `last_research` bumped to `2026-05-27`. v2.1.7 replaced the `PostToolUse` Write/Edit hook implementation: it was a `prompt`-type hook that asked an LLM to stay silent for non-CSS edits, but the LLM kept narrating its decision and surfacing it as a blocking message on every Edit across every project. The new implementation is a deterministic shell script (`hooks/css-validate.sh`) that filters by file extension and only fires when the file is genuinely a stylesheet AND the project's `auto_validate` flag is on. v2.1.6 removed the `SessionStart` hook entry from `hooks/hooks.json` because Claude Code's `prompt`-type hooks require a `ToolUseContext`, which doesn't exist before any tool has run. The hook was firing a "ToolUseContext is required for prompt hooks" error every time a session started in a project that had the plugin enabled. The freshness reminder it provided is now documented in `docs/workflows.md` instead. v2.1.5 restructured the repo so the plugin lives in `plugins/divi5-toolkit/` (a subdirectory of the marketplace root). v2.1.4 attempted to put the plugin at the marketplace root with `source: "./"` but Claude Code rejected it because the two `.claude-plugin/` manifests cannot coexist in the same directory. v2.1.5 also fixed schema errors caught by `claude plugin validate` (removed top-level `$schema`, moved `description` into `metadata`). The marketplace now passes validation. Per-session `--plugin-dir` users must point at `<repo>/plugins/divi5-toolkit` instead of the repo root; marketplace-based loading via `extraKnownMarketplaces` is unchanged. v2.1.2 added end-user documentation in `docs/`. v2.1.1 wired three orphan config keys into the consuming commands and agent, added `CLAUDE.md` and `STATE.md`. v2.1.0 added `/scaffold` and `/audit` commands, the `divi5-accessibility` agent, four new CSS example files, and full Divi 5.2 support.

## Research

- **Last research:** 2026-08-26 (matches template default in `templates/divi5-toolkit.local.md`). Knowledge base verified against Divi 5.7 / 5.8 / 5.9 / 5.10 / 5.11 release notes on elegantthemes.com. Note: 5.9's release notes live at `/blog/divi-resources/divi-5-9` (no `-release-notes` suffix, unlike the other versions).
- **Freshness policy:** Run `/divi5-toolkit:research` if `last_research` in `.claude/divi5-toolkit.local.md` is more than 7 days old. (Previously surfaced via a SessionStart hook; removed in v2.1.6 due to a Claude Code constraint on `prompt`-type hooks.)

## Roadmap / Open Questions

This is an evolving plugin. Divi continues to update — future work is driven by upstream changes rather than a fixed roadmap. Ongoing responsibilities:

- Track Divi 5.x releases and refresh selector/module knowledge.
- Watch for new Composable Settings options that could replace CSS patterns.
- Keep the error-learner pattern library in sync with real-world failures users report.
- Revisit cache-plugin and security-plugin interactions as those ecosystems update.
