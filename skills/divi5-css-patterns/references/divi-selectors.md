# Divi 5 CSS Selectors Reference

## Module Selectors

### Layout Modules
| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_section` | Section | Outer container |
| `.et_pb_row` | Row | Inner container |
| `.et_pb_column` | Column | Grid column |
| `.et_pb_column_1_2` | 1/2 Column | Specific width |
| `.et_pb_column_1_3` | 1/3 Column | Specific width |
| `.et_pb_column_1_4` | 1/4 Column | Specific width |

### Text Modules
| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_text` | Text | Text module wrapper |
| `.et_pb_text_inner` | Text Inner | Contains paragraphs |
| `.et_pb_text_inner p` | Paragraph | Target paragraphs |
| `.et_pb_module h1` | H1 | Heading level 1 |
| `.et_pb_module h2` | H2 | Heading level 2 |
| `.et_pb_module h3` | H3 | Heading level 3 |
| `.et_pb_module h4` | H4 | Heading level 4 |

### Button Modules
| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_button` | Button | All buttons |
| `.et_pb_button:hover` | Button Hover | Hover state |
| `.et_pb_button:focus` | Button Focus | Focus state |
| `.et_pb_button_module` | Button Module | Module wrapper |

### Image Modules
| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_image` | Image | Image module |
| `.et_pb_image_wrap` | Image Wrap | Image container |

### Blurb Modules
| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_blurb` | Blurb | Blurb module |
| `.et_pb_blurb_content` | Blurb Content | Content area |
| `.et_pb_main_blurb_image` | Blurb Image | Icon/image area |

### Other Common Modules
| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_promo` | CTA | Call to action |
| `.et_pb_contact_form` | Contact Form | Form module |
| `.et_pb_accordion` | Accordion | Accordion module |
| `.et_pb_tabs` | Tabs | Tabs module |
| `.et_pb_slider` | Slider | Slider module |
| `.et_pb_gallery` | Gallery | Gallery module |
| `.et_pb_video` | Video | Video module |
| `.et_pb_divider` | Divider | Divider line |
| `.et_pb_social_media` | Social | Social icons |

## Section Types

| Selector | Type | Notes |
|----------|------|-------|
| `.et_pb_section` | Regular | Default section |
| `.et_pb_fullwidth_section` | Fullwidth | Full-width section |
| `.et_pb_specialty_section` | Specialty | Custom layout |

## Common Override Patterns

### Button Override (Recommended)
```css
body .et_pb_button {
  background-color: #000000 !important;
  /* All properties need !important */
}
```

### Section Override
```css
.et_pb_section.my-class {
  background-color: #1d1f22 !important;
}
```

### Text Override
```css
.et_pb_text.my-class .et_pb_text_inner p {
  max-width: 60rem;
  color: #222222;
}
```

### Heading Override
```css
body .et_pb_module h2 {
  font-family: 'Playfair Display', serif !important;
  color: #3f445e !important;
}
```

## Responsive Selectors

Divi adds classes for responsive states:

| Selector | Breakpoint |
|----------|------------|
| `.et_mobile_device` | Mobile device |
| `.et_tablet_device` | Tablet device |

## Divi 5 Specific

### Flexbox Layout Classes
```css
.et_pb_row {
  display: flex;
  flex-wrap: wrap;
}
```

### CSS Grid (When Enabled)
```css
.et_pb_row.et_pb_row--grid {
  display: grid;
}
```

## Tips for Overriding

1. **Always use `body` prefix** for buttons
2. **Use `!important`** on Divi module styles
3. **Be specific** - use custom classes when possible
4. **Test all breakpoints** - Divi has 7 breakpoints
5. **Check DevTools** - See what Divi applies inline
