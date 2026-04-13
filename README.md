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
validation_mode: advisory    # "advisory" (warnings) or "strict" (blocking errors)
default_format: theme-options # "theme-options", "code-module", "child-theme", "free-form"
auto_validate: true          # validate CSS files automatically after Write/Edit
divi_version: "5.2"
css_prefix: my               # your CSS variable prefix
active_breakpoints:          # which of Divi 5's 7 breakpoints to use
  - phone
  - tablet
  - desktop
last_research: 2026-04-12    # auto-updated by divi5-researcher
```

## Installation

### From Local Directory
```bash
claude --plugin-dir "/path/to/Divi5-ToolKit"
```

### Add to Project
Copy the plugin folder to your desired location, keeping the directory structure intact.

## Directory Structure

```
divi5-toolkit/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── commands/                     # Slash commands
│   ├── generate.md
│   ├── validate.md
│   ├── convert.md
│   ├── research.md
│   ├── scaffold.md              # NEW: Section templates
│   └── audit.md                 # NEW: Project CSS audit
├── agents/                       # Autonomous agents
│   ├── divi5-validator.md
│   ├── divi5-error-learner.md
│   ├── divi5-researcher.md
│   └── divi5-accessibility.md   # NEW: WCAG checker
├── skills/                       # Auto-activating skills
│   ├── divi5-css-patterns/
│   │   ├── SKILL.md
│   │   ├── examples/
│   │   │   ├── button-variants.css
│   │   │   ├── design-tokens.css
│   │   │   ├── animations.css       # NEW
│   │   │   ├── dark-mode.css        # NEW
│   │   │   ├── woocommerce.css      # NEW
│   │   │   └── accessibility.css    # NEW
│   │   └── references/
│   │       ├── divi-selectors.md
│   │       └── unit-conversions.md
│   └── divi5-compatibility/
│       ├── SKILL.md
│       └── references/
│           └── unit-conversions.md
├── hooks/
│   └── hooks.json               # Event handlers
├── templates/
│   └── divi5-toolkit.local.md   # Configuration template
├── .mcp.json
└── README.md
```

## Changelog

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
