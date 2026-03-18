# Divi 5 Unit Reference

## Unit Support in Divi 5

Divi 5 renders standard HTML without Shadow DOM, so **all valid CSS units work** in custom CSS, Code Modules, Free-Form CSS, and child theme stylesheets.

The Divi builder's **unit picker dropdown** has a limited selection, but **advanced input mode** and **custom CSS fields** accept any CSS unit.

### Unit Picker Dropdown

| Unit | In Dropdown |
|------|-------------|
| `px`, `%`, `em`, `rem`, `vw`, `vh` | Yes |
| `in`, `mm`, `cm`, `pt`, `pc` | Yes |

### Advanced/Freeform Mode (All Work)

| Unit | Notes |
|------|-------|
| `ch` | Character width — works in freeform, not in dropdown |
| `ex` | x-height — works in freeform, not in dropdown |
| `dvh`, `svh`, `lvh` | Dynamic/small/large viewport height |
| `vmin`, `vmax` | Viewport min/max |
| `cap`, `ic`, `lh`, `rlh` | Newer CSS units — browser support varies |

## When to Use Each Unit

| Use Case | Recommended Unit | Why |
|----------|-----------------|-----|
| Text width (readability) | `ch` or `rem` | `ch` is ideal for line length; `rem` as fallback |
| Spacing/padding | `rem` or `em` | Scales with root/parent font size |
| Responsive sizing | `clamp()` with `vw` | Fluid without breakpoints |
| Full-width elements | `%` or `vw` | Viewport-relative |
| Typography | `rem` or `clamp()` | Consistent scaling |
| Borders/small values | `px` | Precise control |

## Character Unit (ch) Conversion Table

If targeting the builder's unit picker (which lacks `ch`), use this table:

| ch Value | rem Approx | Pixels (~) | Use Case |
|----------|------------|------------|----------|
| 30ch | 24rem | 384px | Narrow columns |
| 45ch | 36rem | 576px | Medium text blocks |
| 60ch | 48rem | 768px | Wide text blocks |
| 65ch | 52rem | 832px | Ideal line length |
| 75ch | 60rem | 960px | Max width text |

**Formula:** `rem ≈ ch × 0.8` (varies by font)

## CSS Functions (All Supported)

```css
/* All of these work in Divi 5 builder fields and custom CSS */
width: calc(100% - 2rem);
font-size: clamp(1rem, 2vw + 0.5rem, 2rem);
padding: min(3rem, 5vw);
gap: max(1rem, 2vw);
color: var(--my-color);
```

## Fluid Responsive Patterns

Use `clamp()` to reduce breakpoint-specific CSS:

```css
/* Fluid font size: 1rem at small screens, 2rem at large */
font-size: clamp(1rem, 2vw + 0.5rem, 2rem);

/* Fluid padding: 1rem minimum, 4rem maximum */
padding: clamp(1rem, 3vw, 4rem);

/* Fluid gap: scales with viewport */
gap: clamp(1rem, 2vw, 3rem);

/* Fluid max-width for readable text */
max-width: clamp(20rem, 90%, 60rem);
```

## Quick Reference

| Scenario | Pattern |
|----------|---------|
| Text width in custom CSS | `max-width: 65ch;` |
| Text width in builder field | `max-width: 52rem;` (ch not in dropdown) |
| Responsive font | `font-size: clamp(1rem, 2vw + 0.5rem, 2rem);` |
| Responsive padding | `padding: clamp(1rem, 3vw, 4rem);` |
| Line height | `line-height: 1.5;` (unitless preferred) |
