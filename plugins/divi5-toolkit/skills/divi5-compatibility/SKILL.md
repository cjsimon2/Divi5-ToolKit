---
name: Divi 5 Compatibility
description: Use this skill when validating CSS for Divi 5 / Divi 5.6 compatibility, checking unsupported features or units, troubleshooting Divi CSS that isn't applying, debugging plugin conflicts (WP Rocket, LiteSpeed, Wordfence, WooCommerce, Perfmatters), migrating from Divi 4 to Divi 5, understanding breakpoints, applying the 5.5 Aspect Ratio + Framing settings to prevent CLS, using the 5.3 pseudo-class editing modes (:checked / :focus / :active) instead of custom CSS, the 5.4 Sizing Variable Generator and Relative Colorscheme Generator, the 5.6 new modules (Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed), Nested Option Presets, Critical CSS / Dynamic CSS / Inline Stylesheets, or fixing "styles not working" / "button override not working" / "static CSS cache" issues. Provides compatibility rules, validation patterns, specificity fixes, composable settings alternatives, version-specific bug fix history, and a full error-message reference.
user-invocable: false
---

# Divi 5 Compatibility Reference

**Divi 5 Version:** 5.6.0 (May 25, 2026 — Divi 5.0 released February 26, 2026)
**Architecture:** React 18, no Shadow DOM, standard DOM with `et_pb_*` classes
**Key recent additions:**
- 5.2 — Composable Settings (toggle any design option on any sub-element)
- 5.3 — Pseudo-class editing (`:checked`, `:focus`, `:active`), Contact Form 7 Styler, Nested Option Presets
- 5.4 — Sizing Variable Generator, Relative Colorscheme Generator
- 5.5 — Aspect Ratio + Framing on all images, Image Presets, SVG sanitization
- 5.6 — Five new modules (Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed), Color Scale + Color Harmony Generators

## CSS Feature Support

### Unit Picker Dropdown (Builder Fields)

| Unit | Status | Notes |
|------|--------|-------|
| `px` | Supported | Standard absolute unit |
| `%` | Supported | Percentage |
| `em` | Supported | Relative to parent font |
| `rem` | Supported | Relative to root font |
| `vw` | Supported | Viewport width |
| `vh` | Supported | Viewport height |
| `in`, `mm`, `cm`, `pt`, `pc` | Supported | Print/absolute units |

### Advanced Units (Freeform/Advanced Input Mode)

All valid CSS units work in advanced input mode and in custom CSS fields:

| Unit | Status | Notes |
|------|--------|-------|
| `ch` | Works in custom CSS | Not in dropdown; works in freeform/advanced/child theme |
| `ex` | Works in custom CSS | Not in dropdown; works in freeform/advanced/child theme |
| `dvh`, `svh`, `lvh` | Works in custom CSS | Dynamic/small/large viewport units |
| `vmin`, `vmax` | Works in custom CSS | Viewport min/max |

**Key insight:** Since Divi 5 renders standard HTML without Shadow DOM, any CSS feature the browser supports will work in custom CSS, Code Modules, Free-Form CSS, or child theme stylesheets. The unit picker dropdown is limited, but custom CSS is not.

### CSS Functions

| Function | Status | Notes |
|----------|--------|-------|
| `calc()` | Fully supported | Works in builder fields and custom CSS |
| `clamp()` | Fully supported | Great for fluid responsive values |
| `min()` | Fully supported | Works in builder fields |
| `max()` | Fully supported | Works in builder fields |
| `var()` | Fully supported | CSS custom properties |

### Modern CSS Features (via Custom CSS)

| Feature | Status | Notes |
|---------|--------|-------|
| CSS Variables | Supported | Must be in `:root` for global scope |
| Flexbox | Native | First-class builder support |
| CSS Grid | Native | Convertible from flexbox in builder |
| Container queries (`@container`) | Works | Via custom CSS/child theme (not in builder UI) |
| `:has()` selector | Works | Via custom CSS/child theme |
| CSS nesting | Works | Browser-native feature, via custom CSS |
| Cascade layers (`@layer`) | Works | Via custom CSS/child theme |
| `@media` queries | Works | Standard responsive tool |

### CSS Keywords

`auto`, `none`, `unset`, `inherit`, `fit-content` — all supported in advanced unit fields.

## Validation Rules

### Rule 1: Button Specificity (Critical)
```css
/* WILL NOT WORK — Divi overrides this */
.et_pb_button {
  background-color: #000000;
}

/* WILL WORK — proper override */
body .et_pb_button {
  background-color: #000000 !important;
}
```

**Required for buttons:**
- `body` prefix for specificity
- `!important` on all properties

### Rule 2: CSS Variable Scope
```css
/* May not work globally — wrong scope */
.my-section {
  --my-color: #2ea3f2;
}

/* WILL WORK — :root scope */
:root {
  --my-color: #2ea3f2;
}
```

### Rule 3: Code Module Wrapping
```html
<!-- INVALID — raw CSS in Code Module -->
.my-class { color: red; }

<!-- VALID — wrapped in style tags -->
<style>
.my-class { color: red; }
</style>
```

### Rule 4: Theme Options Format
Theme Options Custom CSS must NOT have `<style>` tags.

### Rule 5: Module Advanced Tab CSS Fields
The Module Element CSS fields (Title, Body, Button, Main Element, Before, After) accept **property declarations only** — no selectors or braces. Use Free-Form CSS for full rulesets.

```css
/* Module Element field (properties only): */
color: red;
font-size: 1.2rem;

/* Free-Form CSS (full rulesets with selector keyword): */
selector h4 { color: red; line-height: 1.5; }
selector:hover { transform: scale(1.02); }
```

### Rule 6: Numbered Classes Are Fragile
```css
/* FRAGILE — changes when modules are reordered */
.et_pb_text_0 { color: red; }

/* STABLE — use custom classes instead */
.my-intro-text { color: red; }
```

## Responsive Breakpoints

Divi 5 ships with 7 breakpoints, but **only 3 are active by default**:

| Breakpoint | Default Width | Active by Default | Query Type |
|------------|---------------|-------------------|------------|
| Phone | 767px | Yes | max-width |
| Phone Wide | 860px | No (enable in builder) | max-width |
| Tablet | 980px | Yes | max-width |
| Tablet Wide | 1024px | No (enable in builder) | max-width |
| Desktop | (base) | Yes (cannot be disabled) | N/A |
| Widescreen | 1280px | No (enable in builder) | min-width |
| Ultra Wide | 2560px | No (enable in builder) | min-width |

All breakpoint widths are customizable. Custom breakpoints configured via Sitewide Responsive Breakpoints modal in the Visual Builder.

### Standard Media Queries
```css
/* Phone (default active) */
@media (max-width: 767px) { }

/* Tablet (default active) */
@media (max-width: 980px) { }

/* Widescreen (must enable) */
@media (min-width: 1280px) { }

/* Ultra Wide (must enable) */
@media (min-width: 2560px) { }
```

**Note:** The visibility toggle only supports the original 3 breakpoints (desktop, tablet, phone). Use CSS for visibility on custom breakpoints.

## Common Issues & Fixes

### Issue: Button styles not applying
**Symptom:** Custom button colors/styles ignored
**Cause:** Low specificity, missing !important
**Fix:**
```css
body .et_pb_button {
  background-color: #000000 !important;
  border-radius: 0 !important;
  /* ALL properties need !important */
}
```

### Issue: Custom CSS overridden by Divi
**Symptom:** Styles appear struck-through in DevTools
**Cause:** Divi's `cached-inline-styles` CSS loads after child theme stylesheets
**Fix:** Move CSS to Theme Options Custom CSS panel (loads later in cascade), increase selector specificity, or use `!important`.

### Issue: CSS Variables not working
**Symptom:** Variables undefined or not applying
**Cause:** Wrong scope or Divi 5.1 unit picker bug (fixed)
**Fix:**
```css
:root {
  --my-color: #2ea3f2;
}
.element {
  color: var(--my-color);
}
```

### Issue: Visual Builder vs Frontend differences
**Symptom:** Styles look different in builder vs live site
**Cause:** Builder renders in an iframe with different CSS context
**Fix:** Always test on the frontend. Use Safe Mode (Divi > Support Center) to isolate.

### Issue: Styles lost after Divi update
**Symptom:** Custom CSS disappears or breaks after updating
**Cause:** Static CSS cache is stale
**Fix:** Clear at Divi > Theme Options > Builder > Advanced > Static CSS File Generation > Clear. Disable Static CSS during active development.

### Issue: Font not loading
**Symptom:** Fallback font displays instead
**Cause:** Websafe fonts incorrectly generating Google Fonts API requests (fixed in 5.1)
**Fix:** Ensure font is loaded via Google Fonts or @font-face. Use exact name with fallbacks:
```css
font-family: 'Fira Sans', system-ui, sans-serif !important;
```

### Issue: Layout breaking on mobile
**Symptom:** Elements stack or overflow incorrectly
**Cause:** Divi 5 uses Flexbox by default; custom CSS may conflict
**Fix:** Work with Divi's Flexbox controls in the builder, or override completely:
```css
.et_pb_row {
  display: flex !important;
  flex-direction: row !important;
  gap: 2rem !important;
}
```

### Issue: Hover states not working
**Symptom:** Hover effects ignored
**Cause:** Divi's inline styles override
**Fix:**
```css
body .et_pb_button:hover {
  background-color: #222222 !important;
}
```

### Issue: Header/menu layout breaks after clearing Static CSS (5.6, field-verified 2026-06-12)
**Symptom:** A previously centered header menu (e.g., `inline_centered_logo` style) packs to the left on every page immediately after clearing the Static CSS cache. No custom CSS touches the menu.
**Cause:** Regeneration re-emits the template's flex layout CSS using current defaults (`justify-content: start`). Modules configured before Divi exposed explicit Flex options (or left at "default") inherited centering implicitly; the regenerated CSS doesn't reproduce it. Diagnostic signature: `.et_pb_menu_inner_container` computes `justify-content: start` and `.et_pb_menu__wrap` computes `flex: 0 1 auto` while the stylesheet still contains `flex: 1 1 auto` for it.
**Fix:** In the Theme Builder, set the menu module's **Justify Content** and **Align Items** explicitly — per breakpoint (e.g., Desktop: Center; Tablet/Phone: Space Between so the logo stays left and the hamburger stays right). Any setting change + Save forces a clean regeneration. Do NOT patch with custom CSS first — the builder-native fix survives future regenerations.

### Issue: Custom CSS targeting `et_pb_section_N_tb_header` / `_tb_footer` silently stops matching (field-verified 2026-06-12)
**Symptom:** A rule scoped to a numbered Theme Builder template class (e.g., `.et_pb_section_1_tb_footer`) stops applying after editing/resaving any template — no error, the selector just matches nothing.
**Cause:** Resaving a Theme Builder template can renumber its `et_pb_section_N_tb_*` classes (e.g., `_1_` → `_3_`). Numbered **template** classes are exactly as fragile as page-level numbered selectors (`.et_pb_text_0`), but they look stable because they survive page edits — they only break on template saves, which makes the failure hard to trace.
**Fix:** Scope to the stable Theme Builder layout wrappers instead: `.et-l--header`, `.et-l--body`, `.et-l--footer` (e.g., `.et-l--footer a[href^="tel:"]`). Treat `et_pb_*_N_tb_*` in custom CSS as a P0 finding, same as any numbered selector.

## Plugin Conflict Reference

### Cache Plugins
- **WP Rocket + RUCSS**: Divi auto-disables Dynamic CSS when RUCSS is active. Use CSS Safelist to preserve Divi selectors.
- **LiteSpeed Cache**: May show unstyled HTML initially. Whitelist `admin-ajax.php` in ModSecurity.
- **Autoptimize**: jQuery deferral can cause fatal errors with Divi.
- **General rule:** Disable Divi performance options (Static CSS, Dynamic CSS, JS deferral) during development. Enable after finalization.

### Security Plugins
- **Wordfence**: Firewall can block page saves. Use Learning Mode during Divi updates.
- **Multiple security plugins**: Use only one — they conflict with each other.

### WooCommerce
- Cart/checkout pages may lose formatting after updates.
- **Fix:** Disable Dynamic CSS in Divi Theme Options > Performance. Divi 5 offers native Woo Cart and Checkout modules.

## Divi 4 to Divi 5 Migration

### What Changes
- Shortcodes (`[et_pb_section]`) → JSON block format
- HTML structure changes — CSS selectors may break
- CSS ID & Classes field → Attributes panel (Advanced tab)
- Custom JS targeting Divi 4 DOM may fail
- Third-party D4 modules load in backward-compatibility mode (full D4 framework)

### Migration Checklist
1. Back up the full site (database + files)
2. Test on staging environment first
3. Inspect new HTML structure in browser DevTools
4. Adapt custom CSS selectors for new class structure
5. Move CSS IDs/classes to new Attributes panel
6. Test all custom JavaScript hooks
7. Clear Static CSS cache after migration
8. Check third-party plugin compatibility tags

### Backward Compatibility
- D4 modules auto-detected and loaded with D4 framework
- If a page has even one D4 module, the **entire page** loads D4 framework (performance hit)
- Legacy modules trigger AJAX reload when editing in Visual Builder

## Debugging Techniques

### Browser DevTools
1. **Computed tab:** Shows final applied values — identifies which style "won"
2. **Styles tab:** Shows cascaded styles with source locations. Struck-through = overridden.
3. **In Visual Builder:** Right-click is disabled. Hover over the admin bar to right-click and inspect.

### Divi Safe Mode
- **Location:** Divi > Support Center > Safe Mode
- Disables third-party plugins, child themes, and custom code for your session only
- If the problem disappears, it's caused by a plugin/child theme/custom code

### Static CSS Troubleshooting
- Clear: Divi > Theme Options > Builder > Advanced > Static CSS > Clear
- Keep disabled during development
- Per-page setting defaults to TRUE even if globally disabled

### D5 Dev Tool
- [github.com/elegantthemes/d5-dev-tool](https://github.com/elegantthemes/d5-dev-tool) — debugging modal for the Visual Builder

## Composable Settings Compatibility (Divi 5.2+ through 5.5)

Composable Settings let you enable any design option for any module sub-element directly in the builder. Before reaching for custom CSS, check if the styling can be achieved natively:

| CSS Pattern | Composable Alternative | Since |
|-------------|----------------------|-------|
| Width/height on buttons | Enable Sizing options on button sub-element | 5.2 |
| Border on titles | Enable Border options on title sub-element | 5.2 |
| Animation on images | Enable Animation options on image sub-element | 5.2 |
| Transform on any sub-element | Enable Transform options via Compose Settings | 5.2 |
| Spacing on any sub-element | Enable Spacing options via Compose Settings | 5.2 |
| `input:focus` / `input:checked` / `input:active` styling | Use the pseudo-class tabs in field design | 5.3 |
| `aspect-ratio: 16/9` on images | Sizing > Aspect Ratio | 5.5 |
| `object-fit` / `object-position` on cropped images | Framing settings | 5.5 |
| Image-specific options on non-image modules | Composable settings for image option groups | 5.5 |
| Nested presets (e.g., button border inside CTA preset) | Nested Option Presets | 5.3 |

**When CSS is still needed:**
- Complex selectors (`:has()`, sibling combinators, attribute selectors)
- Pseudo-elements (`::before`, `::after`) beyond what Free-Form CSS offers
- `@media` queries for preference queries (`prefers-reduced-motion`, `prefers-color-scheme`)
- Custom `@keyframes` animations
- Cross-element relationships
- Canvas/popup styling
- Custom-styled checkboxes/radios with visual UI distinct from the native input

## Known Divi 5.x CSS Bug Fixes (Version History)

If a user reports one of these symptoms, check whether their Divi version predates the fix.

### Fixed in 5.2
- Box shadow inherited hover states breaking due to empty string values overwriting presets
- Transform Scale handle drag corrupting `calc()` function values and CSS variable values
- Broken CSS on pages with loops if a paginated page was visited before the main loop page

### Fixed in 5.3 (April 24, 2026 — 69 fixes total)
- Sticky/locked module rendering performance regressions
- Visual Builder loading speed (deferred assets + lazy-loading of editor chunks)
- Form field option inconsistencies across modules

### Fixed in 5.5 (May 12, 2026 — 58 fixes total)
- Grid class parity for `first_in_row`, `last_in_row`, `on_last_row` selectors
- Flex/Grid layout row height application
- Border inheritance corrections
- CSS variable application for background images

### Fixed in 5.6 (May 25, 2026 — 109 changes total)
- Decimal values in Section Divider Horizontal Repeat field (0.6x now accepted)
- Grid Auto Columns/Rows accept full CSS track values beyond single numeric sizes
- Global number and font variables render correctly on frontend
- Responsive padding calculations corrected for columns with child modules
- Background videos no longer load on devices where the module is removed

### Pattern
If a user is on a Divi version older than the fix for their issue, the answer is "update Divi." For users who can't update (compatibility constraints, third-party module dependencies), provide a workaround appropriate to their version.

## Error Messages Reference

| Error | Cause | Fix |
|-------|-------|-----|
| "Property ignored" | Low specificity | Add `!important` or increase specificity |
| "Unknown property" | Typo or unsupported | Check property name |
| "Expected RBRACE" | Missing `}` or selectors in Module Element field | Use Free-Form CSS for full rulesets |
| "Unexpected token" | Syntax error | Check semicolons, braces, quotes |
| Styles not applying | Wrong CSS location or cache | Check format (Code Module needs `<style>`, Theme Options does not). Clear cache. |
| Transform values corrupted | Dragging Scale handles corrupts calc()/var() values | Re-enter values manually (fixed in 5.2) |
| Box shadow hover broken | Empty string values overwrite presets | Update to 5.2, or set explicit hover shadow |
| Loop page CSS missing | Pagination cache conflict | Clear Static CSS; fixed in 5.2 |

## Compatibility Modes

### Advisory Mode (Default)
- Reports issues as warnings
- Suggests fixes
- Allows proceeding with warnings

### Strict Mode
- Reports issues as errors
- Requires fixes before proceeding
- Blocks incompatible CSS

Configure in `.claude/divi5-toolkit.local.md`:
```yaml
validation_mode: advisory  # or "strict"
```

## Reference Files

For complete details, see:
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-compatibility/references/unit-conversions.md` — CSS unit support, conversion tables, fluid responsive patterns
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/SKILL.md` — Critical CSS, Dynamic CSS, Inline Stylesheets, cache plugin compatibility
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/references/core-web-vitals.md` — LCP/INP/CLS diagnostics with Divi-specific causes and fixes

## Resources

- [Elegant Themes Help Center](https://help.elegantthemes.com)
- [Divi 5 Changelog](https://victorduse.com/divi-5-changelog/)
- [D5 Extension Examples](https://github.com/elegantthemes/d5-extension-example-modules)
- [D5 Dev Tool](https://github.com/elegantthemes/d5-dev-tool)
- [WP Zone Divi CSS Guide](https://wpzone.co/the-divi-css-and-child-theme-guide/)
- [Quiroz.co Divi Snippets](https://quiroz.co/divi-tutorials-much/divi-snippets-css-php/)
