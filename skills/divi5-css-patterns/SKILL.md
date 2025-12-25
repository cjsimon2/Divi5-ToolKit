---
name: Divi 5 CSS Patterns
description: Use this skill when the user is writing CSS for Divi 5, creating styles for WordPress/Divi, working with Divi modules, or mentions Divi theme development. Provides CSS patterns, class naming conventions, selector specificity guidance, and Divi-specific best practices.
version: 1.0.0
---

# Divi 5 CSS Development Patterns

## Overview

Divi 5 is a complete architecture overhaul featuring:
- **React-based framework** (faster, more responsive)
- **Flexbox-first layout system** (sections, rows, columns use Flexbox by default)
- **CSS Grid support** (for advanced layouts)
- **Design Variables** (native token system)
- **No shortcodes** (block-based like Gutenberg)
- **7 responsive breakpoints** (vs 3 in Divi 4)

## CSS Integration Methods

### Method 1: Theme Options (Global Styles)
**Location:** Divi -> Theme Options -> Custom CSS
**Format:** Raw CSS without `<style>` tags

```css
/* Paste directly - no tags needed */
:root {
  --custom-color: #2ea3f2;
}
```

### Method 2: Code Module (Page-Specific)
**Location:** Add Code Module to page
**Format:** CSS wrapped in `<style></style>` tags

```html
<style>
.page-specific-style {
  background-color: var(--custom-color);
}
</style>
```

### Method 3: Child Theme (Production)
**Location:** child-theme/style.css
**Format:** Standard CSS file

### Method 4: Free-Form CSS (Per-Element)
**Location:** Module -> Advanced -> Custom CSS -> Free-Form CSS
**Format:** Use `selector` keyword to target element

```css
selector {
  background-color: #1d1f22;
}
selector h2 {
  color: gold;
}
```

## Selector Specificity for Divi Overrides

Divi uses inline styles and `!important` extensively. To override:

### Standard Override Pattern
```css
/* May not work - too low specificity */
.et_pb_button {
  background-color: black;
}

/* Better - higher specificity */
body .et_pb_button {
  background-color: black !important;
}

/* Best - with custom class */
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
  font-family: 'Lato', sans-serif !important;
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
/* Dark section */
.et_pb_section.custom-dark-section {
  background-color: #1d1f22 !important;
}

.et_pb_section.custom-dark-section h1,
.et_pb_section.custom-dark-section h2,
.et_pb_section.custom-dark-section p {
  color: #ffffff !important;
}

/* Gray section */
.et_pb_section.custom-gray-section {
  background-color: rgba(150, 150, 150, 0.47) !important;
}
```

## Class Naming Convention

Use a unique prefix to avoid conflicts with Divi's classes:

| Pattern | Example | Purpose |
|---------|---------|---------|
| `{prefix}-btn` | `cjs-btn` | Button base |
| `{prefix}-btn--variant` | `cjs-btn--primary` | Button variant |
| `{prefix}-section--modifier` | `cjs-section--dark` | Section modifier |
| `{prefix}-card` | `cjs-card` | Component |

### Adding Classes in Divi 5
1. Select the module
2. Go to **Advanced Tab -> Attributes**
3. Click **Add Attribute**
4. Set **Name** to `class`
5. Set **Value** to your class

## Common Divi Module Selectors

| Module | Selector | Notes |
|--------|----------|-------|
| Button | `.et_pb_button` | Needs `body` prefix and `!important` |
| Text | `.et_pb_text`, `.et_pb_text_inner` | Inner for paragraphs |
| Blurb | `.et_pb_blurb` | Card-like modules |
| Section | `.et_pb_section` | Outer containers |
| Row | `.et_pb_row` | Inner containers |
| Column | `.et_pb_column` | Grid columns |
| Heading | `.et_pb_module h1/h2/h3` | Use module prefix |
| Image | `.et_pb_image` | Image modules |
| CTA | `.et_pb_promo` | Call-to-action |

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
/* Limit text width for optimal readability */
.et_pb_text_inner p,
.et_pb_text_inner li {
  max-width: 60rem; /* ~960px, replaces 75ch */
}

/* Center when in centered modules */
.et_pb_text_align_center .et_pb_text_inner p {
  margin-left: auto;
  margin-right: auto;
}
```

## Responsive Breakpoints

Divi 5 supports 7 breakpoints. Key ones:

```css
/* Tablet landscape */
@media (max-width: 1024px) { }

/* Tablet portrait */
@media (max-width: 980px) { }

/* Phone landscape */
@media (max-width: 767px) { }

/* Phone portrait */
@media (max-width: 479px) { }

/* Ultrawide monitors */
@media (min-width: 2560px) {
  :root { font-size: 17px; }
  .et_pb_row { max-width: 1500px !important; }
}

@media (min-width: 3440px) {
  :root { font-size: 18px; }
  .et_pb_row { max-width: 1600px !important; }
}

@media (min-width: 3840px) {
  :root { font-size: 19px; }
  .et_pb_row { max-width: 1800px !important; }
}
```

## Card Pattern
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

## Quote Block Pattern
```css
.et_pb_text.custom-quote {
  border-left: 4px solid #b2a065;
  padding-left: 2rem;
  font-family: var(--font-title);
  font-size: 1.375rem;
  font-style: italic;
}
```

## Info Box Pattern
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

## Best Practices

1. **Always use !important** when overriding Divi button and module styles
2. **Prefix all custom classes** to avoid conflicts
3. **Use CSS Variables** for maintainability (supported in Divi 5)
4. **Test on all 7 breakpoints** before production
5. **Use body prefix** for higher specificity: `body .et_pb_button`
6. **Use 60rem instead of 75ch** for text width (ch not supported)
7. **Wrap Code Module CSS** in `<style></style>` tags
8. **Theme Options CSS** goes without tags

## Reference Files

For complete examples, see:
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/`
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/references/`
