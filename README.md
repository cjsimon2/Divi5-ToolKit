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

## Optional MCP Servers

No MCP servers are required. The plugin works fully without them. If you want extended capabilities, add any of these to your `.mcp.json`:

### Context7 (Up-to-date Documentation)
Fetches current library docs directly into your prompts.

**Mac/Linux:**
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

**Windows:**
```json
{
  "mcpServers": {
    "context7": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Playwright (Browser Testing)
Test Divi layouts across breakpoints. Official Microsoft package.

**Mac/Linux:**
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

**Windows:**
```json
{
  "mcpServers": {
    "playwright": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@playwright/mcp@latest"]
    }
  }
}
```

### A11y (Accessibility Testing)
WCAG compliance checking using axe-core.

**Mac/Linux:**
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

**Windows:**
```json
{
  "mcpServers": {
    "a11y": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "a11y-mcp"]
    }
  }
}
```

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

### Plugin Structure
This plugin uses the standard layout with the manifest at `.claude-plugin/plugin.json`
and all components (commands, agents, skills, hooks) at the repository root.

### From Local Directory
```bash
claude --plugin-dir "C:\Users\casey\Documents\Divi5-ToolKit"
```

### Add to Project
Copy the entire plugin folder to your desired location, keeping the directory structure intact.

## Divi 5 Quick Reference

### Supported CSS Features
- CSS Variables (`--custom-property`)
- `calc()`, `clamp()`, `min()`, `max()`
- Flexbox and CSS Grid
- All standard units: `px`, `em`, `rem`, `%`, `vw`, `vh`

### NOT Supported
- `ch` unit (use `rem` instead: 75ch -> 60rem)
- `ex` unit (use `em` instead: 1ex -> 0.5em)
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
