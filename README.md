# Divi5 Toolkit

A self-improving Claude Code plugin for Divi 5 development. Validates CSS compatibility, generates Divi-ready code, and learns from your errors to get smarter over time.

## Features

- **CSS/HTML Development**: Guided patterns for Divi 5 CSS structure, class naming, and selector specificity
- **Compatibility Validation**: Checks for unsupported features (`ch`/`ex` units), missing `!important`, specificity issues
- **Code Generation**: Generates Divi 5-ready CSS in three formats:
  - Theme Options (global CSS, no wrapper)
  - Code Module (with `<style>` tags)
  - Child Theme (standard CSS file)
- **Self-Improving**: Learns from errors you paste and researches latest Divi 5 updates
- **Ultrathink Mode**: Deep analysis for complex validation and research tasks
- **MCP Integrations**: A11y accessibility testing and Playwright browser automation

## Commands

| Command | Description |
|---------|-------------|
| `/divi5-toolkit:generate` | Generate Divi 5-ready CSS |
| `/divi5-toolkit:validate` | Validate CSS for Divi 5 compatibility (uses ultrathink) |
| `/divi5-toolkit:convert` | Convert existing CSS to Divi 5 format |
| `/divi5-toolkit:research` | Research latest Divi 5 updates (uses ultrathink) |

## Agents

| Agent | Triggers When |
|-------|---------------|
| `divi5-validator` | After writing/editing CSS files |
| `divi5-error-learner` | When you paste Divi error messages (uses ultrathink) |
| `divi5-researcher` | On-demand or when knowledge is stale (>7 days) |

## Skills

| Skill | Activates When |
|-------|----------------|
| `divi5-css-patterns` | Writing CSS for Divi, styling Divi modules |
| `divi5-compatibility` | Validating CSS, troubleshooting Divi issues |

## MCP Servers

This plugin includes optional MCP server configurations:

| Server | Purpose |
|--------|---------|
| `a11y-mcp` | WCAG accessibility testing for Divi pages |
| `playwright-mcp` | Browser automation for testing layouts |

## Configuration

Create `.claude/divi5-toolkit.local.md` in your project to customize:

```yaml
---
validation_mode: advisory    # or "strict"
default_format: theme-options # or "code-module", "child-theme"
auto_validate: true          # trigger validation after CSS changes
last_research: 2024-12-25    # auto-updated by researcher
css_prefix: cjs              # your CSS variable prefix
---
```

A template is available at `templates/divi5-toolkit.local.md`.

## Installation

### From Local Directory
```bash
claude --plugin-dir "C:\Users\casey\Documents\Divi5-ToolKit"
```

### Add to Project
Copy the plugin to your project's `.claude-plugin/` directory.

## Divi 5 Quick Reference

### Supported CSS Features
- CSS Variables (`--custom-property`)
- `calc()`, `clamp()`, `min()`, `max()`
- Flexbox and CSS Grid
- All standard units: `px`, `em`, `rem`, `%`, `vw`, `vh`

### NOT Supported
- `ch` unit (use `rem` instead: 75ch ≈ 60rem)
- `ex` unit (use `em` instead: 1ex ≈ 0.5em)
- Container queries (coming soon)

### Button Override Pattern
```css
body .et_pb_button {
  background-color: #000000 !important;
  border-radius: 0 !important;
  letter-spacing: 4px !important;
}
```

### Section Override Pattern
```css
.et_pb_section.my-dark-section {
  background-color: #1d1f22 !important;
}

.et_pb_section.my-dark-section h1,
.et_pb_section.my-dark-section p {
  color: #ffffff !important;
}
```

### Text Width Pattern
```css
.et_pb_text_inner p {
  max-width: 60rem;  /* NOT 75ch */
}
```

## Directory Structure

```
divi5-toolkit/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/                 # Slash commands
│   ├── generate.md
│   ├── validate.md
│   ├── convert.md
│   └── research.md
├── agents/                   # Autonomous agents
│   ├── divi5-validator.md
│   ├── divi5-error-learner.md
│   └── divi5-researcher.md
├── skills/                   # Auto-activating skills
│   ├── divi5-css-patterns/
│   │   ├── SKILL.md
│   │   ├── examples/
│   │   └── references/
│   └── divi5-compatibility/
│       ├── SKILL.md
│       └── references/
├── hooks/
│   └── hooks.json           # Event handlers
├── templates/
│   └── divi5-toolkit.local.md
├── .mcp.json                # MCP server configs
└── README.md
```

## Validation Modes

### Advisory Mode (Default)
- Reports issues as warnings
- Suggests fixes
- Allows proceeding with warnings

### Strict Mode
- Reports issues as errors
- Requires fixes before proceeding
- Blocks incompatible CSS

## Workflow

1. **Generate CSS**: Use `/divi5-toolkit:generate` to create Divi-ready CSS
2. **Auto-Validate**: Plugin automatically validates CSS after changes
3. **Fix Issues**: Use `/divi5-toolkit:convert` to auto-fix problems
4. **Learn from Errors**: Paste any Divi errors to improve plugin knowledge
5. **Stay Updated**: Plugin researches Divi 5 updates weekly

## Alternative Resources

For complex edge cases, also consult:
- **Codex** - General WordPress/Divi questions
- **ChatGPT** - Complex CSS problem-solving
- **Elegant Themes Forum** - Community solutions
- **Divi 5 Release Notes** - Official changelog

## License

MIT
