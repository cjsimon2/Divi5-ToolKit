# Usage Guide

Complete reference for every command, agent, skill, and CSS example in the Divi5 Toolkit.

- [How the Plugin Works](#how-the-plugin-works)
- [Commands](#commands)
- [Agents](#agents)
- [Skills](#skills)
- [Hooks](#hooks)
- [CSS Example Library](#css-example-library)
- [Templates](#templates)

---

## How the Plugin Works

The Divi5 Toolkit is a Claude Code plugin made of five kinds of components:

| Component | What It Is | How You Invoke It |
|---|---|---|
| **Commands** | Slash commands you run interactively | Type `/divi5-toolkit:<name>` in the chat |
| **Agents** | Autonomous subagents Claude spawns for focused tasks | Triggered automatically by hooks or by Claude when context matches |
| **Skills** | Auto-activating knowledge bundles | Loaded silently by Claude when their description matches the conversation |
| **Hooks** | Event handlers that run on specific Claude Code events | Fire automatically on `Write`/`Edit` and at session start |
| **Templates** | Files you copy into your own project | Manual: copy from `templates/` into `.claude/` |

You don't need to memorize this taxonomy — you mostly just type slash commands. The agents, skills, and hooks work behind the scenes.

---

## Commands

All commands are invoked with the `/divi5-toolkit:` namespace. Type `/divi5-toolkit:` in the Claude Code chat and your editor will autocomplete the available commands.

### `/divi5-toolkit:generate`

**Purpose:** Generate Divi 5-ready CSS for a component, section, or page element. Produces output in the format you specify.

**When to use it:**
- You need CSS for a specific UI element (button, card, hero, form, etc.)
- You want code you can paste straight into Divi without manual specificity fixes
- You're starting a new component from scratch

**Arguments:** `<component-or-element>` — describe what you want styled, in plain language.

**What it does:**
1. Asks what component you need, what style, and which output format (Theme Options, Code Module, Child Theme, or Free-Form CSS)
2. Reads `.claude/divi5-toolkit.local.md` for project preferences (prefix, breakpoints, default format)
3. Generates Divi 5-compatible CSS with proper `body` prefixes, `!important` where needed, custom classes (no numbered selectors), and fluid responsive values
4. Suggests Composable Settings alternatives where the styling could be done in the builder instead
5. Provides usage instructions: where to paste, how to add classes via Advanced > Attributes
6. Offers to validate, convert, or save the output

**Example:**
```
/divi5-toolkit:generate primary button with gold hover state
```

**Sample output (abbreviated):**
```css
/* ==========================================================================
   Primary Button — Theme Options CSS
   Paste into: Divi > Theme Options > Custom CSS
   ========================================================================== */
body .et_pb_button {
  background-color: #000000 !important;
  border-radius: 0 !important;
  letter-spacing: 4px !important;
  text-transform: uppercase !important;
  /* ... */
}
body .et_pb_button:hover {
  background-color: #b2a065 !important;
  border-color: #b2a065 !important;
}
```

**Tools used:** `Read`, `Write`, `Glob`, `Grep`, `WebSearch`, `WebFetch` (research is bounded — see "When to Research" in `commands/generate.md`)

---

### `/divi5-toolkit:validate`

**Purpose:** Deep validation of a single CSS file or block for Divi 5 compatibility. Catches button specificity issues, fragile selectors, format problems, accessibility gaps, and Composable Settings opportunities.

**When to use it:**
- You have CSS you wrote by hand and want it checked before deploying
- You hit "styles not applying" and want to know why
- You want a thorough single-file analysis (vs. `/audit` which scores the whole project)

**Arguments:** `<file-or-css>` — a file path or pasted CSS block.

**What it runs:** 14 checks, each with a P0–P3 severity:

| # | Check | Severity |
|---|---|---|
| 1 | Button specificity (body prefix + !important) | P0 |
| 2 | Numbered selector usage (`.et_pb_text_0`) | P0 |
| 3 | CSS variable scope (`:root`) | P1 |
| 4 | Missing `!important` on Divi overrides | P1 |
| 5 | Code Module `<style>` wrapper | P1 |
| 6 | Theme Options no `<style>` wrapper | P1 |
| 7 | Module Element field selectors (should be properties only) | P1 |
| 8 | Font stack fallbacks | P2 |
| 9 | Hover states on interactive elements | P2 |
| 10 | Responsive coverage (fluid values, media queries) | P2 |
| 11 | Accessibility — focus indicators | P1 (if `accessibility_level: aa+`) |
| 12 | Accessibility — reduced motion | P2 (P1 in AAA) |
| 13 | Composable Settings opportunities | P3 (skipped if `flag_composable_alternatives: false`) |
| 14 | Hardcoded colors (suggest variables) | P2 |

**Reads config from `.claude/divi5-toolkit.local.md`:**
- `validation_mode` (advisory | strict)
- `accessibility_level` (aa | aaa | off)
- `flag_composable_alternatives` (true | false)

**Example:**
```
/divi5-toolkit:validate skills/divi5-css-patterns/examples/button-variants.css
```

**Sample output:**
```
========================================
DIVI 5 COMPATIBILITY REPORT (Advisory)
========================================
CRITICAL ISSUES (must fix): 0
WARNINGS (should fix): 1
  1. Line 23: Missing :focus-visible style on .my-card
SUGGESTIONS (optional): 2
  1. Line 8: Hardcoded #2ea3f2 — consider --color-primary
  2. Line 31: clamp() would replace the @media query
Status: PASSED
========================================
```

**Note:** This command performs deep, ultrathink validation. For automatic, lightweight validation on every Write/Edit, the `divi5-validator` agent runs via the PostToolUse hook. For project-wide scoring across many files, use `/divi5-toolkit:audit`.

**Tools used:** `Read`, `Glob`, `Grep`

---

### `/divi5-toolkit:convert`

**Purpose:** Convert existing CSS (Divi 4 patterns, generic CSS, or low-specificity rules) into Divi 5-compatible format. Fixes specificity, adds proper overrides, handles format wrapping, and supports Divi 4 → Divi 5 migration.

**When to use it:**
- You're migrating from Divi 4 to Divi 5
- You inherited a child theme stylesheet that needs Divi 5 fixes
- You have CSS that was written for generic websites and needs Divi-specific overrides
- You want to re-target CSS for a different format (e.g., child theme → Theme Options)

**Arguments:** `<file-or-css>` — a file path or pasted CSS block.

**What it does:**
1. Reads project config for `default_format`, `flag_composable_alternatives`, `css_prefix`
2. Detects migration context (shortcode references, old CSS ID & Classes patterns, D4-specific selectors)
3. Applies 9 conversions:
   - Adds `body` prefix and `!important` to button overrides
   - Adds `!important` to other Divi module overrides
   - Replaces numbered selectors with custom classes
   - Hoists CSS variables to `:root`
   - Wraps in `<style>` tags or strips them as appropriate for the target format
   - Suggests fluid responsive values (`clamp()`)
   - Adds missing hover states
   - Adds accessibility additions (focus indicators, reduced-motion)
   - Flags CSS that could be replaced by Composable Settings
4. Adds a header comment with conversion changelog
5. Re-validates the output and offers to save

**Example:**
```
/divi5-toolkit:convert old-child-theme/style.css
```

**Tools used:** `Read`, `Write`, `Edit`, `Glob`, `Grep`

---

### `/divi5-toolkit:scaffold`

**Purpose:** Generate complete page section templates with CSS, responsive design, accessibility, and step-by-step builder instructions baked in.

**When to use it:**
- You want a starting point for a new section instead of writing from scratch
- You need a section that's known to work in Divi 5 with all the right hooks
- You want a builder workflow alongside the CSS (where to set Element Type, what classes to add, etc.)

**Arguments:** `<section-type>` — section name (e.g., "hero", "pricing", "FAQ"), or omit to see the menu.

**Built-in section templates:**
1. Hero (full-width, heading + CTA)
2. Feature Grid (3- or 4-column blurbs)
3. Pricing Table (2–4 tier comparison)
4. Testimonials (carousel or grid)
5. FAQ Accordion
6. CTA Banner
7. Team Grid
8. Stats Counter
9. Logo Bar
10. Contact Section
11. Footer
12. WooCommerce Product Grid (Loop Builder + CSS Grid)
13. Off-Canvas Menu (Canvas-based)
14. Popup Modal (Canvas Portal)

**Reads config from `.claude/divi5-toolkit.local.md`:**
- `scaffold_style` (light | dark | brand) — default color scheme
- `default_format` — output format default
- `css_prefix` — class prefix for generated styles
- `active_breakpoints` — which breakpoints to target

**What every scaffold includes:**
- CSS with design tokens (merged into existing `:root` if present)
- Class map: every custom class and where to apply it
- Responsive behavior with fluid values
- Accessibility checklist (semantic elements, contrast, focus, touch targets, reduced motion)
- Step-by-step builder instructions
- Interaction notes for Canvas/Portal scaffolds

**Example:**
```
/divi5-toolkit:scaffold hero
```

**Tools used:** `Read`, `Write`, `Glob`, `Grep`, `WebSearch`, `WebFetch` (bounded)

---

### `/divi5-toolkit:audit`

**Purpose:** Comprehensive whole-project CSS audit with letter-grade scoring and prioritized fix list. Goes beyond single-file validation.

**When to use it:**
- You're inheriting a Divi project and want a quick health assessment
- You're preparing for production deploy and want a final check
- You want to track CSS quality over time
- You want to find Composable Settings opportunities across the whole codebase

**Arguments:** `[directory-or-file]` — optional scope; defaults to whole project.

**Reads config from `.claude/divi5-toolkit.local.md`:**
- `accessibility_level` (aa | aaa | off)
- `flag_composable_alternatives` (true | false)
- `divi_version` — flags features only available in newer versions
- `css_prefix`

**Scoring categories:**

| Category | Weight | What It Measures |
|---|---|---|
| Divi 5 Compatibility | 40% | Button specificity, no numbered selectors, format wrapping, override !important, CSS variable scope |
| Design System Quality | 20% | Design tokens, consistent spacing, color variables, font fallbacks, BEM naming, custom prefix |
| Responsive Design | 15% | Fluid values, breakpoint alignment, fixed pixel sizes |
| Performance | 10% | Total size, duplicates, unused selectors, broad selectors, !important density |
| Accessibility | 15% | Focus styles, reduced motion, contrast, touch targets, color scheme support |

**Grade scale:** A (90–100), B (80–89), C (70–79), D (60–69), F (< 60)

**Output:** A formatted report with score, category breakdown, file-level metrics, critical issues, warnings, suggestions, quick wins, and Composable Settings opportunities.

**Example:**
```
/divi5-toolkit:audit
```

**Tools used:** `Read`, `Glob`, `Grep`, `Write`

---

### `/divi5-toolkit:research`

**Purpose:** Refresh the plugin's Divi 5 knowledge base from official and community sources. Updates skill files with new findings.

**When to use it:**
- It's been more than 7 days since the last research run (the SessionStart hook will remind you)
- A new Divi 5.x release just dropped
- You hit a Divi error the plugin doesn't recognize
- You want to verify whether a feature you remember was added or removed

**Arguments:** None.

**What it does:**
1. Reads `last_research` from `.claude/divi5-toolkit.local.md`
2. If stale (> 7 days) or you explicitly requested it, proceeds with research
3. Checks primary sources: Elegant Themes blog/help center, Divi 5 changelog, GitHub, community sites (DiviFlash, WP Zone, Quiroz.co, Pee-Aye Creative, Divi Engine, etc.)
4. Categorizes findings: CSS compatibility, new features, breaking changes, performance, accessibility, best practices
5. Updates `skills/divi5-css-patterns/SKILL.md` and `skills/divi5-compatibility/SKILL.md` with verified findings
6. Updates `last_research` in your config
7. Reports a summary

**Tools used:** `Read`, `Write`, `Edit`, `WebSearch`, `WebFetch`

**Note:** This is the only command that writes to the plugin's own knowledge files. Treat its updates as part of the plugin lifecycle.

---

## Agents

Agents are subagents Claude spawns automatically when the context matches their description, or that Claude is told to use explicitly. You don't invoke them with slash commands.

### `divi5-validator`

**Triggers when:**
- A CSS file is written or edited (via the PostToolUse hook, if `auto_validate: true` in your config)
- You explicitly ask to check CSS compatibility

**What it does:** Quick scan for the most critical Divi 5 compatibility issues:
- Missing `body` prefix + `!important` on button overrides (P0)
- Numbered selectors (P0)
- Missing `!important` on `.et_pb_*` overrides (P1)
- CSS variables defined outside `:root` (P1)

**Output:** Brief, inline report (max 5–15 lines). For clean CSS, a one-line "Compatibility Check PASSED". For issues, a focused list with line numbers and quick fixes.

**Model:** `haiku` (fast, low-cost — designed for rapid background validation)

**Reads config:**
- `validation_mode` (advisory | strict)

**When to use the agent vs. `/validate`:**
- The **agent** runs automatically and reports only critical issues — non-intrusive
- The **`/validate` command** runs the full 14-check ultrathink validation and produces a detailed report

---

### `divi5-error-learner`

**Triggers when you:**
- Paste error messages containing "Divi", "et_pb_", or "Elegant Themes"
- Describe CSS that isn't working in Divi
- Share console errors from Divi pages
- Mention "Divi error", "Divi issue", "Divi problem"
- Report styles lost after an update, cache issues, or plugin conflicts

**What it does:**
1. Classifies the error into one of 11 categories (CSS specificity, syntax, button override, cache, plugin conflict, migration, module-specific, layout/Flexbox, JavaScript, performance, unknown)
2. Ultrathinks the root cause, trigger, and pattern
3. Provides a step-by-step fix with before/after code
4. Updates the plugin's knowledge base if it's a new pattern (writes to `skills/divi5-compatibility/SKILL.md` or local config `learned_errors`)
5. Cross-references against recent Divi updates, known bugs, and known plugin conflicts

**Built-in error library covers:**
- "Property ignored due to invalid value"
- "Expected RBRACE" / "Unexpected Token"
- Styles not applying / styles lost after update
- Layout breaking on mobile
- CSS Variables not working
- Visual Builder vs. frontend differences
- Font not loading
- WooCommerce pages losing formatting
- Wordfence blocking page saves
- Transform values corrupted (Divi 5.0–5.1, fixed in 5.2)
- Box shadow hover state broken (5.0–5.1, fixed in 5.2)
- Loop page CSS missing on paginated pages (5.0–5.1, fixed in 5.2)
- Canvas/popup content not showing
- Composable Settings not appearing
- Accessibility: no focus indicators visible

**Model:** `sonnet` (deep analysis)

---

### `divi5-researcher`

**Triggers when:**
- You ask about Divi 5 updates, new features, or what's new
- The `last_research` date is more than 7 days old (the SessionStart hook reminds you, but doesn't auto-run)
- You run `/divi5-toolkit:research`
- An unknown Divi error needs background research

**What it does:** Same as the `/research` command — researches Divi 5 changes from primary and community sources, categorizes findings, and updates skill files. The agent exists so Claude can spawn it autonomously when needed (vs. requiring you to type the slash command).

**Model:** `sonnet`

---

### `divi5-accessibility`

**Triggers when:**
- You mention accessibility, WCAG, ADA, a11y, or Section 508
- CSS includes interactive elements (buttons, links, forms, toggles)
- You ask to review CSS for accessibility
- `/audit` finds accessibility issues
- You're building navigation, modals, or off-canvas menus

**What it does:** Runs 8 WCAG checks:

| # | Check | Severity |
|---|---|---|
| 1 | Focus indicators present | P0 |
| 2 | Color contrast ratios meet thresholds | P0 |
| 3 | Touch targets ≥ 44x44px | P1 |
| 4 | `prefers-reduced-motion` fallback | P1 |
| 5 | Text resize / reflow at 200% zoom | P1 |
| 6 | Link distinguishability (not color alone) | P2 |
| 7 | Semantic Element recommendations | P2 |
| 8 | Hidden content patterns (visually-hidden vs. display:none) | P2 |

**Reads config:**
- `accessibility_level` (off | aa | aaa)
  - `off` — agent skips entirely
  - `aa` (default) — WCAG 2.1 Level AA thresholds (4.5:1 contrast, 44px targets)
  - `aaa` — stricter: 7:1 contrast for normal text, ≥2px focus rings, hover-animation rules, line-height ≥ 1.5

**Output:** A structured report with critical issues, warnings, suggestions, builder recommendations (Semantic Elements to set, ARIA attributes to add via the Attributes panel), and a 1–10 score. Provides ready-to-use CSS fixes and points to `accessibility.css` example for full patterns.

**Model:** `sonnet`

---

## Skills

Skills are auto-activating knowledge bundles. You don't invoke them — Claude loads them silently when their description matches what you're working on. They give Claude context it would otherwise need to be reminded of.

### `divi5-css-patterns`

**Activates when:** Writing CSS for Divi 5, styling Divi modules (buttons, sections, rows, blurbs, toggles, forms), working with Free-Form CSS and the `selector` keyword, overriding `.et_pb_*` classes, setting up design tokens or dark mode, adding animations, styling WooCommerce, building accessible layouts, or developing a Divi child theme.

**What it provides:**
- Divi 5 architecture overview (React 18, Flexbox-first, Dynamic CSS, Composable Settings)
- All 9 CSS integration methods (Theme Options, Page-Level, Free-Form, Module Elements, Code Module, Custom HTML Wrappers, Semantic Elements, Child Theme, Attributes Panel)
- Selector specificity patterns and override templates
- Class naming conventions
- Common module selectors (Section, Row, Column, Text, Button, Image, Blurb, all 40+ modules)
- 8 new D5 modules (Group, Carousel Group, Before/After Image, Canvas Portal, Dropdown, Icon List, Link, Lottie)
- Design Variable system and Preset hierarchy
- Composable Settings overview (5.2+) — what's now possible without CSS
- Canvas system patterns (off-canvas menus, popups, mega menus)
- Loop Builder + CSS Grid patterns
- Typography, responsive (`clamp()`), layout, component, and dark mode patterns
- Performance and accessibility best practices

**Supporting files (loaded on demand):**
- `examples/button-variants.css`
- `examples/design-tokens.css`
- `examples/animations.css`
- `examples/dark-mode.css`
- `examples/woocommerce.css`
- `examples/accessibility.css`
- `references/divi-selectors.md`

---

### `divi5-compatibility`

**Activates when:** Validating CSS for Divi 5 / Divi 5.2 compatibility, checking unsupported features or units, troubleshooting Divi CSS that isn't applying, debugging plugin conflicts (WP Rocket, LiteSpeed, Wordfence, WooCommerce), migrating from Divi 4 to Divi 5, understanding breakpoints, or fixing "styles not working" issues.

**What it provides:**
- CSS unit support (dropdown vs. advanced/custom CSS)
- CSS function support (`calc`, `clamp`, `min`, `max`, `var`)
- Modern CSS feature support (CSS variables, Grid, container queries, `:has()`, nesting, cascade layers)
- 6 critical validation rules (button specificity, CSS variable scope, format wrapping, Module Element fields, numbered classes)
- Responsive breakpoint reference
- Common issues and fixes (button styles not applying, custom CSS overridden, CSS variables not working, builder vs. frontend, post-update style loss, font loading, mobile layout, hover states)
- Plugin conflict reference (cache plugins, security plugins, WooCommerce)
- Divi 4 → Divi 5 migration checklist
- Debugging techniques (DevTools, Safe Mode, Static CSS, D5 Dev Tool)
- Composable Settings compatibility table (what CSS Composable Settings replaces)
- Known Divi 5.2 bug fixes
- Error messages reference

**Supporting files (loaded on demand):**
- `references/unit-conversions.md`

---

## Hooks

Hooks are event handlers defined in `hooks/hooks.json`. They fire automatically on Claude Code events.

### `PostToolUse` (matcher: `Write|Edit`)

Fires after every file write or edit.

**What it does:**
1. Checks if the modified file is CSS-related (`*.css`, `*.scss`, `*.less`, `*.html` with `<style>`, `*.php` with inline styles). Skips non-CSS files entirely.
2. Reads `.claude/divi5-toolkit.local.md` to check `auto_validate` setting.
3. If enabled, spawns the `divi5-validator` agent for a quick critical-issue scan.
4. If the CSS contains animations, transitions, or interactive element styles, briefly checks for focus indicators and `prefers-reduced-motion` support.

**To disable:** Set `auto_validate: false` in your project config.

### `SessionStart`

Fires when a Claude Code session begins.

**What it does:**
1. Checks if `.claude/divi5-toolkit.local.md` exists.
2. Reads `last_research` — if more than 7 days old, suggests running `/divi5-toolkit:research`.
3. Reads `divi_version` — if `5.1` or lower, suggests upgrading to take advantage of Composable Settings.

**Notifications only — never auto-runs anything.**

---

## CSS Example Library

Six ready-to-use CSS files in `skills/divi5-css-patterns/examples/`. Copy any of them into your Divi project.

### `button-variants.css`

**Contains:** Primary, secondary (gold), outline, outline-white (for dark sections), large, and small button variants. Each variant uses the `body .et_pb_button.<class>` pattern with `!important` so it works in Divi.

**Use when:** You need consistent button styles across a Divi site, especially with multiple visual variants triggered by class.

**Where to paste:** Divi > Theme Options > Custom CSS

**How to apply:** Add classes like `btn-secondary`, `btn-outline`, `btn-large` to button modules via Advanced > Attributes > class.

### `design-tokens.css`

**Contains:** Complete CSS variable design system — brand colors, theme colors, text colors, typography, font sizes (xs–6xl), spacing scale (1–24), layout widths, border radius, shadows, transitions, z-index scale.

**Use when:** Starting a new Divi project and you want a consistent design system. This is the foundation that all other CSS files reference.

**Where to paste:** Divi > Theme Options > Custom CSS (paste first, before any other custom CSS)

### `animations.css`

**Contains:** 10 animation patterns — fade in on scroll, slide from left/right, scale up, staggered children, hover lift, hover glow, pulse, underline reveal, gradient shift, image zoom. All include a `prefers-reduced-motion` fallback at the bottom.

**Use when:** Adding visual polish to sections. Pair with Divi Interactions or an IntersectionObserver to add the `.is-visible` class on scroll.

**Where to paste:** Divi > Theme Options > Custom CSS

**How to apply:** Add classes like `animate-fade-in`, `hover-lift`, `animate-stagger` via Advanced > Attributes > class.

### `dark-mode.css`

**Contains:** System-aware dark mode using `prefers-color-scheme` + manual toggle via `body.dark-mode`. Includes CSS variables for surfaces, text, borders, shadows, and accents. Applies dark mode tokens to Divi sections, text, blurbs, buttons, toggles, forms, and footer. Includes a floating toggle button pattern with JavaScript.

**Use when:** You want a dark mode that respects user preference and can be manually toggled.

**Where to paste:** Divi > Theme Options > Custom CSS

### `woocommerce.css`

**Contains:** Product card grid (Loop Builder + CSS Grid), product card styling, sale badge, star rating, add-to-cart button, cart table, quantity input, checkout form, order summary, category page grid. Includes responsive adjustments and reduced-motion fallback.

**Use when:** Building a Divi + WooCommerce store and you want production-ready styling.

**Where to paste:** Divi > Theme Options > Custom CSS

### `accessibility.css`

**Contains:** Focus indicators (`:focus-visible`), skip-to-content link, visually-hidden utility, reduced-motion media query, touch target sizing, link distinguishability, high contrast mode (`forced-colors`), and print styles.

**Use when:** Every Divi project. This is the baseline accessibility CSS that Divi doesn't ship by default.

**Where to paste:** Divi > Theme Options > Custom CSS

---

## Templates

### `templates/divi5-toolkit.local.md`

**Purpose:** A configuration template you copy into your project to customize plugin behavior.

**How to use:**
1. Copy `templates/divi5-toolkit.local.md` to `.claude/divi5-toolkit.local.md` in your project root.
2. Edit any settings you want to override.
3. The plugin will read it on every command/agent run.

See [`docs/configuration.md`](configuration.md) for a full reference of every setting.

---

## See Also

- [`docs/configuration.md`](configuration.md) — Full configuration reference
- [`docs/workflows.md`](workflows.md) — Common multi-step scenarios
- [`docs/troubleshooting.md`](troubleshooting.md) — FAQ and common issues
- [`README.md`](../README.md) — Project overview, installation, changelog
- [`CLAUDE.md`](../CLAUDE.md) — Developer guidance for working ON the plugin
