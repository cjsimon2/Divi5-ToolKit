---
name: scaffold
description: Generate complete Divi 5 page section templates (hero, pricing, testimonials, FAQ, CTA, etc.) with best-practice CSS, responsive design, and accessibility baked in.
argument-hint: <section-type>
allowed-tools: Read, Write, Glob, Grep, WebSearch, WebFetch
---

# Divi 5 Section Scaffold Generator

You are generating complete, production-ready Divi 5 page section templates. Each scaffold includes CSS, class naming, responsive behavior, accessibility attributes, and step-by-step builder instructions.

## When to Research

The built-in scaffolds in this command cover the common cases. Use `WebFetch` or `WebSearch` only when:
- The user requests a section type that isn't covered by the built-in templates (Step 1 menu)
- You need to verify a specific Divi 5.2 selector, class name, or new module behavior
- You're unsure whether a CSS feature is currently supported in the builder vs. only via custom CSS

Prefer official sources: `help.elegantthemes.com`, `elegantthemes.com/blog`, `victorduse.com/divi-5-changelog`. Do not research for general CSS knowledge — only Divi-specific facts.

## Step 1: Identify Section Type

If the user hasn't specified, present this menu:

| # | Section | Description |
|---|---------|-------------|
| 1 | **Hero** | Full-width hero with heading, subheading, CTA buttons, optional background |
| 2 | **Feature Grid** | 3- or 4-column feature/blurb cards with icons |
| 3 | **Pricing Table** | 2-4 tier pricing comparison |
| 4 | **Testimonials** | Carousel or grid of customer quotes |
| 5 | **FAQ Accordion** | Expandable question/answer toggles |
| 6 | **CTA Banner** | Call-to-action strip with heading + button |
| 7 | **Team Grid** | Team member cards with photos and roles |
| 8 | **Stats Counter** | Animated number counters with labels |
| 9 | **Logo Bar** | Client/partner logo carousel or grid |
| 10 | **Contact Section** | Contact form with info sidebar |
| 11 | **Footer** | Multi-column footer with links, social, copyright |
| 12 | **WooCommerce Product Grid** | Loop Builder product layout with CSS Grid |
| 13 | **Off-Canvas Menu** | Canvas-based slide-out navigation |
| 14 | **Popup Modal** | Canvas Portal popup with overlay |

Ask about:
1. **Color scheme** — dark, light, or brand colors? *(Defaults to the project's `scaffold_style` config if set — see Step 2.)*
2. **Output format** — Theme Options, Code Module, Child Theme, or Free-Form CSS? *(Defaults to `default_format` if set.)*
3. **Any customization** — specific fonts, spacing, content?

## Step 2: Read Project Config

Read `.claude/divi5-toolkit.local.md` if it exists. Apply these settings (use defaults if missing):

```yaml
css_prefix: my                # custom class prefix (defaults to "my")
default_format: theme-options # output format default
scaffold_style: light         # "light" | "dark" | "brand" — color scheme default
active_breakpoints:           # which breakpoints to target
  - phone
  - tablet
  - desktop
```

**Behavior:**
- If the user did not specify a color scheme in Step 1, use `scaffold_style`. If unset, default to `light`.
- If the user did not specify an output format in Step 1, use `default_format`.
- Use `css_prefix` for all custom classes in the generated CSS (substitute `{prefix}` placeholders).
- Generate responsive CSS only for breakpoints listed in `active_breakpoints`.

Also check for existing design tokens (CSS variables) in the project and reuse them where possible.

## Step 3: Generate the Scaffold

Each scaffold MUST include all of the following:

### A. CSS with Design Tokens
```css
/* ==========================================================================
   [Section Name] — Scaffold
   Format: [output format]
   Generated: [date]

   SETUP:
   1. [Where to paste CSS]
   2. [How to add classes in builder]
   ========================================================================== */

/* Design tokens (merge into existing :root if present) */
:root {
  /* Section-specific variables */
}

/* Section styles */
```

### B. Class Map
Document every custom class and where to apply it:

```
CLASS MAP:
┌─────────────────────┬──────────────┬─────────────────────┐
│ Class               │ Apply To     │ Via                  │
├─────────────────────┼──────────────┼─────────────────────┤
│ {prefix}-hero       │ Section      │ Advanced > Attributes│
│ {prefix}-hero__title│ Text Module  │ Advanced > Attributes│
└─────────────────────┴──────────────┴─────────────────────┘
```

### C. Responsive Behavior
- Use `clamp()` for fluid values
- Include media queries only for layout shifts
- Test against the project's active breakpoints

### D. Accessibility Checklist
Every scaffold must address:
- [ ] Semantic Elements set (section, nav, header, etc.)
- [ ] Color contrast meets WCAG 2.1 AA (4.5:1 for text, 3:1 for large text)
- [ ] Focus indicators visible for interactive elements
- [ ] ARIA attributes added via Attributes panel where needed
- [ ] Touch targets minimum 44x44px for mobile
- [ ] `prefers-reduced-motion` respected for animations

### E. Builder Instructions
Step-by-step instructions for recreating in the Visual Builder:

```
BUILDER SETUP:
1. Add a [Section type] section
2. Set Element Type to <section> via Advanced > HTML > Element Type
3. Add class "{prefix}-[name]" via Advanced > Attributes
4. Add [Row configuration]
5. Add [Modules with specific settings]
6. Configure responsive visibility for each breakpoint
```

### F. Interaction Notes (if applicable)
For sections using Canvas, Interactions, or dynamic content:
- Canvas setup instructions
- Interaction trigger configuration
- Canvas Portal placement

## Step 4: Validate the Scaffold

Before presenting, verify:
- [ ] All button overrides have `body` prefix and `!important`
- [ ] CSS Variables in `:root`
- [ ] Correct format wrapping (style tags for Code Module, none for Theme Options)
- [ ] Custom classes used (no numbered selectors)
- [ ] Hover/focus states for all interactive elements
- [ ] Font families have fallbacks
- [ ] Fluid responsive values where appropriate
- [ ] Accessibility attributes documented

## Section Templates

### Hero Section
```css
.{prefix}-hero {
  position: relative;
  min-height: clamp(60vh, 70vh, 90vh);
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  overflow: hidden;
}

.{prefix}-hero__title {
  font-size: clamp(2rem, 5vw + 1rem, 4.5rem);
  font-weight: 700;
  line-height: 1.1;
  letter-spacing: -0.02em;
}

.{prefix}-hero__subtitle {
  font-size: clamp(1rem, 1.5vw + 0.5rem, 1.375rem);
  max-width: 60ch;
  opacity: 0.85;
  margin-top: var(--space-4, 1rem);
}

body .et_pb_button.{prefix}-hero__cta {
  padding: 1em 2.5em !important;
  font-size: clamp(0.875rem, 1vw, 1.125rem) !important;
  letter-spacing: 3px !important;
  text-transform: uppercase !important;
  transition: all 0.3s ease !important;
}
```

### Feature Grid
```css
.{prefix}-features {
  padding: clamp(3rem, 6vw, 6rem) 0;
}

.{prefix}-features .et_pb_row {
  display: grid !important;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)) !important;
  gap: clamp(1.5rem, 3vw, 2.5rem) !important;
}

.et_pb_blurb.{prefix}-feature-card {
  background: var(--color-light-gray, #f5f5f5);
  border-radius: var(--radius-md, 8px);
  padding: clamp(1.5rem, 3vw, 2.5rem);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.et_pb_blurb.{prefix}-feature-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg, 0 10px 40px rgba(0,0,0,0.15));
}

@media (prefers-reduced-motion: reduce) {
  .et_pb_blurb.{prefix}-feature-card:hover {
    transform: none;
  }
}
```

### Pricing Table
```css
.{prefix}-pricing {
  padding: clamp(3rem, 6vw, 6rem) 0;
}

.{prefix}-pricing .et_pb_row {
  display: grid !important;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)) !important;
  gap: 2rem !important;
  align-items: start !important;
}

.et_pb_pricing.{prefix}-price-card {
  border-radius: var(--radius-md, 8px);
  overflow: hidden;
  transition: transform 0.3s ease;
}

.et_pb_pricing.{prefix}-price-card--featured {
  transform: scale(1.05);
  box-shadow: var(--shadow-xl, 0 20px 60px rgba(0,0,0,0.2));
  z-index: 1;
}

@media (max-width: 767px) {
  .et_pb_pricing.{prefix}-price-card--featured {
    transform: none;
  }
}
```

### FAQ Accordion
```css
.{prefix}-faq {
  max-width: var(--max-width-text, 60rem);
  margin: 0 auto;
  padding: clamp(3rem, 6vw, 6rem) var(--space-4, 1rem);
}

.et_pb_toggle.{prefix}-faq__item {
  border: 1px solid rgba(0,0,0,0.1) !important;
  border-radius: var(--radius-md, 8px) !important;
  margin-bottom: var(--space-3, 0.75rem) !important;
  overflow: hidden;
}

.et_pb_toggle.{prefix}-faq__item .et_pb_toggle_title {
  font-weight: 600 !important;
  padding: var(--space-5, 1.25rem) var(--space-6, 1.5rem) !important;
}

.et_pb_toggle.{prefix}-faq__item .et_pb_toggle_content {
  padding: 0 var(--space-6, 1.5rem) var(--space-5, 1.25rem) !important;
  line-height: 1.7;
}
```

### Off-Canvas Menu (Canvas-based)
```css
/* Off-Canvas Menu — uses Divi 5 Canvas system */
.{prefix}-offcanvas-menu {
  position: fixed;
  top: 0;
  left: -100%;
  width: min(80vw, 400px);
  height: 100vh;
  background: var(--color-dark-section, #1d1f22);
  z-index: var(--z-fixed, 1030);
  transition: left 0.4s cubic-bezier(0.22, 1, 0.36, 1);
  overflow-y: auto;
  padding: var(--space-8, 2rem);
}

.{prefix}-offcanvas-menu.is-open {
  left: 0;
}

.{prefix}-offcanvas-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  z-index: calc(var(--z-fixed, 1030) - 1);
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}

.{prefix}-offcanvas-overlay.is-open {
  opacity: 1;
  pointer-events: auto;
}

@media (prefers-reduced-motion: reduce) {
  .{prefix}-offcanvas-menu {
    transition: none;
  }
}
```

### Popup Modal (Canvas Portal)
```css
/* Popup Modal — uses Divi 5 Canvas Portal */
.{prefix}-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  backdrop-filter: blur(4px);
  z-index: var(--z-modal, 1050);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}

.{prefix}-modal-overlay.is-open {
  opacity: 1;
  pointer-events: auto;
}

.{prefix}-modal-content {
  background: #ffffff;
  border-radius: var(--radius-lg, 12px);
  padding: clamp(1.5rem, 4vw, 3rem);
  max-width: min(90vw, 600px);
  max-height: 85vh;
  overflow-y: auto;
  box-shadow: var(--shadow-xl, 0 20px 60px rgba(0,0,0,0.2));
  transform: scale(0.95);
  transition: transform 0.3s ease;
}

.{prefix}-modal-overlay.is-open .{prefix}-modal-content {
  transform: scale(1);
}
```

## Step 5: Output and Next Steps

Present the complete scaffold, then offer:
1. Save CSS to file
2. Run `/divi5-toolkit:validate` to confirm compatibility
3. Generate the same section in a different format
4. Generate additional sections for a full page
5. Run `/divi5-toolkit:audit` on the generated CSS
