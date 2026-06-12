---
name: Divi 5 CSS Patterns
description: Use this skill when writing CSS for Divi 5 / Divi 5.6, styling Divi modules (buttons, sections, rows, blurbs, toggles, forms including the 5.3 Contact Form 7 Styler), the five 5.6 modules (Timeline, Breadcrumbs, SVG, Table of Contents, Instagram Feed), working with Free-Form CSS and the `selector` keyword, overriding `.et_pb_*` classes, setting up design tokens or dark mode, using the 5.4 Sizing Variable Generator or Relative Colorscheme Generator, applying the 5.5 Aspect Ratio / Framing settings, adding animations with reduced-motion, styling WooCommerce with Divi, the 5.3 pseudo-class editing modes (:checked, :focus, :active), Nested Option Presets, building accessible layouts, or developing a Divi child theme. Provides CSS patterns, class naming conventions, selector specificity guidance, Composable Settings alternatives, Canvas and Loop Builder patterns, and full example files for buttons, design tokens, animations, dark mode, WooCommerce, accessibility, forms, Loop Builder, and the 5.6 new modules.
user-invocable: false
---

# Divi 5 CSS Development Patterns

## Overview

**Divi 5** (released February 26, 2026, current version 5.6.0 as of May 25, 2026) is a complete architecture overhaul:
- **React 18-based Visual Builder** — no Shadow DOM, standard DOM with `et_pb_*` classes
- **Flexbox-first layout** — sections, rows, columns use Flexbox by default
- **Native CSS Grid support** — convertible from Flexbox in builder; 5.6 added full CSS track values (`grid-auto-columns`, `grid-auto-rows`)
- **Design Variable Manager** — 6 variable types (Colors, Fonts, Numbers, Images, Text, Links)
- **Preset System** — Option Group, Element, Stacked, and Nested presets. 5.3 added **Nested Option Presets** (presets within presets, e.g., CTA > Button > Border)
- **Block-based storage** — JSON format, no shortcodes
- **7 responsive breakpoints** — 3 active by default, 4 optional
- **Dynamic CSS** — 94% smaller stylesheets, per-page CSS generation. Per-module components combine into a unique per-page stylesheet.
- **Critical CSS + Inline Stylesheets** — auto-extracted above-the-fold CSS inlined; non-critical deferred. Together they eliminate render-blocking CSS.
- **Composable Settings (5.2)** — toggle any design option on any sub-element, reducing CSS needs
- **Canvas System** — local/global canvases for off-canvas menus, popups, staging areas
- **Canvas Portal Module** — inject canvas content at specific layout locations
- **Interaction Builder** — cross-canvas interactions with Click, Mouse, Viewport, Load triggers
- **Loop Builder** — native repeating content loops with CSS Grid for dynamic layouts
- **Page Manager** — create/edit/duplicate/delete pages without leaving the builder
- **Divi AI Agent** — AI tool sets integrated into the builder (5.2; 5.5 added canvas AI tools for natural-language workflows)

## Divi 5.3 – 5.6 Additions (Use Builder First)

The skill auto-activates for any Divi CSS task, but many things that previously required custom CSS now have native equivalents. Reach for these first:

### 5.3 (April 24, 2026) — Form overhaul
- **Pseudo-class editing modes**: design tabs now expose `:checked`, `:focus`, `:active` directly. Style field focus rings, checked checkboxes, and active states in the builder — no custom CSS for these.
- **Harmonized field options** across all form-based modules (Contact Form, Email Optin, Login, Signup).
- **New checkbox and radio field groups** with preset support — style once, apply across forms.
- **Contact Form 7 Styler module** — renders + styles CF7 inside Divi with full design controls. Use this instead of writing CF7 CSS manually.
- **Nested Option Presets** — presets within presets. Common sub-options (e.g., `Call To Action > Button > Border`) now support presets.

### 5.4 — Variable Generators
- **Sizing Variable Generator** — automates fluid responsive sizing via `clamp()`. Use this instead of hand-writing clamp() for every type scale.
- **Relative Colorscheme Generator** — HSL-based color systems. Generates derivative shades from a single base color.

### 5.5 (May 12, 2026) — Image overhaul
- **Aspect Ratio settings** on every image element — eliminates CLS by reserving space before the image loads. **Always set this on image modules.**
- **Framing settings** — reposition cropped images within their aspect ratio (object-fit + object-position via builder).
- **Image Presets** — preset support across all modules with images.
- **SVG sanitization** for inline SVG (paves way for 5.6 SVG module).
- **Composable settings for image option groups** — set image-specific options on any module containing an image.

### 5.6 (May 25, 2026) — Five new modules
- **Timeline** — vertical/horizontal event chronologies. Pairs with Loop Builder.
- **Breadcrumbs** — navigation hierarchy. Great for Theme Builder templates. (Note: Home Link uses dedicated Home Link settings, NOT the general breadcrumb link styling.)
- **SVG** — inline SVG with native stroke and width settings.
- **Table of Contents** — auto-generates from page headings.
- **Instagram Feed** — image gallery sourced from Instagram.
- **Color Scale Generator** — systematic color derivative creation.
- **Color Harmony Generator** — tetradic, triadic, analogous color relationships.
- **Fixed**: decimal values in Section Divider Horizontal Repeat (0.6x); grid track values beyond single numerics; global number/font variables on frontend; responsive padding on columns with child modules.

## CSS Integration Methods

### Method 1: Theme Options (Global Styles)
**Location:** Divi > Theme Options > Custom CSS
**Format:** Raw CSS without `<style>` tags
**Priority:** Loads after child theme — higher cascade priority

```css
:root {
  --custom-color: #2ea3f2;
}
```

### Method 2: Page-Level Custom CSS
**Location:** Page Settings > Advanced Tab > Custom CSS
**Scope:** Single page only

### Method 3: Module Custom CSS (Advanced Tab)
**Location:** Any element > Advanced Tab > Custom CSS
Organized into:
- **Module Elements** (Title, Body, Button, etc.) — accepts property declarations only, no selectors
- **Before / Main Element / After** — pseudo-element targeting
- **Free-Form CSS** — full rulesets with the `selector` keyword

### Method 4: Free-Form CSS (New in Divi 5)
Uses the `selector` keyword as a placeholder for the current element:

```css
selector h4 { color: red; line-height: 1.5; }
selector { display: grid; grid-template-columns: repeat(2, 1fr); }
selector:hover { transform: scale(1.02); }
```

Multiple CSS blocks can be added per module. This is the most powerful per-element styling method.

### Method 5: Code Module (Page-Specific)
**Location:** Add Code Module to page
**Format:** CSS wrapped in `<style></style>` tags

```html
<style>
.page-specific-style {
  background-color: var(--custom-color);
}
</style>
```

### Method 6: Custom HTML Wrappers (New in Divi 5)
**Location:** Advanced Tab > HTML option group
- **HTML Before** and **HTML After** fields
- Inject wrapper divs, data attributes, or helper markup around any element
- Available on every element (sections, rows, columns, modules)
- Often replaces Code Modules for structural wrapper needs

### Method 7: Semantic Elements (New in Divi 5)
**Location:** Advanced Tab > HTML option group > Element Type dropdown
Change any element's HTML tag: `section`, `nav`, `header`, `article`, `aside`, `footer`, `main`, `button`, etc.

### Method 8: Child Theme (Production)
**Location:** child-theme/style.css
**Note:** Divi's `cached-inline-styles` loads after child theme. Use `!important` or Theme Options CSS for higher priority.

### Method 9: Attributes Panel (Replaces CSS ID & Classes)
**Location:** Advanced Tab > Attributes
- The old "CSS ID & Classes" toggle is gone in Divi 5
- Supports: `id`, `class`, `aria-label`, `data-*`, `rel`, `title`, and any HTML attribute
- Existing D4 IDs/classes auto-migrate to this panel

## Adding Custom Classes in Divi 5

1. Select the module
2. Go to **Advanced Tab > Attributes**
3. Click **Add Attribute**
4. Set **Name** to `class`
5. Set **Value** to your class name(s)

## Selector Specificity for Divi Overrides

Divi applies many styles inline or with `!important`. To override:

### Standard Override Pattern
```css
/* May not work — too low specificity */
.et_pb_button {
  background-color: black;
}

/* Better — higher specificity */
body .et_pb_button {
  background-color: black !important;
}

/* Best — with custom class */
body .et_pb_button.custom-btn {
  background-color: black !important;
}
```

### Button Override Template
```css
body .et_pb_button {
  background-color: #000000 !important;
  border-radius: 0 !important;
  letter-spacing: 4px !important;
  text-transform: uppercase !important;
  font-family: 'Lato', Helvetica, Arial, sans-serif !important;
  font-weight: 400 !important;
  border: 1px solid #000000 !important;
}

body .et_pb_button:hover {
  background-color: #222222 !important;
  border-color: #222222 !important;
}
```

### Section Override Patterns
```css
.et_pb_section.custom-dark-section {
  background-color: #1d1f22 !important;
}

.et_pb_section.custom-dark-section h1,
.et_pb_section.custom-dark-section h2,
.et_pb_section.custom-dark-section p {
  color: #ffffff !important;
}
```

## Class Naming Convention

Use a unique prefix to avoid conflicts with Divi's classes:

| Pattern | Example | Purpose |
|---------|---------|---------|
| `{prefix}-btn` | `my-btn` | Button base |
| `{prefix}-btn--variant` | `my-btn--primary` | Button variant |
| `{prefix}-section--modifier` | `my-section--dark` | Section modifier |
| `{prefix}-card` | `my-card` | Component |

**Avoid numbered classes** (`.et_pb_text_0`, `.et_pb_text_1`) — they're positional and change when modules are reordered.

## Common Divi Module Selectors

### Structural Elements

| Module | Selector | Notes |
|--------|----------|-------|
| Section | `.et_pb_section` | Outer container |
| Fullwidth Section | `.et_pb_fullwidth_section` | Full-width variant |
| Row | `.et_pb_row` | Content row |
| Column | `.et_pb_column` | Grid column |
| Column (1/2) | `.et_pb_column.et_pb_column_1_2` | Half-width |
| Column (1/3) | `.et_pb_column.et_pb_column_1_3` | Third-width |
| Column (1/4) | `.et_pb_column.et_pb_column_1_4` | Quarter-width |

### Content Modules

| Module | Selector | Inner Selectors |
|--------|----------|-----------------|
| Text | `.et_pb_text` | `.et_pb_text_inner` |
| Button | `.et_pb_button` | (self-contained) |
| Image | `.et_pb_image` | `.et_pb_image_wrap` |
| Blurb | `.et_pb_blurb` | `.et_pb_blurb_content`, `.et_pb_blurb_container` |
| CTA | `.et_pb_promo` | `.et_pb_promo_description` |
| Heading | `.et_pb_module h1/h2/h3` | Use module prefix |
| Slider | `.et_pb_slider` | `.et_pb_slide`, `.et_pb_slide_content` |
| Blog | `.et_pb_blog_grid` | `.et_pb_post`, `.et_pb_post_content` |
| Contact Form | `.et_pb_contact_form` | `.et_pb_contact_field` |
| Toggle/Accordion | `.et_pb_toggle` | `.et_pb_toggle_title`, `.et_pb_toggle_content` |
| Tabs | `.et_pb_tabs` | `.et_pb_tab`, `.et_pb_tabs_controls` |
| Gallery | `.et_pb_gallery` | `.et_pb_gallery_item` |
| Video | `.et_pb_video` | `.et_pb_video_overlay` |
| Code | `.et_pb_code` | `.et_pb_code_inner` |
| Counter/Bar | `.et_pb_counter` | `.et_pb_counter_container`, `.et_pb_counter_amount` |
| Number Counter | `.et_pb_number_counter` | `.percent` |
| Testimonial | `.et_pb_testimonial` | `.et_pb_testimonial_description` |
| Pricing Table | `.et_pb_pricing` | `.et_pb_pricing_heading`, `.et_pb_pricing_content_top` |
| Divider | `.et_pb_divider` | `.et_pb_divider_internal` |
| Social Media | `.et_pb_social_media_follow` | `.et_pb_social_media_follow_network_link` |
| Search | `.et_pb_search` | `.et_pb_s` (input field) |
| Login | `.et_pb_login` | `.et_pb_login_form` |
| Portfolio | `.et_pb_portfolio` | `.et_pb_portfolio_item` |
| Map | `.et_pb_map` | `.et_pb_map_container` |
| Audio | `.et_pb_audio_module` | `.et_pb_audio_module_content` |
| Sidebar | `.et_pb_widget_area` | Standard WP widget classes |
| Comments | `.et_pb_comments_module` | Standard WP comment classes |
| Countdown | `.et_pb_countdown_timer` | `.et_pb_countdown_timer_container` |

### New Divi 5 Modules

| Module | Purpose |
|--------|---------|
| Group | Container for grouping modules with shared styles |
| Carousel Group | Flexible slider with any module per slide |
| Before/After Image | Interactive image comparison slider |
| Canvas Portal | Off-canvas overlays, side panels, popups |
| Dropdown | Drop-down content with customizable interactions |
| Icon List | Lists with per-item icons and global styles |
| Link | Standalone link element for navigation |
| Lottie | Native Lottie animation integration |

## Divi 5 Design Variable System

Divi 5 introduces 6 types of Design Variables (managed via the Visual Builder UI):

| Type | Purpose | Example |
|------|---------|---------|
| **Colors** | Brand palette, supports HSL adjustments | Primary brand color |
| **Fonts** | Typography choices | Heading font family |
| **Numbers** | Sizing values (spacing, radius, etc.) | Border radius, padding |
| **Images** | Recurring visual assets | Logo, background |
| **Text** | Repeated text content | Company address |
| **Links** | URL values | Social media links |

Design Variables complement CSS custom properties — they don't replace them. Use Design Variables for no-code workflows and CSS variables for developer control.

### Preset Hierarchy

1. **Option Group Presets** — Modular building blocks for individual properties (e.g., "Primary Button Style")
2. **Element Presets** — Complete design packages for entire module types (e.g., "Hero Section")
3. **Stacked Presets** — Multiple presets layered on one element, merged intelligently
4. **Nested Presets** — Option Group Presets inside Element Presets, individually swappable

**Recommended workflow:** Define Design Variables → Build Option Group Presets → Nest into Element Presets → Use Inspector to audit consistency.

## Typography Patterns

### Font Stack Template
```css
:root {
  --font-body: 'Fira Sans', system-ui, sans-serif;
  --font-title: 'Josefin Sans', sans-serif;
  --font-heading: 'Playfair Display', Georgia, serif;
  --font-button: 'Lato', Helvetica, Arial, sans-serif;
}
```

### Heading Overrides
```css
body .et_pb_module h1 {
  font-family: var(--font-title) !important;
  text-transform: uppercase;
  letter-spacing: 3px;
}

body .et_pb_module h2 {
  font-family: var(--font-heading) !important;
  color: #3f445e !important;
}
```

### Text Line Length (Readability)
```css
.et_pb_text_inner p,
.et_pb_text_inner li {
  max-width: 60rem;
}

.et_pb_text_align_center .et_pb_text_inner p {
  margin-left: auto;
  margin-right: auto;
}
```

## Responsive Breakpoints

Divi 5 supports 7 customizable breakpoints (3 active by default). The **defaults** — what your media queries must match unless the site owner has customized the widths:

| Divi 5 Name | Default Width | Active by Default | Query Type |
|-------------|---------------|-------------------|------------|
| Phone | 767px | Yes | max-width |
| Phone Wide | 860px | No | max-width |
| Tablet | 980px | Yes | max-width |
| Tablet Wide | 1024px | No | max-width |
| Desktop | BASE | Yes | (no media query) |
| Widescreen | 1280px | No | min-width |
| Ultra Wide | 2560px | No | min-width |

```css
/* BASE: Desktop — no media query */

@media (max-width: 980px) { /* Tablet and below */ }
@media (max-width: 767px) { /* Phone */ }
@media (min-width: 1280px) { /* Widescreen (if enabled) */ }
```

**Enable additional breakpoints in Divi:** Visual Builder → three-dot icon next to device icons → **Sitewide Responsive Breakpoints** → enable Phone Wide, Tablet Wide, Widescreen, Ultra Wide. All widths are customizable there too.

**Optional: 2025-aligned custom widths.** The `responsive-breakpoints-2025.md` reference recommends *customizing* the 7 widths to match 2025 device traffic (479 / 767 / 1023 / 1279 / BASE 1280–1535 / 1536 / 1920). Only write media queries against those values if the site's Divi breakpoints have actually been changed to match — otherwise your CSS and the builder's responsive previews will disagree.

**Best practice:** Use `clamp()`, `vw`, `calc()` for fluid responsive values to reduce breakpoint overrides:
```css
font-size: clamp(1rem, 2vw + 0.5rem, 2rem);
padding: clamp(1rem, 3vw, 4rem);
```

For complete 7-breakpoint templates, device statistics, and typography scales, see:
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/responsive-7-breakpoints.css` — full responsive template
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/references/responsive-breakpoints-2025.md` — 2025 device data, configuration guide, framework comparison

## Layout Patterns

### Flexbox (Default in Divi 5)
```css
.et_pb_row {
  display: flex !important;
  flex-direction: row !important;
  gap: 2rem !important;
  flex-wrap: wrap !important;
}
```

### CSS Grid
```css
/* Free-Form CSS on a row or section */
selector {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}
```

## Component Patterns

### Card Pattern
```css
.et_pb_blurb.custom-card,
.et_pb_column.custom-card {
  background: #ffffff;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  padding: 2rem;
  transition: all 0.3s ease;
}

.et_pb_blurb.custom-card:hover,
.et_pb_column.custom-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
}
```

### Quote Block Pattern
```css
.et_pb_text.custom-quote {
  border-left: 4px solid #b2a065;
  padding-left: 2rem;
  font-family: var(--font-title);
  font-size: 1.375rem;
  font-style: italic;
}
```

### Info Box Pattern
```css
.custom-info-box {
  background-color: #f5f5f5;
  border-left: 4px solid #b2a065;
  padding: 2rem;
  border-radius: 0 8px 8px 0;
}
```

## Design Token Template

```css
:root {
  /* Brand Colors */
  --color-primary: #2ea3f2;
  --color-primary-hover: #1a8fd4;
  --color-secondary: #b2a065;
  --color-secondary-hover: #9a8a57;

  /* Dark Theme */
  --color-dark-section: #1d1f22;
  --color-dark-overlay: rgba(29, 31, 34, 0.95);
  --color-gray-section: rgba(150, 150, 150, 0.47);

  /* Text Colors */
  --color-white: #ffffff;
  --color-body-text: #222222;
  --color-body-text-light: #666666;
  --color-heading-text: #333333;
  --color-heading-accent: #3f445e;

  /* Backgrounds */
  --color-light-gray: #f5f5f5;
  --color-footer: #1d1f22;

  /* Typography */
  --font-body: 'Fira Sans', system-ui, sans-serif;
  --font-title: 'Josefin Sans', sans-serif;
  --font-heading: 'Playfair Display', Georgia, serif;
  --font-button: 'Lato', Helvetica, Arial, sans-serif;

  /* Sizing */
  --max-width: 1400px;
  --max-width-text: 60rem;
  --radius-card: 8px;
}
```

## Performance Best Practices

1. **Enable Dynamic CSS** — 94% smaller stylesheets
2. **Enable Critical CSS** — eliminates render-blocking requests
3. **Disable Static CSS during development** — enable after finalization
4. **Don't combine Divi Critical CSS with WP Rocket RUCSS** — they conflict
5. **Use `clamp()` and fluid values** to reduce breakpoint-specific CSS

## Accessibility Patterns

1. **Use Semantic Elements** to change `<div>` to `<nav>`, `<section>`, `<header>`, etc.
2. **Add ARIA attributes** via Attributes panel or accessibility plugins
3. **Visible focus indicators** for keyboard navigation
4. **Color contrast** — meet WCAG 2.1 AA standards
5. **Recommended plugin:** Divi-Modules Accessibility Attributes

## Composable Settings (Divi 5.2+)

Composable Settings let you enable **any** of Divi's design options for **any** module sub-element. This dramatically reduces the need for custom CSS.

### What It Replaces
Before 5.2, adding a width to a button, a border to a title, or an animation to an image required custom CSS. Now you can toggle these on in the builder.

### How It Works
1. Select any module sub-element (Title, Body, Button, Image, etc.)
2. Click the **Compose Settings** icon
3. Enable any design option: sizing, spacing, borders, animations, transforms, etc.
4. Configure directly in the builder UI

### When to Still Use CSS
- Complex selectors or pseudo-elements
- Design patterns not covered by builder options
- Cross-element relationships (sibling/parent selectors)
- `@media` queries beyond Divi's breakpoint system
- `prefers-reduced-motion` and other preference queries
- Custom animations with `@keyframes`

## Canvas System (Divi 5+)

### Canvas Types
- **Main Canvas** — the page's primary visible content
- **Local Canvases** — detached workspaces per page/template, kept separate until connected
- **Global Canvases** — site-wide reusable canvases (e.g., shared popup, menu)

### CSS Patterns for Canvas Content
```css
/* Off-canvas menu styling */
.{prefix}-offcanvas {
  position: fixed;
  top: 0;
  left: -100%;
  width: min(80vw, 400px);
  height: 100vh;
  z-index: var(--z-fixed, 1030);
  transition: left 0.4s cubic-bezier(0.22, 1, 0.36, 1);
  overflow-y: auto;
}

/* Popup/modal overlay */
.{prefix}-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  backdrop-filter: blur(4px);
  z-index: var(--z-modal, 1050);
}
```

### Interaction Builder + Canvas Workflow
1. Build content in a local or global canvas
2. Use Canvas Portal Module to inject at a specific layout location
3. Create Interactions on main canvas targeting canvas elements
4. Triggers: Click, Mouse Enter/Exit, Viewport Enter/Exit, Load
5. Divi auto-appends targeted canvases to the main canvas on the frontend

## Loop Builder

Build dynamic content layouts without plugins:
1. Design the loop item template using Divi modules
2. Divi pulls and repeats data from the database
3. Combine with CSS Grid for product grids, blog layouts, etc.

```css
/* Loop Builder grid layout */
selector {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: clamp(1rem, 2vw, 2rem);
}
```

## Best Practices Summary

1. **Check Composable Settings first** — many CSS overrides are now unnecessary in Divi 5.2+
2. **Use pseudo-class editing in the builder (5.3+)** — `:checked`, `:focus`, `:active` no longer need custom CSS for most use cases
3. **Set Aspect Ratio on every image (5.5+)** — eliminates CLS with zero custom CSS
4. **Use the Sizing Variable Generator (5.4+)** instead of hand-writing clamp() for fluid type scales
5. **Use Free-Form CSS** with `selector` keyword for per-element styling
6. **Use `body` prefix and `!important`** when overriding Divi buttons and module styles
7. **Prefix all custom classes** to avoid conflicts (e.g., `my-btn`)
8. **Use CSS Variables in `:root`** for maintainability
9. **Use Design Variables + Nested Presets (5.3+)** for no-code consistency
10. **Use Custom HTML Wrappers** instead of Code Modules for structural needs
11. **Use Canvases** for off-canvas menus, popups, and staging areas
12. **Test all active breakpoints** before production
13. **Use `clamp()` for fluid responsive values** to minimize breakpoint overrides
14. **Avoid numbered classes** (`.et_pb_text_0`) — use custom classes
15. **Clear Static CSS cache** after any style changes
16. **Include `prefers-reduced-motion`** with all animations
17. **Add `:focus-visible` styles** — Divi removes default focus indicators

## Reference Files

For complete examples, see:
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/button-variants.css` — Button style variants
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/design-tokens.css` — Design system tokens template
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/animations.css` — Animation patterns with reduced-motion
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/dark-mode.css` — System-aware dark mode
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/woocommerce.css` — WooCommerce styling patterns
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/accessibility.css` — WCAG 2.1 AA accessibility fixes
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/responsive-7-breakpoints.css` — Full 7-breakpoint responsive template (2025)
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/loop-builder.css` — Loop Builder CSS Grid patterns, masonry, product cards, pagination
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/forms.css` — Form styling with Divi 5.3 pseudo-class editing, Contact Form 7
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/new-modules.css` — Styling for the 5 new 5.6 modules (Timeline, Breadcrumbs, SVG, TOC, Instagram Feed)
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/references/divi-selectors.md` — Complete selector reference
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/references/responsive-breakpoints-2025.md` — 2025 breakpoint research and device statistics
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-compatibility/references/unit-conversions.md` — CSS unit reference (in the compatibility skill)
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/SKILL.md` — Performance optimization patterns (Critical CSS, Dynamic CSS, font loading)
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/references/core-web-vitals.md` — Full Core Web Vitals reference
