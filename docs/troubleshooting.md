# Troubleshooting

Common issues with the Divi5 Toolkit plugin and Divi 5 itself, with diagnostic steps and fixes.

- [Plugin Issues](#plugin-issues)
- [Divi 5 CSS Issues](#divi-5-css-issues)
- [Divi 5 Builder Issues](#divi-5-builder-issues)
- [Plugin Conflicts](#plugin-conflicts)
- [Migration Issues](#migration-issues)
- [Performance Issues](#performance-issues)
- [Accessibility Issues](#accessibility-issues)
- [FAQ](#faq)

---

## Plugin Issues

These are issues with the Divi5 Toolkit Claude Code plugin itself.

### Slash commands don't autocomplete

**Symptom:** Typing `/divi5-toolkit:` in Claude Code shows nothing.

**Likely causes:**
1. Plugin not loaded for this session
2. Plugin path is wrong
3. `plugin.json` is invalid
4. `marketplace.json` missing or invalid (only matters if you're using the marketplace approach)
5. `extraKnownMarketplaces` / `enabledPlugins` not configured (only matters if you're using the marketplace approach)

**Diagnosis tree:**

**If you're using `--plugin-dir` (per-session loading):**
1. Verify you actually passed the flag when starting Claude Code:
   ```bash
   claude --plugin-dir "/path/to/Divi5-ToolKit/plugins/divi5-toolkit"
   ```
2. Confirm the path contains a `.claude-plugin/plugin.json` file at its root.
3. Validate `plugin.json` is well-formed JSON (no trailing commas, all strings quoted).

**If you're using the marketplace approach (`.claude/settings.local.json` or `~/.claude/settings.json`):**
1. Confirm `marketplace.json` exists at the plugin root. Without it, the directory cannot act as a marketplace.
   ```bash
   ls /path/to/Divi5-ToolKit/marketplace.json
   ```
   If missing, you're on a plugin version older than v2.1.3 — `git pull` to update.
2. Confirm both `extraKnownMarketplaces` and `enabledPlugins` are in your settings file. Both are required:
   ```json
   {
     "extraKnownMarketplaces": {
       "divi5-local": {
         "source": { "source": "directory", "path": "/absolute/path/to/Divi5-ToolKit" }
       }
     },
     "enabledPlugins": {
       "divi5-toolkit@divi5-local": true
     }
   }
   ```
3. The marketplace name (`divi5-local` above) must appear in BOTH `extraKnownMarketplaces` (as the key) AND `enabledPlugins` (after the `@`). They must match exactly.
4. The plugin name before the `@` (`divi5-toolkit`) must match the `name` field in `marketplace.json` and `.claude-plugin/plugin.json`.
5. The `path` MUST be an absolute path. Relative paths and `~` are not expanded.
6. Validate the JSON parses:
   ```bash
   python3 -m json.tool .claude/settings.local.json
   ```
7. Restart Claude Code after editing settings — changes don't apply mid-session.
8. On first load of a new marketplace, Claude Code may prompt for trust confirmation. Approve it and restart.

### Config file isn't being read

**Symptom:** You set `validation_mode: strict` but commands still run in advisory mode.

**Likely causes:**
1. Config file is in the wrong location
2. YAML frontmatter is malformed
3. Indentation is wrong

**Fix:**
1. The config file MUST be at `.claude/divi5-toolkit.local.md` in your project root (not in the plugin directory).
2. Confirm the file starts with `---`, has YAML frontmatter, ends with `---`, and uses 2-space indentation (no tabs).
3. Run `/divi5-toolkit:validate` and look for "Validation Mode: ..." in the output. If it shows the wrong mode, re-check your file.

### Auto-validation runs on every file, even non-CSS files

**Symptom:** Editing a `.md` or `.json` file triggers a validation report you didn't expect.

**Likely cause:** You're on plugin version 2.0.0 or earlier, before CSS-only file filtering was added in v2.1.0.

**Fix:** Update the plugin (`git pull` in the plugin directory and restart Claude Code).

### Skill descriptions don't seem to trigger

**Symptom:** You're working on Divi CSS but the skills don't seem to be activating.

**Likely cause:** Skills auto-activate based on their description matching the conversation. If your initial prompt is generic ("style this button"), Claude may not realize it's Divi-specific.

**Fix:** Mention "Divi" or "Divi 5" explicitly in your first message: "Style this Divi 5 button..." This gives Claude the trigger word the skill descriptions look for.

### The accessibility agent isn't triggering

**Symptom:** You're writing interactive CSS but `divi5-accessibility` never fires.

**Likely causes:**
1. `accessibility_level: off` in your config (the agent skips entirely)
2. Your prompt doesn't contain accessibility keywords

**Fix:**
1. Check `.claude/divi5-toolkit.local.md` for `accessibility_level`. Set to `aa` or `aaa` (or remove the key — default is `aa`).
2. If you want to invoke it explicitly, just ask: "Run the accessibility agent on this CSS."

### `/research` says my knowledge is current but I know it's not

**Symptom:** You ran `/divi5-toolkit:research` 8 days ago, the `divi5-researcher` agent still claims your knowledge is current, and you suspect `last_research` is stale.

**Likely cause:** The `last_research` key in your config wasn't updated automatically (maybe an interrupted previous run).

**Fix:** Manually update `.claude/divi5-toolkit.local.md`:
```yaml
last_research: 2026-04-12   # update to today
```
Then re-run `/divi5-toolkit:research` to actually do the research.

---

## Divi 5 CSS Issues

### Button styles aren't applying

**Symptom:** You wrote `.et_pb_button { background-color: black; }` and it's ignored.

**Cause:** Divi applies button styles inline, so simple selectors lose the specificity battle.

**Fix:** Use the body prefix and `!important` on every property:
```css
body .et_pb_button {
  background-color: black !important;
  color: white !important;
  border-color: black !important;
}
body .et_pb_button:hover {
  background-color: #222 !important;
}
```

### CSS variables aren't working

**Symptom:** You defined `--my-color: red;` and `var(--my-color)` shows nothing.

**Cause:** The variable was defined in a non-`:root` selector and isn't visible in the scope where you're using it.

**Fix:** Define all global variables in `:root`:
```css
:root {
  --my-color: red;
}
.something {
  color: var(--my-color);
}
```

### Custom CSS overridden by Divi

**Symptom:** Your styles appear struck-through in DevTools.

**Cause:** Divi's `cached-inline-styles` loads after child theme stylesheets, so child theme CSS loses the cascade.

**Fix:** Move the CSS to Divi > Theme Options > Custom CSS (loads later in the cascade), or increase selector specificity, or use `!important`.

### Styles lost after Divi update

**Symptom:** Your custom CSS disappears after Divi auto-updates.

**Cause:** Static CSS cache is stale.

**Fix:**
1. Divi > Theme Options > Builder > Advanced > Static CSS > Clear
2. During active development, disable Static CSS entirely

### Property ignored due to invalid value

**Symptom:** Console shows "Property ignored due to invalid value" for one of your declarations.

**Causes:**
- You used a unit not supported by the builder dropdown (e.g., `ch`, `dvh`, `lvh`)
- Syntax error in the value
- Value is in the wrong format for the property

**Fix:**
- For unit issues, switch to advanced/freeform input mode in the builder, or use custom CSS instead of a builder field
- For syntax issues, run `/divi5-toolkit:validate` to catch the error
- For format issues, double-check the property's accepted values on MDN

### Expected RBRACE / Unexpected token

**Symptom:** Console shows "Expected RBRACE" or "Unexpected token" referencing your CSS.

**Causes:**
- Missing closing `}`
- You pasted a full CSS ruleset (with selectors and braces) into a Module Element field that only accepts properties

**Fix:**
- Module Element fields (Title, Body, Button, Main Element, Before, After) only accept `property: value;` declarations — no selectors
- For full rulesets with selectors, use **Free-Form CSS** with the `selector` keyword instead

### Layout breaking on mobile

**Symptom:** Elements stack or overflow on mobile that don't on desktop.

**Cause:** Divi 5 uses Flexbox by default and your custom CSS may be conflicting.

**Fix:** Either work with Divi's Flexbox controls in the builder, or override completely:
```css
.et_pb_row {
  display: flex !important;
  flex-direction: row !important;
  flex-wrap: wrap !important;
  gap: 2rem !important;
}
@media (max-width: 767px) {
  .et_pb_row {
    flex-direction: column !important;
  }
}
```

### Hover states ignored

**Symptom:** Your `:hover` styles don't apply.

**Cause:** Divi's inline styles override yours.

**Fix:** Add `body` prefix and `!important`:
```css
body .et_pb_button:hover {
  background-color: #222 !important;
}
```

### Numbered selectors break when modules are reordered

**Symptom:** You styled `.et_pb_text_0` and after rearranging the page, the wrong text module is now styled.

**Cause:** Divi auto-numbers modules in order. Reordering them shifts the numbers.

**Fix:** Stop using numbered selectors. Add a custom class via Advanced > Attributes > class, then target that:
```css
/* BAD */
.et_pb_text_0 { color: red; }

/* GOOD */
.my-intro-text { color: red; }
```

---

## Divi 5 Builder Issues

### Visual Builder looks different from frontend

**Symptom:** Your styles look correct in the Visual Builder but wrong on the live page.

**Cause:** The Visual Builder renders inside an iframe with a different CSS context. Some styles that work in the iframe don't work in the real DOM, and vice versa.

**Fix:** Always test on the frontend. Use Safe Mode (Divi > Support Center > Safe Mode) to isolate plugin or child theme conflicts.

### Builder is slow / locks up

**Symptom:** Visual Builder takes ages to load or freezes when editing.

**Common causes:**
1. The page contains Divi 4 modules — Divi 5 falls back to the full D4 framework for backward compatibility, which is slow
2. Many performance options enabled simultaneously (Static CSS + Critical CSS + Dynamic CSS + RUCSS)
3. Complex Loop Builder queries

**Fix:**
1. Check the Modules panel for any "Legacy" indicators. Replace D4 modules with D5 equivalents
2. During development, disable performance options in Divi > Theme Options > Performance
3. Simplify Loop Builder queries or paginate

### Composable Settings option not appearing

**Symptom:** You're on Divi 5.2+ but the Compose Settings icon isn't showing on a sub-element.

**Causes:**
1. You haven't selected a specific sub-element (you're at the module level)
2. The element doesn't support that particular design option even via Composable Settings

**Fix:**
1. Click directly on the sub-element (title, button, image, etc.) within the module
2. Look for the Compose Settings icon in the settings panel

### Right-click is disabled in the Visual Builder

**Symptom:** You can't right-click to inspect elements in the Visual Builder.

**Cause:** Divi disables right-click inside the builder iframe.

**Fix:** Hover over the WordPress admin bar at the top — that area allows right-click. Click "Inspect" from there to open DevTools.

### Loop Builder posts not showing or showing wrong posts

**Symptom:** The Loop Builder module renders no posts, or shows posts from the wrong category/status.

**Common causes:**
1. The query's post type doesn't match the post type you published (e.g., `post` vs. a custom post type slug)
2. `posts_per_page` is set to `-1` — this disables pagination and can time out on large post sets
3. Custom fields used in the query template aren't registered for the queried post type

**Fix:**
1. Open the Loop Builder settings → Query tab. Verify Post Type, Status (`publish`), and any taxonomy filters match your posts
2. Set `posts_per_page` to a finite value (12 is a safe default); enable Divi's built-in pagination
3. Confirm custom field keys match the `meta_key` registered via `register_post_meta()` or ACF

### Loop Builder CSS doesn't apply inside the loop template

**Symptom:** CSS you wrote for Loop Builder card layout applies in the main page context but not inside the loop output.

**Cause:** The Loop Builder renders each post in a separate sub-context; the module wrapper class (`.et_pb_loop_item`) may differ from what you're targeting.

**Fix:** Target the loop item wrapper explicitly:
```css
.et_pb_loop_item .my-card { ... }
```
Use `/divi5-toolkit:generate` with "loop builder card" as the prompt to get a correctly-scoped template, or copy from `skills/divi5-css-patterns/examples/loop-builder.css`.

### New Divi 5.6 module styles not applying (Timeline, Breadcrumbs, SVG, TOC, Instagram Feed)

**Symptom:** Custom CSS targeting a Timeline, Breadcrumbs, SVG, Table of Contents, or Instagram Feed module has no effect.

**Cause:** The five new modules added in Divi 5.6 use different wrapper classes than older D5 modules; generic selectors like `.et_pb_module` may not reach their inner elements.

**Fix:**
- Use the module-specific class as the outermost selector (e.g., `.et_pb_timeline`, `.et_pb_breadcrumbs`, `.et_pb_svg`, `.et_pb_toc`, `.et_pb_instagram_feed`)
- For SVG color control, use `currentColor` so the SVG inherits your text color: the plugin's `new-modules.css` example demonstrates the pattern
- Run `/divi5-toolkit:generate` and specify the module name — the plugin knows the 5.6 selectors
- Reference: `skills/divi5-css-patterns/examples/new-modules.css`

### New 5.8–5.11 module styles not applying (Tooltip, Post Filter, Charts, Gravity Forms, Payment Button)

**Symptom:** Custom CSS targeting one of the newer modules (Tooltip, Post Filter, Charts, Gravity Forms, Imagely Gallery, Payment Button) has no effect.

**Fix:**
- Verify the wrapper class in DevTools first — these modules are new and their markup may still be evolving between weekly releases
- Gravity Forms: the Divi module wraps standard GF markup, so scope GF's stable classes under the module: `.et_pb_gravity_forms .gform_wrapper .gfield input { ... }`
- Charts: series colors and data styling are set in the module's tabular data editor, not CSS — keep CSS to container layout
- Payment Button: shares Button design parity, so the `body .et_pb_button` override pattern applies
- Most of these modules have full design controls — check the builder before writing CSS
- Reference: `skills/divi5-css-patterns/examples/new-modules.css` and `references/divi-selectors.md`

### Styles intermittently disappear, then reappear after a cache clear

**Symptom:** A page that looked fine loses some or all of its Divi styling at random (often reported as "styles vanished overnight"), and clearing caches brings it back.

**Cause:** Cache bugs in the Dynamic CSS pipeline present before Divi 5.8/5.9 could serve pages with missing generated styles.

**Fix:**
1. Update to Divi 5.9 or later — multiple cache-related fixes landed in 5.8 and 5.9
2. Clear Static CSS (Divi > Theme Options > Builder > Advanced > Static CSS > Clear) and your cache plugin after updating
3. If it persists on 5.9+, run `/divi5-toolkit:diagnose` with the symptom

### CSS linter flags valid nested CSS in Free-Form fields

**Symptom:** The Visual Builder's CSS linter shows errors on nested selectors written without `&` in Free-Form CSS or CodeMirror fields, but the CSS works on the frontend.

**Cause:** A linter bug — false positives on browser-native CSS nesting. Fixed in Divi 5.8.

**Fix:** Update to Divi 5.8+. The CSS itself was always valid; no rewrite needed.

### WooCommerce Shop page broken in Theme Builder after WooCommerce 11.0

**Symptom:** The Theme Builder Shop template renders incorrectly after updating WooCommerce to 11.0.

**Cause:** Divi compatibility gap with WooCommerce 11.0's Shop rendering, fixed in Divi 5.11.

**Fix:** Update to Divi 5.11+. If you can't update, roll WooCommerce back below 11.0 until you can.

### Contact Form 7 Styler fields look unstyled

**Symptom:** Contact Form 7 fields inside a Divi page ignore your custom CSS after upgrading to Divi 5.3+.

**Cause:** Divi 5.3 added a native Contact Form 7 Styler module. If you're targeting CF7 field classes directly (`.wpcf7-form input`), those styles may lose to the Styler's inline output.

**Fix:**
1. Open the CF7 Styler module in the Visual Builder and set field styles through the builder — no custom CSS needed for standard field properties
2. For properties not exposed by the Styler, use the body prefix to win specificity: `body .wpcf7-form input { ... }`
3. For pseudo-class states (`:focus`, `:checked`), use Divi 5.3's built-in pseudo-class editing tabs in the builder instead of custom CSS
4. Reference: `skills/divi5-css-patterns/examples/forms.css`

---

## Plugin Conflicts

### WP Rocket RUCSS strips Divi styles

**Symptom:** Site looks unstyled or partially styled, especially on first load. Going away after a hard refresh.

**Cause:** Remove Unused CSS (RUCSS) is stripping Divi selectors it thinks aren't being used.

**Fix:**
1. Add Divi selectors to the WP Rocket CSS Safelist: `et_pb_*`, `et-fb-*`, `et_*`
2. Or, disable RUCSS entirely on Divi pages
3. Note: Divi auto-disables Dynamic CSS when RUCSS is active, so you can't use both

### LiteSpeed Cache shows unstyled HTML

**Symptom:** First page load shows raw HTML before styling kicks in.

**Cause:** LiteSpeed is serving a stale, partial cache.

**Fix:**
1. Whitelist `admin-ajax.php` in ModSecurity
2. Clear LiteSpeed cache after every Divi update
3. Disable "Generate Critical CSS" in LiteSpeed if it conflicts with Divi's own Critical CSS

### Autoptimize causes fatal errors with Divi

**Symptom:** White screen of death after enabling Autoptimize.

**Cause:** Autoptimize's jQuery deferral conflicts with Divi.

**Fix:** Disable JavaScript optimization in Autoptimize, or switch to a different cache plugin.

### Wordfence blocks page saves

**Symptom:** Saving in the Visual Builder fails with a Wordfence error.

**Cause:** Wordfence's firewall is blocking Divi AJAX requests.

**Fix:** Enable Wordfence Learning Mode for the duration of your Divi development session, then return to normal mode.

### Two security plugins conflict

**Symptom:** Random failures with both Wordfence and another security plugin enabled.

**Cause:** Multiple security plugins step on each other.

**Fix:** Use only one security plugin at a time.

---

## Migration Issues

### Divi 4 modules trigger AJAX reloads

**Symptom:** Editing in the Visual Builder constantly triggers AJAX reloads.

**Cause:** A Divi 4 (legacy) module on the page triggers the D4 backward-compatibility framework to load.

**Fix:** Replace D4 modules with D5 equivalents one by one. The plugin can scaffold D5 versions of common patterns — try `/divi5-toolkit:scaffold` for sections you need.

### Custom JavaScript doesn't fire on Divi 5 pages

**Symptom:** Your child theme JavaScript hooks worked on Divi 4 but not on Divi 5.

**Cause:** Divi 5 uses different DOM structure and event names than Divi 4.

**Fix:**
1. Inspect the new HTML structure in DevTools
2. Update selectors to match new class names
3. Check for D5-specific events in `window.ETBuilder` or `window.et_pb_custom`

### CSS ID & Classes field is gone

**Symptom:** You can't find the CSS ID & Classes field in Divi 5.

**Cause:** It was replaced by the Attributes panel.

**Fix:** Go to **Advanced > Attributes** instead. The Attributes panel supports `id`, `class`, `aria-*`, `data-*`, and any other HTML attribute. Existing D4 IDs and classes are auto-migrated.

### Page Builder shortcodes appear in content

**Symptom:** After migrating, you see `[et_pb_section]` shortcode text instead of rendered modules.

**Cause:** Something interrupted the migration to JSON block storage.

**Fix:**
1. Open the page in the Visual Builder once — Divi will re-save it in the new format
2. If that doesn't work, restore from backup and redo the migration on a staging site first

---

## Performance Issues

### Core Web Vitals are poor (LCP, INP, or CLS failing)

**Symptom:** Lighthouse or PageSpeed Insights reports LCP > 2.5s, INP > 200ms, or CLS > 0.1.

**Fix:** Run the `divi5-performance` agent — it accepts Lighthouse output, a URL, project CSS files, or a plain symptom description and returns a prioritized fix list:
```
Run the divi5-performance agent on my Lighthouse report: [paste report]
```
The agent checks Divi performance settings (Dynamic CSS, Critical CSS, Inline Stylesheets), render-blocking resources, image loading, CSS anti-patterns, and cache plugin configuration. See also: `skills/divi5-performance/examples/critical-css.css` and `font-loading.css` for copy-paste starting points.

### Page is slow with many Divi 5 features enabled

**Symptom:** Lighthouse score is poor.

**Common causes:**
1. Static CSS disabled (running CSS generation on every request)
2. D4 modules on the page (loading the full D4 framework)
3. Too many Loop Builder queries on a single page
4. Large number of Composable Settings (each adds CSS)
5. Cache plugin not properly configured

**Fix:**
1. Enable Static CSS in production (Divi > Theme Options > Builder > Advanced > Static CSS)
2. Enable Critical CSS (eliminates render-blocking)
3. Enable Dynamic CSS (94% smaller stylesheets)
4. Replace D4 modules with D5 equivalents
5. Use a single Loop Builder per page, paginate large queries
6. Configure WP Rocket properly (with Divi selectors safelisted)

### CSS file is enormous

**Symptom:** Your custom CSS file is 100KB+ and bloating page loads.

**Diagnosis:** Run `/divi5-toolkit:audit` and check the Total CSS Lines metric and Performance category.

**Common causes:**
- Hardcoded colors instead of variables (audit will flag)
- Duplicate selectors (audit will flag)
- Unused selectors (audit will flag — note: this is a heuristic)
- Overly broad selectors (`* {}`, `div {}`)
- Excessive `!important` usage

**Fix:** Address the audit's quick wins first. The biggest gains come from extracting hardcoded colors into CSS variables and removing duplicates.

---

## Accessibility Issues

### No focus indicators visible

**Symptom:** Tabbing through the page shows no visible focus on buttons, links, or form fields.

**Cause:** Divi's CSS removes default focus outlines.

**Fix:** Add focus styles. The fastest way is to copy `skills/divi5-css-patterns/examples/accessibility.css` into Divi > Theme Options > Custom CSS — it includes a complete focus indicator pattern using `:focus-visible`.

### Screen reader announces wrong landmarks

**Symptom:** A screen reader navigating your site announces "section, section, section" instead of "navigation, main, footer."

**Cause:** Divi defaults all sections to `<section>`. You need to set Semantic Elements explicitly.

**Fix:** For each major page region, edit the section in the Visual Builder:
1. Advanced > HTML > Element Type
2. Set to: `<nav>` for navigation, `<header>` for the masthead, `<main>` for the primary content, `<aside>` for sidebars, `<footer>` for the footer

### Color contrast warnings from Lighthouse

**Symptom:** Lighthouse flags low contrast on text.

**Diagnosis:** Run the `divi5-accessibility` agent on your CSS, or `/divi5-toolkit:audit` and look at Category E.

**Fix:** Either change the colors to meet 4.5:1 ratio (for AA) or 7:1 (for AAA), or use a color contrast checker like https://webaim.org/resources/contrastchecker/ to find compliant alternatives.

### Animations cause motion sickness for some users

**Symptom:** A user reports your site causes vertigo.

**Cause:** Animations are firing for users who have `prefers-reduced-motion: reduce` set.

**Fix:** Add a global reduced-motion media query:
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```
This is included in `accessibility.css` from the example library.

---

## FAQ

### Do I need an MCP server to use this plugin?

No. The plugin works standalone. The `.mcp.json` file is intentionally empty (`{"mcpServers": {}}`). Optional MCP servers (Context7, Playwright, A11y) are documented in the README but never required.

### Does this plugin require an internet connection?

Mostly no. The plugin's knowledge is bundled in the skill files. The exceptions:
- `/divi5-toolkit:research` and the `divi5-researcher` agent — these need internet to fetch updates
- `/divi5-toolkit:generate`, `/scaffold`, and `divi5-accessibility` may use WebSearch/WebFetch occasionally for Divi-specific verification, but only when bounded by their "When to Research" policies

### Can I use this on Divi 4?

The plugin is designed for Divi 5. It can help convert Divi 4 CSS to Divi 5 format via `/divi5-toolkit:convert`, but the knowledge base, validations, and scaffolds all target Divi 5 conventions. If you're still on Divi 4, the migration helpers will be more useful than the generation features.

### What's the difference between an agent and a command?

A **command** is something you type (`/divi5-toolkit:generate`). It runs once when you invoke it, with whatever arguments you give it.

An **agent** is a subagent Claude can spawn autonomously when the context matches its description, or that you can ask Claude to use explicitly. Some agents are also wired to run automatically via hooks (e.g., `divi5-validator` runs after every CSS file edit).

### What's a skill?

A **skill** is an auto-activating knowledge bundle. Claude loads it silently when its description matches what you're working on. You don't invoke skills — they just provide context Claude needs. Think of them as "things Claude already knows when you bring up Divi."

### How does the plugin stay current with Divi updates?

Run `/divi5-toolkit:research` periodically (about once a week, or whenever Divi cuts a new release). It fetches updates from official and community sources and rewrites the skill files in place. Check the `last_research` field in `.claude/divi5-toolkit.local.md` if you want to see when you last refreshed.

### Will this plugin overwrite my existing CSS?

No, unless you explicitly ask. Commands like `/generate` and `/scaffold` produce CSS for you to review. The `Write` tool only fires when you say "save this to file" or similar. The `divi5-validator` agent only reads files; it never writes.

### Can I use this with a child theme workflow?

Yes. Set `default_format: child-theme` in your config and the plugin will produce standard CSS files (no `<style>` tags) suitable for `child-theme/style.css`.

### Can I use this in CI/CD?

Yes for `/validate` and `/audit`. Both are read-only and produce structured reports you can capture in CI logs. The other commands are interactive and don't fit a CI flow as cleanly.

### Does this plugin send any data to Anthropic?

The plugin itself is just markdown, JSON, and CSS files. It doesn't send anything. Claude Code (the runtime) does send your prompts to Anthropic to generate responses — that's how Claude Code works in general. The plugin doesn't add any additional telemetry.

### Why are there so many `!important` declarations in the generated CSS?

Because Divi applies many styles inline or with high specificity, custom CSS often loses the cascade unless you use `!important`. This is a Divi quirk, not the plugin's choice. As of Divi 5.2, Composable Settings reduce the need — toggle settings in the builder instead of writing CSS, and you don't need `!important` because you're not overriding anything.

### How do I uninstall the plugin?

Stop loading it: don't pass `--plugin-dir` when starting Claude Code, or remove it from your global Claude Code plugin config. The plugin doesn't install anything outside its own directory, so there's nothing to clean up. Your project's `.claude/divi5-toolkit.local.md` is harmless to leave behind — it's just a markdown file.

### Can I contribute new commands, agents, or examples?

Yes. See [`CLAUDE.md`](../CLAUDE.md) for the file conventions and how to add new components. The plugin is MIT licensed.

---

## See Also

- [`docs/usage.md`](usage.md) — Detailed reference for every command, agent, and skill
- [`docs/configuration.md`](configuration.md) — Full configuration reference
- [`docs/workflows.md`](workflows.md) — Common multi-step scenarios
- [Elegant Themes Help Center](https://help.elegantthemes.com)
- [Divi 5 Changelog](https://victorduse.com/divi-5-changelog/)
- [Custom CSS Troubleshooting (Elegant Themes)](https://help.elegantthemes.com/en/articles/13479939-how-to-troubleshoot-and-fix-custom-css-issues-in-divi-5)
