# STATE.md — Project State Snapshot

## Version

- **Current:** 2.1.7 (released 2026-04-13)
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

### Hooks (2 files, 1 event handler)
`hooks/hooks.json` — PostToolUse on Write/Edit, dispatches to `hooks/css-validate.sh`. The shell script (added in v2.1.7) deterministically filters by file extension and exits silently for anything that isn't a `.css`/`.scss`/`.sass`/`.less` file in a project that has `auto_validate: true`. The earlier `prompt`-type implementation was replaced because LLM-backed hooks narrated their decisions instead of staying silent, blocking non-CSS edits. The SessionStart hook was removed in v2.1.6 because Claude Code's `prompt`-type hooks require a `ToolUseContext`, which doesn't exist at session start.

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

See the **Changelog** in `README.md`. v2.1.7 replaced the `PostToolUse` Write/Edit hook implementation: it was a `prompt`-type hook that asked an LLM to stay silent for non-CSS edits, but the LLM kept narrating its decision and surfacing it as a blocking message on every Edit across every project. The new implementation is a deterministic shell script (`hooks/css-validate.sh`) that filters by file extension and only fires when the file is genuinely a stylesheet AND the project's `auto_validate` flag is on. v2.1.6 removed the `SessionStart` hook entry from `hooks/hooks.json` because Claude Code's `prompt`-type hooks require a `ToolUseContext`, which doesn't exist before any tool has run. The hook was firing a "ToolUseContext is required for prompt hooks" error every time a session started in a project that had the plugin enabled. The freshness reminder it provided is now documented in `docs/workflows.md` instead. v2.1.5 restructured the repo so the plugin lives in `plugins/divi5-toolkit/` (a subdirectory of the marketplace root). v2.1.4 attempted to put the plugin at the marketplace root with `source: "./"` but Claude Code rejected it because the two `.claude-plugin/` manifests cannot coexist in the same directory. v2.1.5 also fixed schema errors caught by `claude plugin validate` (removed top-level `$schema`, moved `description` into `metadata`). The marketplace now passes validation. Per-session `--plugin-dir` users must point at `<repo>/plugins/divi5-toolkit` instead of the repo root; marketplace-based loading via `extraKnownMarketplaces` is unchanged. v2.1.2 added end-user documentation in `docs/`. v2.1.1 wired three orphan config keys into the consuming commands and agent, added `CLAUDE.md` and `STATE.md`. v2.1.0 added `/scaffold` and `/audit` commands, the `divi5-accessibility` agent, four new CSS example files, and full Divi 5.2 support.

## Research

- **Last research:** 2026-04-12 (matches template default in `templates/divi5-toolkit.local.md`)
- **Freshness policy:** Run `/divi5-toolkit:research` if `last_research` in `.claude/divi5-toolkit.local.md` is more than 7 days old. (Previously surfaced via a SessionStart hook; removed in v2.1.6 due to a Claude Code constraint on `prompt`-type hooks.)

## Roadmap / Open Questions

This is an evolving plugin. Divi continues to update — future work is driven by upstream changes rather than a fixed roadmap. Ongoing responsibilities:

- Track Divi 5.x releases and refresh selector/module knowledge.
- Watch for new Composable Settings options that could replace CSS patterns.
- Keep the error-learner pattern library in sync with real-world failures users report.
- Revisit cache-plugin and security-plugin interactions as those ecosystems update.
