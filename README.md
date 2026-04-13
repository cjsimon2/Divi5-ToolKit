# Divi5 Toolkit

The first Claude Code plugin for Divi 5 development. Validates CSS compatibility, generates Divi-ready code, scaffolds page sections, audits project health, checks accessibility, learns from errors, and stays current with Divi 5 updates — all powered by Claude instead of GPT-3.5.

**For Divi 5.2+** (Composable Settings, Canvas system, Loop Builder)

## Why This Exists

Divi AI uses GPT-3.5 and only works inside the Visual Builder. This plugin gives you Claude's superior code generation with deep Divi 5 knowledge — from your terminal, editor, or CI/CD pipeline. It knows Divi's selectors, specificity rules, breakpoints, Design Variables, Free-Form CSS, Composable Settings, Canvas system, and the full module library so you don't have to provide that context manually.

## Features

- **CSS Generation**: Divi 5-ready CSS in four formats (Theme Options, Code Module, Child Theme, Free-Form CSS)
- **Section Scaffolding**: Complete page section templates (hero, pricing, FAQ, etc.) with CSS, responsive design, and accessibility baked in
- **Compatibility Validation**: Checks button specificity, numbered selectors, `!important` usage, CSS variable scope, format correctness, accessibility
- **Project Audit**: Whole-project CSS health scoring with graded report and prioritized fix list
- **Accessibility Checking**: WCAG 2.1 AA compliance — focus indicators, color contrast, reduced motion, touch targets
- **Divi 5 Knowledge Base**: Complete selector reference, 8 new D5 modules, Design Variable system, Preset hierarchy, responsive breakpoints, Composable Settings, Canvas system, Loop Builder
- **Error Learning**: Paste Divi errors — the plugin analyzes, fixes, and remembers the pattern
- **Self-Updating**: Researches Divi 5 updates weekly and updates its own knowledge base
- **Migration Support**: Converts Divi 4 CSS patterns for Divi 5 compatibility
- **CSS Examples**: Animation patterns, dark mode, WooCommerce, accessibility fixes, design tokens, button variants

## Quickstart

Already have the plugin loaded? (See [Installation](#installation) if not.)

```bash
# 1. From your project root, copy the config template
mkdir -p .claude
cp /path/to/Divi5-ToolKit/templates/divi5-toolkit.local.md .claude/divi5-toolkit.local.md
```

Edit `.claude/divi5-toolkit.local.md` and set `css_prefix` to your project's class prefix (e.g., `acme`). Leave the other defaults alone.

In Claude Code, type `/divi5-toolkit:` — autocomplete should show all 6 commands. Try one:

```
/divi5-toolkit:generate primary button with gold hover state
```

You should get back Divi 5-ready CSS with `body` prefix, `!important`, your custom prefix, and paste instructions. That's it — you're up and running.

**Next steps:**
- [`docs/workflows.md`](docs/workflows.md) — Build a full landing page, migrate from Divi 4, audit a project, add dark mode, etc.
- [`docs/usage.md`](docs/usage.md) — What every command, agent, and skill does in detail
- [`docs/configuration.md`](docs/configuration.md) — Tune the plugin for your project type

## Commands

| Command | Description |
|---------|-------------|
| `/divi5-toolkit:generate` | Generate Divi 5-ready CSS for any component |
| `/divi5-toolkit:validate` | Validate CSS for Divi 5 compatibility |
| `/divi5-toolkit:convert` | Convert existing CSS to Divi 5 format |
| `/divi5-toolkit:research` | Research latest Divi 5 updates |
| `/divi5-toolkit:scaffold` | Generate complete page section templates |
| `/divi5-toolkit:audit` | Run a full project CSS audit with scoring |

## Agents

| Agent | Triggers When |
|-------|---------------|
| `divi5-validator` | After writing/editing CSS files (via PostToolUse hook, if `auto_validate: true`) |
| `divi5-error-learner` | When you paste Divi error messages or describe CSS issues |
| `divi5-researcher` | On-demand via `/divi5-toolkit:research` or when unknown Divi errors need research |
| `divi5-accessibility` | When reviewing CSS for accessibility, or when writing interactive element styles |

## Skills

| Skill | Activates When |
|-------|----------------|
| `divi5-css-patterns` | Writing CSS for Divi, styling Divi modules |
| `divi5-compatibility` | Validating CSS, troubleshooting Divi issues |

## Documentation

The tables above are quick references. For depth, see the `docs/` directory:

| Doc | What's Inside |
|---|---|
| [**`docs/usage.md`**](docs/usage.md) | Detailed reference: every command (purpose, args, example, output), every agent (triggers, behavior, output), every skill (when it activates, what it provides), every CSS example, every hook |
| [**`docs/configuration.md`**](docs/configuration.md) | Every config setting explained, with rationale and recommended values for solo dev, agency, government, WooCommerce, prototype, and legacy project types |
| [**`docs/workflows.md`**](docs/workflows.md) | Step-by-step guides: first-time setup, build a landing page, migrate from Divi 4, audit an inherited project, add dark mode, build a WooCommerce grid, off-canvas menu, accessibility compliance, debug "styles not applying", refresh knowledge base |
| [**`docs/troubleshooting.md`**](docs/troubleshooting.md) | FAQ + diagnostic steps for plugin issues, Divi CSS issues, builder issues, plugin conflicts, migration issues, performance, and accessibility |

Internal docs:
- [`CLAUDE.md`](CLAUDE.md) — Developer guidance for working ON the plugin (architecture, conventions, contributing)
- [`STATE.md`](STATE.md) — Project state snapshot (current version, component inventory, knowledge topics)

## What the Plugin Knows

### Divi 5 Architecture
- React 18-based, no Shadow DOM — standard DOM with `et_pb_*` classes
- JSON block storage (no shortcodes)
- Dynamic CSS (94% smaller stylesheets)
- Critical CSS (eliminates render-blocking requests)
- Composable Settings (5.2) — toggle any design option on any sub-element

### CSS Integration Methods
1. Theme Options (global, no tags)
2. Page-Level CSS
3. **Free-Form CSS** with `selector` keyword (new in D5)
4. Module Element fields (properties only)
5. Code Module (with `<style>` tags)
6. **Custom HTML Wrappers** (new in D5)
7. **Semantic Elements** (new in D5)
8. Child Theme
9. **Attributes Panel** (replaces old CSS ID & Classes)

### Module Library
- 40+ built-in modules with complete selector reference
- 8 new D5 modules: Group, Carousel Group, Before/After Image, Canvas Portal, Dropdown, Icon List, Link, Lottie
- 17+ WooCommerce product modules

### Canvas System (New in D5)
- **Main Canvas** — primary page content
- **Local Canvases** — per-page detached workspaces
- **Global Canvases** — site-wide reusable canvases
- **Canvas Portal Module** — inject canvas content at specific locations
- **Interaction Builder** — cross-canvas interactions (Click, Mouse, Viewport, Load triggers)
- Off-canvas menus, popups, mega menus, staging areas

### Design System
- 6 Design Variable types (Colors, Fonts, Numbers, Images, Text, Links)
- 4-tier Preset hierarchy (Option Group, Element, Stacked, Nested)
- Composable Settings — enable any option on any sub-element
- CSS custom properties fully supported

### Responsive Design
- 7 breakpoints (3 active by default: Phone 767px, Tablet 980px, Desktop)
- 4 optional: Phone Wide 860px, Tablet Wide 1024px, Widescreen 1280px, Ultra Wide 2560px
- All breakpoint widths customizable

### Accessibility Support
- Semantic Elements (change div to nav, header, section, etc.)
- ARIA attributes via Attributes panel
- Focus indicator patterns (Divi removes defaults)
- Reduced motion support
- WCAG 2.1 AA color contrast guidance
- Touch target sizing

### Troubleshooting Knowledge
- Cache plugin conflicts (WP Rocket RUCSS, LiteSpeed, Autoptimize)
- Security plugin issues (Wordfence firewall)
- WooCommerce styling problems
- Divi 4 to 5 migration patterns
- Debugging with Safe Mode, DevTools, D5 Dev Tool
- Divi 5.2 bug fixes (transform corruption, box-shadow hover, loop CSS)

### CSS Example Library
- **Button Variants** — primary, secondary, outline, sizes
- **Design Tokens** — complete design system template
- **Animations** — fade, slide, scale, stagger, hover effects with reduced-motion
- **Dark Mode** — system-aware with manual toggle
- **WooCommerce** — product grids, cards, cart, checkout
- **Accessibility** — focus indicators, skip links, screen reader utilities, high contrast

## Optional MCP Servers

No MCP servers required. For extended capabilities, add to your `.mcp.json`:

### Context7 (Documentation Lookup)
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Playwright (Browser Testing)
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

### A11y (Accessibility Testing)
```json
{
  "mcpServers": {
    "a11y": {
      "command": "npx",
      "args": ["-y", "a11y-mcp"]
    }
  }
}
```

**Windows users:** Wrap in `"command": "cmd", "args": ["/c", "npx", "-y", "..."]`

## Configuration

Create `.claude/divi5-toolkit.local.md` in your project root. Full template at `templates/divi5-toolkit.local.md`.

Key settings:

```yaml
validation_mode: advisory             # "advisory" (warnings) or "strict" (blocking errors)
default_format: theme-options         # "theme-options" | "code-module" | "child-theme" | "free-form"
auto_validate: true                   # validate CSS files automatically after Write/Edit
divi_version: "5.2"                   # target Divi version — read by /research and the validators
css_prefix: my                        # your custom CSS class prefix
active_breakpoints:                   # which of Divi 5's 7 breakpoints to use
  - phone
  - tablet
  - desktop
accessibility_level: aa               # "aa" | "aaa" | "off" — strictness of accessibility checks
flag_composable_alternatives: true    # suggest builder-native alternatives to custom CSS (Divi 5.2+)
scaffold_style: light                 # "light" | "dark" | "brand" — default color scheme for /scaffold
last_research: 2026-04-12             # auto-updated by divi5-researcher
```

**What each setting affects:**

| Setting | Read by |
|---------|---------|
| `validation_mode` | `/validate`, `divi5-validator` |
| `default_format` | `/generate`, `/scaffold`, `/convert` |
| `auto_validate` | PostToolUse hook |
| `divi_version` | `/audit` (and the project config template default) |
| `css_prefix` | `/generate`, `/scaffold`, `/convert` |
| `active_breakpoints` | `/generate`, `/scaffold` |
| `accessibility_level` | `/validate`, `/audit`, `divi5-accessibility` |
| `flag_composable_alternatives` | `/validate`, `/convert`, `/audit` |
| `scaffold_style` | `/scaffold` |
| `last_research` | `/research`, `divi5-researcher` |

## Installation

There are two ways to load the plugin: per-session (one-off) or persistent (auto-loads in specific projects or globally).

### Option 1 — Per-session (one-off, no setup)

From your project directory, start Claude Code with the `--plugin-dir` flag:

```bash
claude --plugin-dir "/path/to/Divi5-ToolKit/plugins/divi5-toolkit"
```

The plugin loads for that session only. Use this for testing or occasional use.

### Option 2 — Per-project (recommended for active Divi work)

Auto-load the plugin whenever you start Claude Code in a specific project. This uses Claude Code's local marketplace mechanism — no actual marketplace publication required.

In your website project root, create `.claude/settings.local.json` (gitignored — keeps your absolute path machine-local):

```json
{
  "extraKnownMarketplaces": {
    "divi5-local": {
      "source": {
        "source": "directory",
        "path": "/absolute/path/to/Divi5-ToolKit"
      }
    }
  },
  "enabledPlugins": {
    "divi5-toolkit@divi5-local": true
  }
}
```

Make sure `.claude/settings.local.json` is in your project's `.gitignore` so the absolute path doesn't get committed:

```
.claude/settings.local.json
.claude/*.local.json
```

Then start Claude Code from the project directory — `/divi5-toolkit:` should autocomplete.

### Option 3 — Global (always loaded everywhere)

Same JSON as Option 2, but write it to `~/.claude/settings.json` instead of the per-project file. The plugin will be available in every Claude Code session on your machine.

### How it works

The Divi5-ToolKit ships with `.claude-plugin/marketplace.json` (the marketplace manifest) alongside `.claude-plugin/plugin.json` (the plugin manifest). Claude Code looks for `marketplace.json` at exactly that path inside any directory you register via `extraKnownMarketplaces`.

The `extraKnownMarketplaces` entry in your settings tells Claude Code to treat the local directory as a marketplace; Claude reads `.claude-plugin/marketplace.json` from that directory to discover what plugins are available; `enabledPlugins` activates the plugin from that marketplace.

The marketplace name is `divi5-local` (declared inside `.claude-plugin/marketplace.json`). It must match the key you use in `extraKnownMarketplaces` and the part after the `@` in `enabledPlugins`. The reference patterns in the JSON above use that name verbatim — change them in lockstep if you want a different name.

No publication, validation, or CLI registration step is needed.

## Directory Structure

```
divi5-toolkit/                            # ← repo root + marketplace root
├── .claude-plugin/
│   └── marketplace.json                 # Marketplace manifest (lists plugins)
├── plugins/
│   └── divi5-toolkit/                   # ← plugin lives in a subdirectory
│       ├── .claude-plugin/
│       │   └── plugin.json              # Plugin manifest (name, version)
│       ├── commands/                     # Slash commands
│       │   ├── generate.md
│       │   ├── validate.md
│       │   ├── convert.md
│       │   ├── research.md
│       │   ├── scaffold.md
│       │   └── audit.md
│       ├── agents/                       # Autonomous agents
│       │   ├── divi5-validator.md
│       │   ├── divi5-error-learner.md
│       │   ├── divi5-researcher.md
│       │   └── divi5-accessibility.md
│       ├── skills/                       # Auto-activating skills
│       │   ├── divi5-css-patterns/
│       │   │   ├── SKILL.md
│       │   │   ├── examples/
│       │   │   │   ├── button-variants.css
│       │   │   │   ├── design-tokens.css
│       │   │   │   ├── animations.css
│       │   │   │   ├── dark-mode.css
│       │   │   │   ├── woocommerce.css
│       │   │   │   └── accessibility.css
│       │   │   └── references/
│       │   │       └── divi-selectors.md
│       │   └── divi5-compatibility/
│       │       ├── SKILL.md
│       │       └── references/
│       │           └── unit-conversions.md
│       ├── hooks/
│       │   └── hooks.json               # Event handlers
│       ├── templates/
│       │   └── divi5-toolkit.local.md   # Configuration template
│       └── .mcp.json
├── docs/                                 # End-user documentation
│   ├── usage.md                         # Detailed component reference
│   ├── configuration.md                 # Config setting reference
│   ├── workflows.md                     # Step-by-step scenarios
│   └── troubleshooting.md               # FAQ + diagnostic steps
├── CLAUDE.md                             # Developer guidance (working ON the plugin)
├── STATE.md                              # Project state snapshot
└── README.md
```

## Changelog

### v2.1.6 (April 12, 2026)
- **Fixed (critical):** Removed the `SessionStart` entry from `hooks/hooks.json`. Claude Code's `prompt`-type hooks require a `ToolUseContext`, which doesn't exist before any tool has been called, so the hook was firing a `ToolUseContext is required for prompt hooks. This is a bug.` error every time a session started in a project with the plugin enabled. The hook only ever provided two nice-to-have notifications (stale `last_research`, outdated `divi_version`); both are still documented in `docs/workflows.md` and `docs/configuration.md`. The `PostToolUse` hook is unaffected — it has a tool context by design.
- **Updated:** README config "Read by" table no longer claims that `divi_version` and `last_research` are read by a SessionStart hook. They're now read only by `divi5-researcher` and the consuming commands.
- **Updated:** STATE.md hook count (was "1 file, 2 event handlers", now "1 file, 1 event handler").
- **Action required:** If you already had v2.1.5 enabled in a project, run `claude plugin marketplace update divi5-local` (or restart Claude Code) to pick up the fix.

### v2.1.5 (April 13, 2026)
- **Fixed (critical, breaking for `--plugin-dir` users):** Restructured the repo so the plugin lives in `plugins/divi5-toolkit/` instead of the repo root. Verified against the official Anthropic plugin marketplace docs: a directory-source plugin must live in a subdirectory of the marketplace root, not at the marketplace root itself. The `source: "./"` form attempted in v2.1.4 was rejected by Claude Code's loader even though the schema technically allowed it, because the plugin's `.claude-plugin/plugin.json` and the marketplace's `.claude-plugin/marketplace.json` cannot coexist in the same `.claude-plugin/` directory.
- **Fixed:** `marketplace.json` schema errors caught by `claude plugin validate`:
  - Removed top-level `$schema` field (not in the schema).
  - Moved top-level `description` into `metadata.description` (description at root is not allowed).
- **New:** `claude plugin validate .` now passes for the marketplace.
- **Breaking:** Per-session loading via `--plugin-dir` now requires the subdirectory path:
  ```bash
  # v2.1.4 and earlier (broken)
  claude --plugin-dir "/path/to/Divi5-ToolKit"
  # v2.1.5 and later
  claude --plugin-dir "/path/to/Divi5-ToolKit/plugins/divi5-toolkit"
  ```
- **NOT breaking:** Per-project and global marketplace loading via `extraKnownMarketplaces` is unchanged. Users still point at `/path/to/Divi5-ToolKit` (the marketplace root). Claude Code reads `.claude-plugin/marketplace.json` from there and follows the `source: "./plugins/divi5-toolkit"` reference automatically.
- **Updated:** README directory tree shows the new layout. Installation section, workflows.md, and troubleshooting.md all updated with the new `--plugin-dir` path.
- **Updated:** CLAUDE.md architecture diagram reflects the subdirectory structure. Versioning checklist updated.

### v2.1.4 (April 13, 2026, broken)
- **Attempted:** First attempt at adding `marketplace.json` for persistent loading. Used `source: "./"` (plugin = marketplace root) and an incorrect top-level schema. Rejected by `claude plugin validate` and by Claude Code's loader. Superseded by 2.1.5.

### v2.1.3 (April 13, 2026)
- **Attempted (broken):** Tried to add `marketplace.json` for persistent loading. File was placed at the wrong path and used the wrong schema. v2.1.4 supersedes this — do not use 2.1.3.
- **New:** README **Installation** section now documents three loading approaches: per-session (`--plugin-dir`), per-project (`extraKnownMarketplaces` in `.claude/settings.local.json`), and global (same JSON in `~/.claude/settings.json`). Includes the exact JSON schema and gitignore rule for keeping absolute paths out of git.
- **Updated:** `docs/workflows.md` First-Time Setup workflow now shows the marketplace approach as the recommended persistent setup.
- **Updated:** `docs/troubleshooting.md` "Slash commands don't autocomplete" entry now lists missing `marketplace.json` and missing `extraKnownMarketplaces` registration as causes.
- **Updated:** `CLAUDE.md` versioning checklist now requires keeping `marketplace.json` version in sync with `.claude-plugin/plugin.json` version on every release.

### v2.1.2 (April 12, 2026)
- **New:** `docs/usage.md` — comprehensive reference for every command (purpose, args, example, output, tools used), every agent (triggers, behavior, model, output), every skill (activation triggers, content), every hook, every CSS example, and every template.
- **New:** `docs/configuration.md` — every setting explained with rationale, plus 6 recommended config presets (solo developer, agency, government/healthcare, WooCommerce store, prototype, legacy 5.0/5.1 project).
- **New:** `docs/workflows.md` — 10 step-by-step scenarios: first-time setup, landing page from scratch, Divi 4 → 5 migration, inherited project audit, dark mode toggle, WooCommerce product grid, off-canvas menu, WCAG AA compliance, debugging "styles not applying", knowledge base refresh.
- **New:** `docs/troubleshooting.md` — FAQ + diagnostic steps covering plugin issues, Divi CSS issues, builder issues, plugin conflicts (WP Rocket, LiteSpeed, Autoptimize, Wordfence), migration issues, performance, and accessibility. Plus a 12-question general FAQ.
- **New:** README **Quickstart** section — get up and running in 4 commands.
- **New:** README **Documentation** section — links into the new `docs/` directory.
- **Updated:** README directory tree now shows `docs/`, `CLAUDE.md`, and `STATE.md`.

### v2.1.1 (April 12, 2026)
- **Fixed:** Three v2.1.0 config keys (`accessibility_level`, `flag_composable_alternatives`, `scaffold_style`) were defined in the template but not actually consumed by any command or agent. Now wired into `/validate`, `/audit`, `/convert`, `/scaffold`, and the `divi5-accessibility` agent. Each consuming file reads `.claude/divi5-toolkit.local.md` in a "Read Project Config" step.
- **New:** `accessibility_level: aaa` adds stricter WCAG 2.1 AAA thresholds (7:1 contrast for normal text, ≥2px focus rings, hover-animation rules). `accessibility_level: off` skips accessibility checks entirely.
- **New:** `CLAUDE.md` — developer guide for working ON the plugin (architecture, conventions, versioning, naming).
- **New:** `STATE.md` — project state snapshot with component inventory.
- **New:** "User Config Schema" policy in CLAUDE.md — every key in the template MUST be consumed somewhere; orphan keys are a bug.
- **New:** "Product Name vs. Page Builder" naming convention table in CLAUDE.md, documenting the three intentional forms (`divi5-toolkit` / `Divi5 Toolkit` / `Divi 5`).
- **New:** "When to Research" usage policies on `/generate`, `/scaffold`, and `divi5-accessibility` — bounds when WebSearch/WebFetch should be used.
- **Updated:** README config block now lists all 10 settings with a "Read by" table mapping each to its consumer.
- **Updated:** Cross-references between commands and agents (validate ↔ validator, convert/audit ↔ validate, scaffold ↔ audit, accessibility agent ↔ accessibility.css example).
- **Updated:** Skill `description` fields expanded with richer auto-activation triggers.
- **Updated:** All CSS example file headers standardized (paste location, apply target, reduced-motion note, consistent arrow notation).
- **Updated:** Both reference files (`divi-selectors.md`, `unit-conversions.md`) now back-link to their parent skill.
- **Fixed:** README directory tree referenced a nonexistent `unit-conversions.md` under `css-patterns/references/`. Removed.
- **Fixed:** `/generate` referenced "v5.1+" — corrected to "v5.2+".

### v2.1.0 (April 12, 2026)
- **New:** `/scaffold` command — generate complete page section templates (hero, pricing, FAQ, CTA, off-canvas menu, popup modal, WooCommerce grid, and 10 more)
- **New:** `/audit` command — whole-project CSS audit with scoring (A-F grade), category breakdown, and prioritized fix list
- **New:** `divi5-accessibility` agent — WCAG 2.1 AA checker for focus indicators, color contrast, touch targets, reduced motion, semantic elements
- **New:** Animation patterns example (fade, slide, scale, stagger, hover effects with `prefers-reduced-motion`)
- **New:** Dark mode pattern example (system-aware with manual toggle)
- **New:** WooCommerce patterns example (product grids, cards, cart, checkout, Loop Builder)
- **New:** Accessibility CSS example (focus indicators, skip links, screen reader utilities, high contrast mode)
- **Updated:** Full Divi 5.2 support — Composable Settings, Canvas system, Loop Builder, Interaction Builder, Page Manager
- **Updated:** Validate command — 4 new checks: focus indicators, reduced motion, Composable Settings opportunities, hardcoded colors
- **Updated:** Generate command — now suggests Composable Settings alternatives and includes accessibility notes
- **Updated:** Convert command — adds accessibility fixes and flags Composable Settings opportunities
- **Updated:** Error learner — 6 new error patterns (transform corruption, box-shadow hover, loop CSS, Canvas issues, Composable Settings, focus indicators)
- **Updated:** Hooks — smarter CSS-only file filtering, Divi version upgrade notification, accessibility hints
- **Updated:** CSS patterns skill — Composable Settings docs, Canvas system patterns, Loop Builder patterns, expanded best practices
- **Updated:** Compatibility skill — 5.2 bug fixes reference, Composable Settings compatibility table

### v2.0.0 (March 18, 2026)
- Major overhaul with verified Divi 5.1 knowledge base

### v1.0.1
- Upgrade frontmatter to latest Claude Code protocols

### v1.0.0
- Initial release

## Community Resources

- [Elegant Themes Help Center](https://help.elegantthemes.com)
- [Divi 5 Changelog](https://victorduse.com/divi-5-changelog/)
- [Custom CSS Troubleshooting Guide](https://help.elegantthemes.com/en/articles/13479939-how-to-troubleshoot-and-fix-custom-css-issues-in-divi-5)
- [Composable Settings](https://www.elegantthemes.com/blog/theme-releases/composable-settings)
- [Canvas System Guide](https://help.elegantthemes.com/en/articles/13249775-divi-5-canvases-off-canvas-menus-popups-canvas-portals)
- [WooCommerce + Divi 5](https://www.elegantthemes.com/blog/divi-resources/woocommerce-and-divi-5-the-complete-ecommerce-guide)
- [Divi 5 Accessibility Testing](https://www.elegantthemes.com/blog/divi-resources/testing-accessibility-attributes-with-divi-5)
- [WP Zone CSS Guide](https://wpzone.co/the-divi-css-and-child-theme-guide/)
- [Quiroz.co Snippets](https://quiroz.co/divi-tutorials-much/divi-snippets-css-php/)
- [D5 Dev Tool](https://github.com/elegantthemes/d5-dev-tool)
- [D5 Extension Examples](https://github.com/elegantthemes/d5-extension-example-modules)

## License

MIT
