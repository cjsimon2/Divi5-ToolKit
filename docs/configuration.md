# Configuration Guide

Every setting in `.claude/divi5-toolkit.local.md` explained, with rationale and recommended values for different project types.

- [Where the Config Lives](#where-the-config-lives)
- [The Full Schema](#the-full-schema)
- [Setting Reference](#setting-reference)
- [Recommended Configs by Project Type](#recommended-configs-by-project-type)
- [How Settings Are Read](#how-settings-are-read)

---

## Where the Config Lives

The plugin reads its runtime configuration from a single file in **your** project (not in the plugin):

```
your-project/
└── .claude/
    └── divi5-toolkit.local.md
```

To create it, copy the template:

```bash
mkdir -p .claude
cp /path/to/Divi5-ToolKit/templates/divi5-toolkit.local.md .claude/divi5-toolkit.local.md
```

Or write the file by hand using the schema below. The plugin works without any config file — it falls back to defaults — but you'll get more consistent results by setting a few key values.

The file is markdown with a YAML frontmatter block. Only the YAML matters; everything below `---` is for your own notes.

---

## The Full Schema

```yaml
---
# ─── Validation ────────────────────────────────────────────────────────────
validation_mode: advisory             # "advisory" | "strict"
auto_validate: true                   # true | false

# ─── Output Defaults ──────────────────────────────────────────────────────
default_format: theme-options         # "theme-options" | "code-module"
                                      # | "child-theme" | "free-form"
css_prefix: my                        # custom CSS class prefix

# ─── Project Targeting ────────────────────────────────────────────────────
divi_version: "5.6"                   # "5.0" | "5.1" | "5.2" | "5.3" | "5.4" | "5.5" | "5.6"
active_breakpoints:                   # which of Divi 5's 7 breakpoints to use
  - phone
  - tablet
  - desktop

# ─── Accessibility ────────────────────────────────────────────────────────
accessibility_level: aa               # "aa" | "aaa" | "off"

# ─── Composable Settings (Divi 5.2+) ──────────────────────────────────────
flag_composable_alternatives: true    # true | false

# ─── Scaffolding ──────────────────────────────────────────────────────────
scaffold_style: light                 # "light" | "dark" | "brand"

# ─── Knowledge Base ───────────────────────────────────────────────────────
last_research: 2026-04-12             # YYYY-MM-DD, auto-updated by /research

# ─── Auto-populated ───────────────────────────────────────────────────────
learned_errors: []                    # populated by divi5-error-learner
research_notes: |                     # populated by divi5-researcher
  Initial plugin setup.
---
```

---

## Setting Reference

### `validation_mode`

| Value | Behavior |
|---|---|
| `advisory` (default) | Issues are reported as warnings. Work continues; you decide whether to fix. |
| `strict` | Issues are reported as blocking errors. Use when you want a CI-like fail-fast experience. |

**Recommendation:** Start with `advisory`. Switch to `strict` when you're preparing CSS for production or onboarding new contributors who need guard rails.

**Read by:** `/validate`, `divi5-validator` agent

---

### `auto_validate`

| Value | Behavior |
|---|---|
| `true` (default) | The PostToolUse hook runs `divi5-validator` after every CSS file write/edit. |
| `false` | No automatic validation. You run `/validate` manually. |

**Recommendation:** Leave `true` unless the inline reports become noisy. The validator is fast (haiku model) and only reports critical issues by default.

**Read by:** PostToolUse hook in `hooks/hooks.json`

---

### `default_format`

The output format `/generate`, `/scaffold`, and `/convert` use when you don't specify one explicitly.

| Value | When to Use |
|---|---|
| `theme-options` (default) | Site-wide styles. Pasted into Divi > Theme Options > Custom CSS. No `<style>` tags. Loads after the child theme. |
| `code-module` | Page-specific styles. Pasted into a Code Module on a page. Wrapped in `<style>` tags. |
| `child-theme` | Maintained in your child theme's `style.css`. Standard CSS file, no tags. Use when you have a developer workflow with version control. |
| `free-form` | Per-element styles using the `selector` keyword. Pasted into a module's Advanced > Custom CSS > Free-Form CSS field. |

**Recommendation:** `theme-options` for solo developers and small sites. `child-theme` for team projects under version control.

**Read by:** `/generate`, `/scaffold`, `/convert`

---

### `css_prefix`

Your project's custom CSS class prefix. Generated CSS uses this prefix to avoid clashing with Divi's own classes.

**Format:** A short, lowercase string with no spaces. Examples: `my`, `acme`, `bb` (for "Bauer & Bailey"), `site`.

**How it's used:** When the plugin generates `.{prefix}-hero`, `.{prefix}-card`, etc., it substitutes your prefix. Default is `my`, so you'd get `.my-hero`, `.my-card`.

**Recommendation:** Set it to your client's initials or a short site abbreviation. Avoid `divi`, `et`, `et_pb_` — those are reserved.

**Read by:** `/generate`, `/scaffold`, `/convert`

---

### `divi_version`

The Divi version your project targets.

| Value | Implications |
|---|---|
| `"5.0"` | Composable Settings unavailable. Some bug fixes (transform corruption, box-shadow hover, loop CSS) not yet applied. |
| `"5.1"` | Same as 5.0 — Composable Settings still unavailable. |
| `"5.2"` | Composable Settings, Canvas system, Loop Builder, Interaction Builder. Missing: 5.3 form overhaul, 5.4 Variable Generators, 5.5 Aspect Ratio/Framing, 5.6 new modules. |
| `"5.3"` | Adds pseudo-class editing (`:checked`/`:focus`/`:active`), Contact Form 7 Styler module, Nested Option Presets, harmonized form fields. |
| `"5.4"` | Adds Sizing Variable Generator (fluid `clamp()` automation) and Relative Colorscheme Generator (HSL-based color systems). |
| `"5.5"` | Adds Aspect Ratio + Framing settings on all images (cleanest CLS fix), Image Presets, SVG sanitization, composable settings for image option groups. |
| `"5.6"` (recommended) | Adds 5 new modules (Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed), Color Scale + Color Harmony Generators, decimal Section Divider, full CSS track values in Grid Auto Columns/Rows. |

**Recommendation:** Use `"5.6"`. The plugin tailors its advice to the version you set — `/audit` gates Composable Settings suggestions on 5.2+, the performance agent recommends Aspect Ratio for CLS only on 5.5+, the form CSS examples assume 5.3+ pseudo-class editing, and so on.

**Read by:** `/audit`, `/diagnose`, `divi5-performance` agent (feature gating and version-aware advice)

---

### `active_breakpoints`

Which of Divi 5's 7 breakpoints your project actively uses. The plugin generates responsive CSS only for the breakpoints you list.

| Value | Width | Default |
|---|---|---|
| `desktop` | base | always active |
| `phone` | 767px | active by default |
| `tablet` | 980px | active by default |
| `phone-wide` | 860px | optional |
| `tablet-wide` | 1024px | optional |
| `widescreen` | 1280px | optional |
| `ultra-wide` | 2560px | optional |

**Format:** YAML list:
```yaml
active_breakpoints:
  - phone
  - tablet
  - desktop
```

**Recommendation:** Stick with the default 3 (`phone`, `tablet`, `desktop`). Add `widescreen` if you're targeting large monitors. Avoid enabling all 7 — most projects don't need them and the extra media queries add bloat.

**Read by:** `/generate`, `/scaffold`

---

### `accessibility_level`

Strictness of accessibility checks. Affects `/validate`, `/audit`, and the `divi5-accessibility` agent.

| Value | What It Does |
|---|---|
| `off` | All accessibility checks are skipped. The `divi5-accessibility` agent declines to run. `/validate` skips Checks 11–12. `/audit` skips Category E and reweights other categories to total 100%. |
| `aa` (default) | WCAG 2.1 Level AA thresholds: 4.5:1 contrast for normal text, 3:1 for large, 44x44px touch targets, focus indicators required, `prefers-reduced-motion` recommended. |
| `aaa` | WCAG 2.1 Level AAA thresholds: 7:1 contrast for normal text, 4.5:1 for large, focus indicators must be ≥ 2px thick with ≥ 3:1 contrast, line-height ≥ 1.5 on body text, animation triggered by hover/focus must have a reduced-motion fallback (P1 instead of P2). |

**Recommendation:**
- **`aa`** for almost everyone — this is the standard for general public-facing sites and the legally required minimum in many jurisdictions.
- **`aaa`** for government sites, healthcare, education, banking, or any project with explicit accessibility requirements.
- **`off`** only for prototypes you're not shipping. Do not turn this off on production sites.

**Read by:** `/validate`, `/audit`, `divi5-accessibility` agent

---

### `flag_composable_alternatives`

Whether the plugin should suggest builder-native alternatives (Composable Settings) when you write CSS that could be done in the builder instead. Only relevant on Divi 5.2+.

| Value | Behavior |
|---|---|
| `true` (default) | `/validate` Check 13, `/convert` Conversion 9, and `/audit` Step 6 all flag CSS rules that could be replaced by Composable Settings. |
| `false` | All three skip those checks entirely. Useful if your project targets Divi 5.0 or 5.1 (no Composable Settings) or if you have a deliberate reason to keep things in CSS. |

**Recommendation:** Leave `true` on Divi 5.2+ projects. Set `false` if you're stuck on 5.0/5.1 or if the suggestions become noise on a stable codebase.

**Read by:** `/validate`, `/convert`, `/audit`

---

### `scaffold_style`

The default color scheme `/scaffold` uses when you don't specify one.

| Value | Effect |
|---|---|
| `light` (default) | Light backgrounds, dark text, subtle shadows. |
| `dark` | Dark backgrounds, light text, glow effects. |
| `brand` | Uses your brand colors from the project's design tokens (looks for CSS variables prefixed with `--color-primary`, `--color-secondary`, etc.). |

**Recommendation:** Match your project's primary aesthetic. Set to `brand` if you have design tokens defined.

**Read by:** `/scaffold`

---

### `last_research`

The date the knowledge base was last refreshed by `/divi5-toolkit:research`. Format: `YYYY-MM-DD`.

**Behavior:** Read by the `divi5-researcher` agent to decide whether to short-circuit a research run when the knowledge base is still fresh. There is no automatic notification — you have to glance at the field yourself, or run `/divi5-toolkit:research` and let the agent decide whether to refresh. (v2.1.0–v2.1.5 surfaced a 7-day staleness reminder via a SessionStart hook; v2.1.6 removed it because Claude Code's `prompt`-type hooks can't run at session start.)

**Recommendation:** Don't edit by hand. Let the `/research` command update it.

**Read by:** `/divi5-toolkit:research`, `divi5-researcher` agent

---

### `learned_errors`

A list auto-populated by the `divi5-error-learner` agent when it encounters new error patterns. Each entry includes the error pattern, solution summary, and date learned.

**Recommendation:** Don't edit by hand. The error-learner manages this list.

**Read by:** `divi5-error-learner` agent

---

### `research_notes`

A free-form text block auto-populated by the `divi5-researcher` agent with summaries of recent research findings.

**Recommendation:** Read it for context. Don't edit by hand.

**Read by:** `divi5-researcher` agent

---

## Recommended Configs by Project Type

### Solo developer, small marketing site

```yaml
validation_mode: advisory
auto_validate: true
default_format: theme-options
css_prefix: my
divi_version: "5.2"
active_breakpoints: [phone, tablet, desktop]
accessibility_level: aa
flag_composable_alternatives: true
scaffold_style: light
```

### Agency, multi-client, version-controlled child themes

```yaml
validation_mode: strict
auto_validate: true
default_format: child-theme
css_prefix: acme         # set per client
divi_version: "5.2"
active_breakpoints: [phone, tablet, desktop, widescreen]
accessibility_level: aa
flag_composable_alternatives: true
scaffold_style: brand
```

### Government / healthcare / regulated industry

```yaml
validation_mode: strict
auto_validate: true
default_format: child-theme
css_prefix: gov
divi_version: "5.2"
active_breakpoints: [phone, tablet, desktop]
accessibility_level: aaa
flag_composable_alternatives: true
scaffold_style: light
```

### WooCommerce store

```yaml
validation_mode: advisory
auto_validate: true
default_format: theme-options
css_prefix: shop
divi_version: "5.2"
active_breakpoints: [phone, tablet, desktop, widescreen]
accessibility_level: aa
flag_composable_alternatives: true
scaffold_style: brand
```

### Quick prototype / sandbox

```yaml
validation_mode: advisory
auto_validate: false      # skip the noise on throwaway code
default_format: code-module
css_prefix: tmp
divi_version: "5.2"
active_breakpoints: [phone, tablet, desktop]
accessibility_level: off  # OK for throwaway code
flag_composable_alternatives: false
scaffold_style: light
```

### Legacy Divi 5.0 or 5.1 project

```yaml
validation_mode: advisory
auto_validate: true
default_format: theme-options
css_prefix: my
divi_version: "5.1"       # honest about your target
active_breakpoints: [phone, tablet, desktop]
accessibility_level: aa
flag_composable_alternatives: false  # those settings don't exist on your version
scaffold_style: light
```

---

## How Settings Are Read

Every command, agent, and hook that consumes config reads it via this pattern:

1. Look for `.claude/divi5-toolkit.local.md` in the project root.
2. Parse the YAML frontmatter.
3. Use the value if present; fall back to the default if missing.

If the file doesn't exist, all defaults apply. There is no error — the plugin works without any config.

**Where each setting is read:**

| Setting | Read by |
|---|---|
| `validation_mode` | `/validate`, `divi5-validator` |
| `auto_validate` | PostToolUse hook |
| `default_format` | `/generate`, `/scaffold`, `/convert` |
| `css_prefix` | `/generate`, `/scaffold`, `/convert` |
| `divi_version` | `/audit` |
| `active_breakpoints` | `/generate`, `/scaffold` |
| `accessibility_level` | `/validate`, `/audit`, `divi5-accessibility` |
| `flag_composable_alternatives` | `/validate`, `/convert`, `/audit` |
| `scaffold_style` | `/scaffold` |
| `last_research` | `/research`, `divi5-researcher` |
| `learned_errors` | `divi5-error-learner` |
| `research_notes` | `divi5-researcher` |

If you ever add a new setting to the template, the [User Config Schema policy](../CLAUDE.md#user-config-schema) requires it to be consumed by at least one component — orphan keys are a bug.

---

## See Also

- [`docs/usage.md`](usage.md) — Detailed reference for every command, agent, and skill
- [`docs/workflows.md`](workflows.md) — Common multi-step scenarios
- [`docs/troubleshooting.md`](troubleshooting.md) — FAQ and common issues
- [`templates/divi5-toolkit.local.md`](../templates/divi5-toolkit.local.md) — The template file itself
