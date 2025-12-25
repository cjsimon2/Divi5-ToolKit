# Divi 5 Unit Conversion Reference

## Character Units → REM

The `ch` unit is NOT supported in Divi 5. Use this conversion table:

| ch Value | rem Equivalent | Pixels (~) | Use Case |
|----------|----------------|------------|----------|
| 30ch | 24rem | 384px | Narrow columns |
| 45ch | 36rem | 576px | Medium text blocks |
| 60ch | 48rem | 768px | Wide text blocks |
| 65ch | 52rem | 832px | Ideal line length |
| 70ch | 56rem | 896px | Max comfortable |
| 75ch | 60rem | 960px | Max width text |
| 80ch | 64rem | 1024px | Full width text |

**Note:** Conversion assumes average character width of ~0.8rem. Actual width varies by font.

## Formula

```
rem = ch × 0.8
```

For more precision with specific fonts:
```
rem = ch × (average-char-width / root-font-size)
```

## x-height Units → EM

The `ex` unit is NOT supported in Divi 5. Use `em` instead:

| ex Value | em Equivalent | Notes |
|----------|---------------|-------|
| 1ex | 0.5em | Typical x-height ratio |
| 2ex | 1em | Double x-height |
| 3ex | 1.5em | Triple x-height |

**Formula:**
```
em = ex × 0.5
```

## Recommended Alternatives

### For Text Width (replacing ch)
```css
/* Instead of: max-width: 75ch; */
max-width: 60rem;

/* Or use clamp for responsive: */
max-width: clamp(20rem, 90%, 60rem);
```

### For Line Height (replacing ex)
```css
/* Instead of: line-height: 3ex; */
line-height: 1.5em;

/* Or use unitless: */
line-height: 1.5;
```

### For Spacing (replacing ch)
```css
/* Instead of: padding: 2ch; */
padding: 1.6rem;

/* Or use em for font-relative: */
padding: 1em;
```

## Quick Reference

| Not Supported | Use Instead |
|---------------|-------------|
| `ch` | `rem` or `em` |
| `ex` | `em` |
| `@container` | `@media` |
| `container-type` | Not yet |

## Conversion Examples

### Text Module Width
```css
/* BEFORE (won't work) */
.text-narrow {
  max-width: 45ch;
}

/* AFTER (works in Divi 5) */
.text-narrow {
  max-width: 36rem;
}
```

### Input Field Width
```css
/* BEFORE (won't work) */
input {
  width: 20ch;
}

/* AFTER (works in Divi 5) */
input {
  width: 16rem;
}
```

### Spacing
```css
/* BEFORE (won't work) */
.indent {
  text-indent: 2ch;
}

/* AFTER (works in Divi 5) */
.indent {
  text-indent: 1.6rem;
}
```
