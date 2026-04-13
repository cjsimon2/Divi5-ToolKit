# CLAUDE.md — Developer Guidance

Guidance for developers working **on** the Divi5 Toolkit plugin itself (not end users consuming it).

## Project Type

Claude Code **plugin** for Divi 5 (WordPress page builder, currently 5.2) development. This repository is composed of markdown, JSON, and CSS — there is no compiled code, no build step, and no runtime beyond what Claude Code provides when the plugin is loaded.

## Architecture

```
.claude-plugin/
  plugin.json                  # Plugin manifest (name, version, keywords)
  marketplace.json             # Marketplace manifest — Claude Code reads this
                               #   when this directory is registered via
                               #   extraKnownMarketplaces in user settings.
                               #   Lists the plugin and its source path.
commands/                      # Slash commands — invoked as /divi5-toolkit:<name>
agents/                        # Autonomous subagents with focused responsibilities
skills/<skill-name>/SKILL.md   # Auto-activating knowledge skills
skills/<skill-name>/examples/  # Concrete CSS examples loaded on demand
skills/<skill-name>/references/# Reference docs loaded on demand
hooks/hooks.json               # PostToolUse + SessionStart event handlers
templates/                     # Files users copy into their own project
docs/                          # End-user documentation (usage, config,
                               #   workflows, troubleshooting)
```

**Two manifest files, both inside `.claude-plugin/`:**
- `plugin.json` — describes THIS plugin: name, version, keywords. Read by Claude Code once the plugin is loaded.
- `marketplace.json` — describes the local marketplace this directory acts as. Top-level `name` is the marketplace name (`divi5-local`). The `plugins[]` array lists which plugins this marketplace contains. Read by Claude Code when the directory is referenced via `extraKnownMarketplaces` in user settings, BEFORE the plugin itself is loaded.

The marketplace is necessary even though there's only one plugin in it — Claude Code's directory-source loader requires going through the marketplace abstraction.

## File Conventions

- **Commands** (`commands/*.md`) use YAML frontmatter: `name`, `description`, `argument-hint`, `allowed-tools`. Filename (minus `.md`) becomes the command name.
- **Agents** (`agents/divi5-*.md`) use YAML frontmatter: `name`, `description`, `tools`, `model`. Agent `name` must match the filename and begin with the `divi5-` prefix.
- **Skills** (`skills/*/SKILL.md`) use YAML frontmatter: `name`, `description`, `user-invocable`. Skills auto-activate based on their description; supporting `examples/` and `references/` files are loaded on demand by Claude.
- **CSS examples** (`skills/*/examples/*.css`) start with a header comment block explaining purpose, format (Theme Options / Code Module / Child Theme / Free-Form), and how to use the file.
- When a markdown file references another file inside the plugin, use the `${CLAUDE_PLUGIN_ROOT}` variable rather than hard-coded paths so the plugin works regardless of install location.

## Adding New Components

### New command
1. Create `commands/<name>.md` with the frontmatter shown above.
2. Document the command in `README.md` under the **Commands** table.
3. If the command introduces a new user-facing feature, add a bullet under the current version in the README changelog.

### New agent
1. Create `agents/divi5-<name>.md`. Keep the agent scope focused — one responsibility per agent.
2. Add it to the **Agents** table in `README.md`.
3. If other components (commands, hooks) should trigger it, update those files to reference the new agent by name.

### New skill
1. Create `skills/divi5-<name>/SKILL.md`.
2. Put heavy reference material in `references/` and concrete examples in `examples/` so SKILL.md stays light.
3. Add it to the **Skills** table in `README.md`.

### New CSS example
1. Add `skills/divi5-css-patterns/examples/<topic>.css` with a header comment.
2. Mention it in the **CSS Example Library** section and the directory tree in `README.md`.
3. Add a section to `docs/usage.md` under "CSS Example Library" describing what it contains, when to use it, and where to paste it.

### Updating end-user documentation
- High-level overview, install, quickstart, changelog → `README.md`
- Detailed component reference → `docs/usage.md`
- Config setting reference → `docs/configuration.md`
- Step-by-step scenarios → `docs/workflows.md`
- FAQ + diagnostic steps → `docs/troubleshooting.md`
- Developer-only docs (this file, conventions, contributing) → `CLAUDE.md`
- Component inventory snapshot → `STATE.md`

When you add a new command, agent, or skill: update the README tables AND the corresponding section in `docs/usage.md`. When you add a new config key: update the template, `README.md` config block, AND `docs/configuration.md`. When you change a workflow or add a new common scenario: add it to `docs/workflows.md`. When you fix a bug that users might hit: add a troubleshooting entry to `docs/troubleshooting.md`.

## Testing Changes

Load the plugin from a local checkout:

```bash
claude --plugin-dir "/path/to/Divi5-ToolKit"
```

Then manually exercise `/divi5-toolkit:<command>` and agents against a sample Divi project. Because there is no automated test suite, every change should be verified end-to-end in a live Claude Code session.

## Versioning

1. Bump `version` in `.claude-plugin/plugin.json`. (`.claude-plugin/marketplace.json` does NOT carry a version field — version lives only in `plugin.json`.)
2. Add a new entry at the top of the **Changelog** section in `README.md`, dated `YYYY-MM-DD`.
3. Update `STATE.md` with the new version and release date.
4. Commit with a message that names the version, then tag: `git tag vX.Y.Z && git push --tags`.

Follow semantic versioning: patch for typo/doc fixes, minor for new commands/agents/skills, major for breaking changes to command names, agent interfaces, or config schema.

**When to update `marketplace.json`:** Only when adding/removing plugins from the marketplace, or when the plugin's `description`, `category`, or `homepage` changes. The marketplace manifest does not need to be touched on every version bump.

## Naming Conventions

- **Custom CSS classes** generated for end users use the prefix from `css_prefix` in the user's config (default `my-`). Never hard-code `my-` in examples — derive it or document the variable.
- **Agents** use the `divi5-` prefix (e.g., `divi5-validator`).
- **Commands** have no prefix in the filename (`generate.md`), but users invoke them with the `divi5-toolkit:` namespace (`/divi5-toolkit:generate`).
- **Skills** use the `divi5-` prefix in the directory name (`divi5-css-patterns`, `divi5-compatibility`).

### Product Name vs. Page Builder

Three distinct conventions are applied uniformly across the repo. **Do not "fix" them to a single form** — they have different meanings:

| Form | Meaning | Where it appears |
|------|---------|------------------|
| `divi5-toolkit` (lowercase, hyphenated) | Plugin **package id**. Hard-coded into the slash command namespace. | `plugin.json`, slash commands (`/divi5-toolkit:generate`), config filename (`.claude/divi5-toolkit.local.md`) |
| `Divi5 Toolkit` (no space, title case) | Plugin **product display name**. | README title, hooks.json description, template heading, CLAUDE.md, STATE.md |
| `Divi 5` (with space) | The **Elegant Themes page builder** the plugin targets. | Prose about the product being styled (e.g., "Divi 5 ships with 7 breakpoints") |

If you find a violation (e.g., "Divi 5 Toolkit" with a space, or "Divi5" used to refer to the page builder), normalize it back to one of the three forms above.

## User Config Schema

The plugin reads runtime configuration from `.claude/divi5-toolkit.local.md` in the user's project. Every key listed in `templates/divi5-toolkit.local.md` MUST be consumed by at least one command, agent, or hook — orphan config keys are a bug. When adding a new key:

1. Add it to the template with a sensible default and an inline comment.
2. Document which component reads it in the README config table.
3. Add config-reading instructions to the consuming command/agent (use a "Read Project Config" step early in the file).
4. Decide what happens when the key is missing — always provide a safe default rather than failing.

Currently consumed keys: `validation_mode`, `default_format`, `auto_validate`, `divi_version`, `css_prefix`, `active_breakpoints`, `accessibility_level`, `flag_composable_alternatives`, `scaffold_style`, `last_research`.

## Knowledge Currency

Divi ships updates frequently. Keeping the plugin accurate matters more than shipping new features.

- The `divi5-researcher` agent runs on-demand via `/divi5-toolkit:research` and refreshes knowledge in the skill files.
- Manual research (new modules, spec changes, bug fixes you learn about) goes into `skills/divi5-css-patterns/SKILL.md` or `skills/divi5-compatibility/SKILL.md` — whichever is more appropriate.
- Bump `last_research` in the config template (`templates/divi5-toolkit.local.md`) when you do a knowledge refresh.
- The SessionStart hook warns users if their `last_research` is more than 7 days stale; keep this behavior honest by actually updating on research runs.
