---
name: Divi 5 CSS Patterns
description: Use this skill when the user is writing CSS for Divi 5, creating styles for WordPress/Divi, working with Divi modules, or mentions Divi theme development. Provides CSS patterns, class naming conventions, selector specificity guidance, and Divi-specific best practices.
user-invocable: false
---

# Divi 5 CSS Development Patterns

## Overview

**Divi 5** (released February 26, 2026, current version 5.1.0) is a complete architecture overhaul:
- **React 18-based Visual Builder** — no Shadow DOM, standard DOM with `et_pb_*` classes
- **Flexbox-first layout** — sections, rows, columns use Flexbox by default
- **Native CSS Grid support** — convertible from Flexbox in builder
- **Design Variable Manager** — 6 variable types (Colors, Fonts, Numbers, Images, Text, Links)
- **Preset System** — Option Group, Element, Stacked, and Nested presets
- **Block-based storage** — JSON format, no shortcodes
- **7 responsive breakpoints** — 3 active by default, 4 optional
- **Dynamic CSS** — 94% smaller stylesheets, per-page CSS generation

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

Divi 5 has 7 breakpoints (3 active by default). Key ones for custom CSS:

```css
/* Tablet (default active) */
@media (max-width: 980px) { }

/* Phone (default active) */
@media (max-width: 767px) { }

/* Widescreen (must enable in builder) */
@media (min-width: 1280px) { }

/* Ultra Wide (must enable in builder) */
@media (min-width: 2560px) { }
```

**Best practice:** Use `clamp()`, `vw`, `calc()` for fluid responsive values to reduce breakpoint overrides:
```css
font-size: clamp(1rem, 2vw + 0.5rem, 2rem);
padding: clamp(1rem, 3vw, 4rem);
```

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

## Best Practices Summary

1. **Use Free-Form CSS** with `selector` keyword for per-element styling
2. **Use `body` prefix and `!important`** when overriding Divi buttons and module styles
3. **Prefix all custom classes** to avoid conflicts (e.g., `my-btn`)
4. **Use CSS Variables in `:root`** for maintainability
5. **Use Design Variables + Presets** for no-code consistency
6. **Use Custom HTML Wrappers** instead of Code Modules for structural needs
7. **Test all active breakpoints** before production
8. **Use `clamp()` for fluid responsive values** to minimize breakpoint overrides
9. **Avoid numbered classes** (`.et_pb_text_0`) — use custom classes
10. **Clear Static CSS cache** after any style changes

## Reference Files

For complete examples, see:
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/`
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/references/`
