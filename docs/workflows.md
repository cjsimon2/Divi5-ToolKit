# Workflows

Step-by-step guides for common multi-command scenarios.

- [First-Time Setup](#first-time-setup)
- [Build a Landing Page from Scratch](#build-a-landing-page-from-scratch)
- [Migrate a Divi 4 Child Theme to Divi 5](#migrate-a-divi-4-child-theme-to-divi-5)
- [Audit and Improve an Inherited Project](#audit-and-improve-an-inherited-project)
- [Add a Dark Mode Toggle](#add-a-dark-mode-toggle)
- [Build a WooCommerce Product Grid](#build-a-woocommerce-product-grid)
- [Add an Off-Canvas Mobile Menu](#add-an-off-canvas-mobile-menu)
- [Make a Divi Site Accessible (WCAG AA)](#make-a-divi-site-accessible-wcag-aa)
- [Debug "Styles Not Applying"](#debug-styles-not-applying)
- [Refresh the Plugin's Knowledge Base](#refresh-the-plugins-knowledge-base)

---

## First-Time Setup

You just installed the plugin. Get it configured for your project in 5 minutes.

### Step 1 — Choose how to load the plugin

The plugin has to be loaded by Claude Code before its slash commands appear. Pick one of three options:

**A) Per-session (simplest, one-off):**
```bash
cd /path/to/your-project
claude --plugin-dir "/path/to/Divi5-ToolKit/plugins/divi5-toolkit"
```
The plugin loads for that session only.

**B) Per-project (recommended for active Divi work):**

In your project root, ensure `.claude/settings.local.json` is gitignored:
```bash
mkdir -p .claude
echo ".claude/settings.local.json" >> .gitignore
echo ".claude/*.local.json" >> .gitignore
```

Then create `.claude/settings.local.json`:
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

The plugin will auto-load every time you start Claude Code in this project.

**C) Global (always loaded everywhere):**

Same JSON, but in `~/.claude/settings.json`. The plugin loads in every Claude Code session on your machine.

### Step 2 — Create the plugin's project config

This is a separate file from the Claude Code settings above. It tells the plugin commands which prefix, breakpoints, and accessibility level to use for THIS project.

```bash
cp /path/to/Divi5-ToolKit/plugins/divi5-toolkit/templates/divi5-toolkit.local.md .claude/divi5-toolkit.local.md
```

Then open `.claude/divi5-toolkit.local.md` and edit:
- `css_prefix` — change `my` to your project's short prefix (e.g., `acme`)
- `divi_version` — set to `"5.6"` if you're current
- `accessibility_level` — `aa` for most projects, `aaa` for healthcare/government
- `active_breakpoints` — leave defaults unless you need more

### Step 3 — Verify

In Claude Code, type `/divi5-toolkit:` — autocomplete should show all 8 commands (generate, validate, convert, diagnose, research, scaffold, audit, responsive).

**Verify by running:**
```
/divi5-toolkit:generate primary button
```

If you get back Divi 5-ready CSS with your prefix, the plugin is wired up correctly.

**If autocomplete doesn't show the commands**, see [`docs/troubleshooting.md` → "Slash commands don't autocomplete"](troubleshooting.md#slash-commands-dont-autocomplete).

---

## Build a Landing Page from Scratch

You're starting a new Divi page and want polished sections fast.

### Step 1 — Lay down the design system

```
/divi5-toolkit:generate design tokens
```

Or copy `skills/divi5-css-patterns/examples/design-tokens.css` directly into Divi > Theme Options > Custom CSS. This gives you CSS variables for colors, fonts, spacing, shadows, and z-index.

### Step 2 — Scaffold the hero

```
/divi5-toolkit:scaffold hero
```

Choose your color scheme when prompted (or set `scaffold_style` in config to skip the prompt). Follow the builder instructions to recreate the section in Divi.

### Step 3 — Add supporting sections

```
/divi5-toolkit:scaffold feature-grid
/divi5-toolkit:scaffold testimonials
/divi5-toolkit:scaffold pricing
/divi5-toolkit:scaffold faq
/divi5-toolkit:scaffold cta-banner
```

Each scaffold gives you CSS, a class map, builder steps, and an accessibility checklist.

### Step 4 — Drop in the accessibility baseline

Copy `skills/divi5-css-patterns/examples/accessibility.css` into Theme Options. This adds focus indicators, skip links, reduced-motion handling, and high-contrast mode support.

### Step 5 — Validate everything

```
/divi5-toolkit:audit
```

Confirm you're at grade A or B before publishing.

---

## Migrate a Divi 4 Child Theme to Divi 5

You have an existing Divi 4 child theme and need to bring it forward.

### Step 1 — Update the plugin's target version

In `.claude/divi5-toolkit.local.md`:
```yaml
divi_version: "5.6"
```

### Step 2 — Convert the existing CSS file

```
/divi5-toolkit:convert child-theme/style.css
```

The converter will:
- Detect Divi 4 patterns (shortcode references, old class structures)
- Add `body` prefix and `!important` to button overrides
- Add `!important` to `.et_pb_*` overrides
- Replace numbered selectors with custom classes
- Hoist CSS variables to `:root`
- Suggest fluid responsive values
- Add focus indicators and reduced-motion if missing
- Flag CSS that could be replaced by Composable Settings

### Step 3 — Validate the converted output

```
/divi5-toolkit:validate child-theme/style.css
```

Check for any remaining warnings.

### Step 4 — Audit the whole project

```
/divi5-toolkit:audit
```

Get the project-wide score and prioritized fix list.

### Step 5 — Test in Divi

1. Clear Divi's Static CSS cache: Divi > Theme Options > Builder > Advanced > Static CSS > Clear
2. Test in Safe Mode to rule out plugin conflicts: Divi > Support Center > Safe Mode
3. Inspect new HTML structure in DevTools — Divi 5 emits different markup than Divi 4
4. Visit every page that previously had custom styles and verify they still render

### Step 6 — Address D4 modules

Any pages still containing Divi 4 modules will load the entire D4 framework (performance hit). Either re-build those pages with D5 modules or accept the tradeoff. The plugin can scaffold D5 replacements for common D4 patterns — try `/divi5-toolkit:scaffold` for the section types you need.

---

## Audit and Improve an Inherited Project

You just took over a Divi project. You don't know what state it's in.

### Step 1 — Run the audit

```
/divi5-toolkit:audit
```

You'll get a graded report (A–F) with category breakdown, file-level metrics, critical issues, warnings, suggestions, quick wins, and Composable Settings opportunities.

### Step 2 — Read the Quick Wins

The audit report has a "Quick Wins" section — highest impact, lowest effort. Start there.

### Step 3 — Auto-fix critical issues

```
/divi5-toolkit:convert path/to/worst-offender.css
```

Run on each file flagged with critical issues. The converter handles the mechanical fixes.

### Step 4 — Add design tokens if missing

If the audit flagged "no design tokens" or many hardcoded colors, generate a token set:

```
/divi5-toolkit:generate design tokens for this project
```

The plugin can analyze the existing CSS and propose tokens that match the colors actually in use.

### Step 5 — Address accessibility gaps

If Category E (Accessibility) scored low, run the accessibility agent on the worst files. Or just drop in `accessibility.css` from the example library — it covers the baseline.

### Step 6 — Re-audit

```
/divi5-toolkit:audit
```

Track score improvement over time. Aim for grade A or B before considering the project healthy.

---

## Add a Dark Mode Toggle

You want a system-aware dark mode that users can also toggle manually.

### Step 1 — Copy the dark-mode example

Open `skills/divi5-css-patterns/examples/dark-mode.css` and paste the full contents into Divi > Theme Options > Custom CSS.

### Step 2 — Customize the tokens

The example uses generic colors. Override the `--dm-bg-primary`, `--dm-text-primary`, etc. variables to match your brand.

### Step 3 — Add the toggle button

The example file includes a JavaScript snippet for a floating toggle button at the bottom (in a comment block). Copy that snippet into a Code Module on every page where you want the toggle (or in a global header).

### Step 4 — Test

- Toggle your OS to dark mode and reload — the site should switch automatically.
- Click the toggle button — it should override the OS preference and persist via `localStorage`.
- Toggle back — it should remember.

### Step 5 — Verify accessibility

The dark mode tokens should still meet WCAG 2.1 AA contrast (4.5:1 for normal text). Run:

```
/divi5-toolkit:validate (paste the dark mode CSS)
```

Check 2 (color contrast) will catch any contrast failures in the dark color combinations.

---

## Build a WooCommerce Product Grid

You have a WooCommerce store on Divi 5 and want a custom product grid layout.

### Step 1 — Scaffold the grid

```
/divi5-toolkit:scaffold woocommerce-product-grid
```

This generates CSS using Divi 5's Loop Builder + CSS Grid combination.

### Step 2 — Build the loop in Divi

The scaffold includes builder instructions:
1. Add a Loop Builder module on your category page
2. Set the loop source to WooCommerce Products
3. Design the loop item template using Divi modules (Image, Heading, Text, Button)
4. Add the custom classes from the scaffold's class map via Advanced > Attributes > class

### Step 3 — Add the WooCommerce styling baseline

Paste `skills/divi5-css-patterns/examples/woocommerce.css` into Theme Options. This styles cart, checkout, product cards, and category pages consistently.

### Step 4 — Disable Dynamic CSS for Woo pages

WooCommerce pages can lose styling because Divi's Dynamic CSS only caches one layout state per page. Go to Divi > Theme Options > Performance and disable Dynamic CSS for your shop, cart, and checkout pages.

### Step 5 — Test on mobile

The scaffold includes responsive breakpoints. Verify the grid collapses to 2 columns on tablet, 1 column on phone (or your preferred layout).

---

## Add an Off-Canvas Mobile Menu

You want a slide-out menu on mobile, built with Divi 5's Canvas system.

### Step 1 — Scaffold the off-canvas pattern

```
/divi5-toolkit:scaffold off-canvas-menu
```

The scaffold gives you CSS, builder instructions, and a Canvas + Interaction Builder workflow.

### Step 2 — Create a global Canvas in Divi

In Divi 5's Visual Builder:
1. Open the canvas dropdown (top of the builder)
2. Create a new canvas, mark it as "Global"
3. Name it "Mobile Menu"
4. Build your menu sections inside the canvas

### Step 3 — Add an Interaction trigger

1. Open your main canvas (the page)
2. Add a hamburger button (or use a custom Code Module with an icon)
3. Open the Interaction Builder
4. Add an interaction with trigger "Click" → action "Toggle Class on Element" → target "Mobile Menu" canvas → class `is-open`

### Step 4 — Add the CSS class via Attributes

On the off-canvas section, add the class from the scaffold (e.g., `my-offcanvas-menu`) via Advanced > Attributes > class.

### Step 5 — Test on mobile

Tap the hamburger — the menu should slide in from the left. Tap outside or the close button — it should slide back. Verify keyboard navigation works.

---

## Make a Divi Site Accessible (WCAG AA)

You need to bring an existing Divi site up to WCAG 2.1 AA compliance.

### Step 1 — Set the accessibility level in config

```yaml
accessibility_level: aa
```

(Or `aaa` if you have stricter requirements.)

### Step 2 — Run the accessibility agent on your CSS

Tell Claude:
> "Review my Divi CSS for accessibility issues."

The `divi5-accessibility` agent will run 8 WCAG checks and produce a structured report.

### Step 3 — Drop in the accessibility baseline

Copy `skills/divi5-css-patterns/examples/accessibility.css` into Theme Options. This covers:
- `:focus-visible` indicators (Divi removes default outlines)
- Skip-to-content link
- Visually-hidden utility for screen reader content
- `prefers-reduced-motion` global rule
- 44x44px minimum touch targets on buttons, social icons, nav links
- Link distinguishability (underlines on body links)
- High-contrast mode (`forced-colors`)
- Print stylesheet

### Step 4 — Set Semantic Elements

In Divi 5, you can change any element's HTML tag without code:
1. Select your nav section → Advanced > HTML > Element Type → `<nav>`
2. Header section → `<header>`
3. Main content section → `<main>`
4. Footer section → `<footer>`
5. Sidebar section → `<aside>`

The `divi5-accessibility` agent will recommend specific elements based on your class names.

### Step 5 — Add ARIA attributes via the Attributes panel

For interactive elements that need them (buttons with icons only, complex toggles, etc.):
1. Select the element → Advanced > Attributes
2. Add Name: `aria-label`, Value: a descriptive label

### Step 6 — Run the audit to verify

```
/divi5-toolkit:audit
```

Check that Category E (Accessibility) scores high. Address any remaining issues until you're at grade A or B.

### Step 7 — Test with real assistive tech

Automated checks catch most issues but not all. Manual tests:
- Tab through every page using only the keyboard. Every interactive element must be reachable and have a visible focus indicator.
- Run a screen reader (VoiceOver on Mac, NVDA on Windows) on the homepage and a content page.
- Zoom to 200% — content should reflow without horizontal scroll.

---

## Debug "Styles Not Applying"

Your custom CSS isn't showing up in Divi.

### Step 1 — Hand the symptom to the error-learner

Tell Claude:
> "My custom CSS isn't applying in Divi. Here's the rule: `.my-card { background: red; }` and the HTML on the page is `<div class='et_pb_blurb my-card'>...</div>`."

The `divi5-error-learner` agent will classify the issue and walk through likely causes.

### Step 2 — Validate the CSS

```
/divi5-toolkit:validate (paste the rule)
```

Common causes the validator catches:
- Missing `body` prefix on button overrides (fix: `body .et_pb_button`)
- Missing `!important` on Divi module overrides
- CSS variable defined outside `:root`
- Selectors in a Module Element field that should be in Free-Form CSS instead
- Code Module CSS not wrapped in `<style>` tags

### Step 3 — Check the cache

If the validator says the CSS is fine, the issue is probably cache:
1. **Divi Static CSS:** Divi > Theme Options > Builder > Advanced > Static CSS > Clear
2. **Server cache:** WP Rocket, LiteSpeed, Cloudflare — clear all of them
3. **Browser cache:** Hard reload (Cmd+Shift+R / Ctrl+Shift+R) or test in incognito

### Step 4 — Use DevTools

1. Open DevTools on the affected page
2. Inspect the element you're trying to style
3. Look at the Computed tab — what's the actual final value?
4. Look at the Styles tab — is your rule there but struck through? Then it's being overridden. Look up the cascade to find the winner.

### Step 5 — Try Safe Mode

Divi > Support Center > Safe Mode disables third-party plugins and child theme code. If the issue disappears in Safe Mode, a plugin or child theme is interfering.

### Step 6 — Check plugin conflicts

Common offenders:
- **WP Rocket RUCSS** — strips "unused" CSS that Divi needs. Add Divi selectors to the safelist.
- **LiteSpeed Cache** — may show unstyled HTML initially. Whitelist `admin-ajax.php` in ModSecurity.
- **Wordfence** — firewall blocks Divi AJAX. Enable Learning Mode during Divi updates.

The `divi5-error-learner` agent has the full plugin conflict reference.

---

## Audit Site Performance (Core Web Vitals)

Goal: get a Divi site to "Good" Core Web Vitals — LCP < 2.5s, INP < 200ms, CLS < 0.1.

### Step 1 — Run Lighthouse on the target page

Open the page in Chrome → DevTools → Lighthouse → Mobile → Performance → Analyze. Save or screenshot the report. The synthetic metrics + opportunity list become the agent's input.

If you want real-user data (which is what Google uses for ranking), check Google Search Console → Core Web Vitals report after 28 days of traffic.

### Step 2 — Hand the report to the performance agent

In Claude Code:

```
The Lighthouse report on my homepage shows:
- LCP 4.2s (image at /wp-content/uploads/hero.jpg)
- INP 320ms (slowest interaction: menu open)
- CLS 0.18
Render-blocking CSS: style.css (12KB)
What should I fix first?
```

The `divi5-performance` agent activates automatically. It returns a P0/P1/P2 list, identifies the LCP element, checks for the Divi performance pipeline (Dynamic CSS / Critical CSS / Inline Stylesheets), and recommends a fix order with estimated impact.

### Step 3 — Apply the high-impact fixes first

Typical P0 fixes on Divi sites:

1. **Self-host fonts** — copy `font-loading.css` from `skills/divi5-performance/examples/` to Theme Options Custom CSS. Download WOFF2 files, upload to `/wp-content/fonts/`. Disable Google Fonts in Divi.
2. **Preload the LCP image** — add `<link rel="preload" as="image" href="..." fetchpriority="high">` to Theme Builder header HTML.
3. **Set `fetchpriority="high"` + `loading="eager"`** on the hero Image Module via Advanced > Attributes.
4. **Enable Divi's full performance pipeline** — Theme Options → Builder → Advanced → Performance → enable Dynamic CSS, Critical CSS, Inline Stylesheets, Defer Generated CSS, Defer jQuery.

### Step 4 — Eliminate CLS with Aspect Ratio (Divi 5.5+)

In every Image Module: Design tab → Sizing → Aspect Ratio. Pick the ratio that matches the source image. Browser reserves space before the image loads — no shift on paint.

For web fonts: confirm the `@font-face` declarations include `size-adjust`, `ascent-override`, `descent-override` (see `font-loading.css`).

For dynamically inserted content (cookie banners, ads): reserve space with `min-height` or `aspect-ratio`.

### Step 5 — Audit cache plugin compatibility

If you have WP Rocket, LiteSpeed Cache, Autoptimize, or Perfmatters installed, ask the performance agent to cross-check its settings against the compatibility matrix in `skills/divi5-performance/SKILL.md`. The most common silent breakage: WP Rocket's Remove Unused CSS strips Divi's Dynamic CSS unless `.et_pb_*` and `/et-cache/` are safelisted.

### Step 6 — Re-run Lighthouse

Clear all caches (Divi Static CSS, page cache plugin, browser hard refresh). Re-run Lighthouse. The fixes should be visible in the same metrics. If LCP is still > 2.5s, the agent will identify what's left.

### Step 7 — Monitor field data

Lighthouse is lab data. Real users may have a different experience. After fixes ship, watch Search Console's Core Web Vitals report for 28 days. Field data is what Google uses for ranking.

---

## Diagnose a Symptom

Goal: you have a Divi problem but aren't sure which command to use. Hand it to `/divi5-toolkit:diagnose` and let the router decide.

### Step 1 — Describe the symptom

In Claude Code, run:

```
/divi5-toolkit:diagnose my button color won't change even though I added !important
```

Or paste an error message:

```
/divi5-toolkit:diagnose
Uncaught TypeError: Cannot read property 'classList' of null
  at et_pb_section_video.js:142
```

Or point at a file:

```
/divi5-toolkit:diagnose style.css
```

### Step 2 — Read the routed response

The diagnose command classifies the input (CSS not applying, error message, performance, accessibility, builder behavior, migration, plugin conflict) and routes to the matching specialist. You get back a structured response:

- **SYMPTOM** — restated
- **ROOT CAUSE** — the underlying reason
- **WHY IT HAPPENS** — technical mechanism
- **FIX** — concrete code with paste location
- **VERIFY** — how to confirm the fix worked
- **RELATED** — links to deeper documentation
- **PREVENT** — how to avoid this class of problem

### Step 3 — Apply the fix and verify

Paste the fix into the indicated location. Clear caches (Divi Static CSS + browser hard refresh). Confirm via DevTools or the VERIFY steps.

### Step 4 — Optional follow-up

The diagnose command offers next actions: auto-fix the full file with `/convert`, run a full file `/validate`, run a project-wide `/audit`, or add a novel error pattern to the error-learner library.

---

## Refresh the Plugin's Knowledge Base

Divi releases new versions frequently. Keep the plugin's knowledge current.

### Step 1 — Run the research command

```
/divi5-toolkit:research
```

The `divi5-researcher` agent will:
1. Check `last_research` — if more than 7 days old, proceed
2. Fetch from official sources: Elegant Themes blog, help center, Divi 5 changelog, GitHub
3. Fetch from community sources: DiviFlash, WP Zone, Quiroz.co, Pee-Aye Creative, Divi Engine
4. Categorize findings: CSS compatibility, new features, breaking changes, performance, accessibility
5. Update `skills/divi5-css-patterns/SKILL.md` and `skills/divi5-compatibility/SKILL.md`
6. Update `last_research` in your config
7. Print a summary

### Step 2 — Review the summary

The research report tells you what changed. If there are new modules, breaking changes, or new bug fixes, those will be in the summary.

### Step 3 — Bump `divi_version` if needed

If a new Divi version came out and you're now targeting it, update your config:

```yaml
divi_version: "5.3"
```

### Step 4 — Re-validate your existing CSS

```
/divi5-toolkit:audit
```

Some fixes that were "warnings" might now be "info" (or vice versa) based on the updated knowledge.

---

## Check a Page Across Device Sizes

Goal: confirm a page actually works on phones, tablets, laptops, and large monitors before (or after) launch — not just that the CSS "has media queries."

### Step 1 — (Optional but recommended) Connect a browser MCP server

Live testing needs browser automation. Add one of these to your project's `.mcp.json` (see the README's **Optional MCP Servers** section):

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

or Chrome DevTools MCP: `"args": ["-y", "chrome-devtools-mcp@latest"]`. Restart Claude Code after adding it. Without a browser server the command still runs — it falls back to static CSS analysis.

### Step 2 — Run the check

Against a live page (local or staging):

```
/divi5-toolkit:responsive https://staging.example.com/landing
```

Or against CSS only:

```
/divi5-toolkit:responsive css/custom.css
```

### Step 3 — Read the device matrix

Live mode resizes through 9 viewports — 360×800 (small Android), 390×844 (iPhone 14/15), 430×932 (Pro Max), 844×390 (phone landscape), 810×1080 (iPad portrait), 1024×768 (iPad landscape), 1366×768 (laptop), 1920×1080 (widescreen), 2560×1440 (ultrawide) — screenshotting each and probing for horizontal overflow, broken column stacking, unusable navigation, undersized touch targets, and illegible text. Static mode reports *risk patterns* instead (fixed widths without guards, `100vw`/`100vh` traps, vw-only font sizes, misaligned media queries).

You get a PASS/issue line per device, then P0 (broken) / P1 (degraded) / P2 (risk) findings with concrete fixes and paste locations.

### Step 4 — Apply fixes and re-run

Apply the fixes (or take the builder-native route when one is offered — per-breakpoint settings, 5.5 Aspect Ratio). Clear Divi's Static CSS cache, then re-run the same command and confirm the matrix goes green.

### Step 5 — Optional follow-ups

- `/divi5-toolkit:validate` on any CSS you changed
- `/divi5-toolkit:audit` to see Category C (Responsive Design) score improve
- The `divi5-performance` agent if mobile rendering is slow rather than broken

---

## See Also

- [`docs/usage.md`](usage.md) — Detailed reference for every command, agent, and skill
- [`docs/configuration.md`](configuration.md) — Full configuration reference
- [`docs/troubleshooting.md`](troubleshooting.md) — FAQ and common issues
