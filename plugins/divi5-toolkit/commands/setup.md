---
name: setup
description: Bootstrap or refresh the project's Divi5 Toolkit config (.claude/divi5-toolkit.local.md). Auto-detects the installed Divi version, child theme, and existing CSS class prefix, then writes a config with sensible defaults — no manual template copying.
argument-hint: [--refresh]
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Divi5 Toolkit Project Setup

You are creating (or refreshing) `.claude/divi5-toolkit.local.md` in the user's project so every other command and agent reads the right prefix, Divi version, output format, and breakpoints. Detect as much as you can from the project; ask only what you cannot detect.

## Step 1: Locate the Existing Config

Look for `.claude/divi5-toolkit.local.md` in the project root.

- **Missing** → create mode (Steps 2–6).
- **Present** → refresh mode. Read it, keep every existing value, and only:
  1. Add keys that exist in the template but not in the user's file (with template defaults).
  2. Re-run detection (Step 2) and, if the installed Divi is newer than `divi_version`, offer to bump it.
  3. Update the Quick Reference command list below the frontmatter if it is missing newer commands.
  Never overwrite `learned_errors`, `research_notes`, `last_research`, or any value the user set.

The template is at `${CLAUDE_PLUGIN_ROOT}/templates/divi5-toolkit.local.md`. Read it first — it is the source of truth for the key list, comments, and defaults.

## Step 2: Detect the Project

Run these detections with `Glob` / `Grep` / `Read`. Skip `node_modules/`, `vendor/`, and `.git/`.

### 2a. Installed Divi version
- `Glob` for `**/themes/Divi/style.css`.
- Read the first 30 lines and parse the `Version:` header (e.g., `Version: 5.13.1`).
- Truncate to `major.minor` for `divi_version` (`5.13.1` → `"5.13"`).
- If the detected version is **newer** than the newest version this plugin documents (see the compatibility skill header), say so and recommend `/divi5-toolkit:research` after setup.
- If no Divi theme is found (CSS-only repo, child theme repo without the parent), fall back to the template default and say you assumed it.

### 2b. Child theme
- `Grep` for `^Template:\s*Divi` in any `style.css` under `**/themes/*/`.
- If found, note the child theme path and default `default_format` to `child-theme`. Otherwise keep `theme-options`.

### 2c. Existing CSS class prefix
- `Grep` CSS files (`**/*.css`, `**/*.scss`) for custom class patterns: `\.([a-z][a-z0-9]{1,7})-[a-z]`.
- Count matches per prefix, ignoring Divi/WordPress-owned prefixes: `et`, `et_pb`, `wp`, `has`, `is`, `wc`, `woocommerce`, `gform`, `wpcf7`, `screen`, `alignwide`, `alignfull`.
- If one prefix clearly dominates (≥ 60% of custom-class hits and ≥ 5 hits), propose it as `css_prefix`. Otherwise propose the template default `my`.

### 2d. WooCommerce
- `Glob` for `**/plugins/woocommerce/woocommerce.php`. If present, set `scaffold_style: brand` as the proposed default and mention that `widescreen` is a common extra breakpoint for shop grids (do not enable it automatically).

### 2e. Existing design tokens
- `Grep` CSS for `--color-primary` / `--{prefix}-color-primary`. If found, propose `scaffold_style: brand`.

## Step 3: Ask Only What You Couldn't Detect

Ask at most **three** questions, and only for values with no detection signal. Present detected values as defaults the user can accept by pressing Enter (or saying "looks good"):

1. `css_prefix` — if no dominant prefix was found.
2. `accessibility_level` — `aa` (default) unless the user says the site is government / healthcare / education / finance (then `aaa`).
3. `default_format` — only if both a child theme and heavy Theme Options usage were detected and the choice is genuinely ambiguous.

Do not ask about `validation_mode`, `auto_validate`, `active_breakpoints`, `flag_composable_alternatives`, or `last_research` — use template defaults. The user can edit those later.

## Step 4: Write the Config

Create `.claude/` if needed, then write `.claude/divi5-toolkit.local.md` using the template's full frontmatter and body. Substitute the detected/confirmed values. Keep every comment line from the template so the file stays self-documenting.

Set `last_research` to the template's value (it tracks the plugin's own knowledge date, not today's date).

In refresh mode, use `Edit` to add missing keys in the same order as the template rather than rewriting the file.

## Step 5: Verify

Re-read the file you wrote and confirm:
- It starts with `---`, contains valid YAML (2-space indentation, quoted `divi_version`), and closes with `---`.
- Every key from the template is present exactly once.
- `active_breakpoints` is a YAML list.

If a check fails, fix it before reporting.

## Step 6: Report

```
========================================
DIVI5 TOOLKIT SETUP
========================================
Config: .claude/divi5-toolkit.local.md  ([created | refreshed])

DETECTED:
  Divi version:   [5.13.1 → "5.13"]  (from wp-content/themes/Divi/style.css)
  Child theme:    [path | none]
  CSS prefix:     [acme (42 matches) | my (default)]
  WooCommerce:    [yes | no]

WRITTEN:
  divi_version:          "[x.y]"
  default_format:        [theme-options | child-theme]
  css_prefix:            [prefix]
  accessibility_level:   [aa | aaa]
  scaffold_style:        [light | brand]
  active_breakpoints:    phone, tablet, desktop
  (all other keys at template defaults)

NEXT:
  - /divi5-toolkit:generate primary button   → confirm the prefix flows through
  - /divi5-toolkit:audit                     → baseline the existing CSS
  - /divi5-toolkit:research                  → [only if installed Divi is newer than the plugin knows]
========================================
```

## Important Notes

- This command writes exactly one file. It never touches `.gitignore`, `settings.local.json`, or the plugin's own files.
- The config is meant to be committed — it holds team-wide project settings. Only `.claude/settings.local.json` (machine-local paths) should be gitignored.
- If the project has multiple WordPress installs (monorepo), ask which one is the target before detecting.
- If `divi_version` detection returns a Divi 4 version (`4.x`), stop and explain that this toolkit targets Divi 5; point to `/divi5-toolkit:convert` for migrating CSS once they upgrade.
