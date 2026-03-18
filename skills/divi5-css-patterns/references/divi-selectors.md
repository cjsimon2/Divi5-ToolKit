# Divi 5 CSS Selectors Reference

## Structural Selectors

| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_section` | Section | Outer page container |
| `.et_pb_fullwidth_section` | Fullwidth Section | Full-width variant |
| `.et_pb_specialty_section` | Specialty Section | Custom layout |
| `.et_pb_row` | Row | Content row within a section |
| `.et_pb_column` | Column | Grid column within a row |
| `.et_pb_column_1_2` | 1/2 Column | Half-width column |
| `.et_pb_column_1_3` | 1/3 Column | Third-width column |
| `.et_pb_column_1_4` | 1/4 Column | Quarter-width column |
| `.et_pb_column_2_3` | 2/3 Column | Two-thirds column |
| `.et_pb_column_3_4` | 3/4 Column | Three-quarter column |
| `.et_pb_module` | Module | Generic module container |

## Content Module Selectors

### Text & Typography
| Selector | Module | Inner Selectors |
|----------|--------|-----------------|
| `.et_pb_text` | Text | `.et_pb_text_inner`, `.et_pb_text_inner p` |
| `.et_pb_module h1` | Heading H1 | Use with module prefix |
| `.et_pb_module h2` | Heading H2 | Use with module prefix |
| `.et_pb_module h3` | Heading H3 | Use with module prefix |
| `.et_pb_module h4` | Heading H4 | Use with module prefix |

### Buttons
| Selector | Module | Notes |
|----------|--------|-------|
| `.et_pb_button` | Button | Needs `body` prefix + `!important` |
| `.et_pb_button:hover` | Button Hover | Hover state |
| `.et_pb_button:focus` | Button Focus | Focus state |
| `.et_pb_button_module` | Button Module | Module wrapper |

### Media
| Selector | Module | Inner Selectors |
|----------|--------|-----------------|
| `.et_pb_image` | Image | `.et_pb_image_wrap` |
| `.et_pb_video` | Video | `.et_pb_video_overlay` |
| `.et_pb_gallery` | Gallery | `.et_pb_gallery_item` |
| `.et_pb_audio_module` | Audio | `.et_pb_audio_module_content` |

### Cards & Content Blocks
| Selector | Module | Inner Selectors |
|----------|--------|-----------------|
| `.et_pb_blurb` | Blurb | `.et_pb_blurb_content`, `.et_pb_blurb_container`, `.et_pb_main_blurb_image` |
| `.et_pb_promo` | CTA | `.et_pb_promo_description` |
| `.et_pb_testimonial` | Testimonial | `.et_pb_testimonial_description` |
| `.et_pb_pricing` | Pricing Table | `.et_pb_pricing_heading`, `.et_pb_pricing_content_top` |

### Interactive
| Selector | Module | Inner Selectors |
|----------|--------|-----------------|
| `.et_pb_toggle` | Toggle | `.et_pb_toggle_title`, `.et_pb_toggle_content` |
| `.et_pb_accordion` | Accordion | Same as Toggle |
| `.et_pb_tabs` | Tabs | `.et_pb_tab`, `.et_pb_tabs_controls` |
| `.et_pb_slider` | Slider | `.et_pb_slide`, `.et_pb_slide_content` |
| `.et_pb_countdown_timer` | Countdown | `.et_pb_countdown_timer_container` |
| `.et_pb_counter` | Counter Bar | `.et_pb_counter_container`, `.et_pb_counter_amount` |
| `.et_pb_number_counter` | Number Counter | `.percent` |

### Forms & Utility
| Selector | Module | Inner Selectors |
|----------|--------|-----------------|
| `.et_pb_contact_form` | Contact Form | `.et_pb_contact_field` |
| `.et_pb_search` | Search | `.et_pb_s` (input field) |
| `.et_pb_login` | Login | `.et_pb_login_form` |
| `.et_pb_social_media_follow` | Social Follow | `.et_pb_social_media_follow_network_link` |
| `.et_pb_blog_grid` | Blog (Grid) | `.et_pb_post`, `.et_pb_post_content` |
| `.et_pb_portfolio` | Portfolio | `.et_pb_portfolio_item` |
| `.et_pb_map` | Map | `.et_pb_map_container` |
| `.et_pb_widget_area` | Sidebar | Standard WP widget classes |
| `.et_pb_comments_module` | Comments | Standard WP comment classes |
| `.et_pb_divider` | Divider | `.et_pb_divider_internal` |
| `.et_pb_code` | Code | `.et_pb_code_inner` |

## New Divi 5 Modules

These are new modules introduced in Divi 5 (selectors may vary — inspect in DevTools):

| Module | Purpose | Notes |
|--------|---------|-------|
| Group | Container for grouping modules | Shared styles, logical structure |
| Carousel Group | Flexible slider | Any module per slide, autoplay, custom nav |
| Before/After Image | Image comparison slider | Interactive two-image compare |
| Canvas Portal | Off-canvas content | Overlays, side panels, popups, drawers |
| Dropdown | Drop-down content | Custom interactions, flexible structure |
| Icon List | Lists with icons | Per-item icons, global style management |
| Link | Standalone link | For custom navigation menus |
| Lottie | Animation module | Lottie JSON animations with controls |

## Free-Form CSS Targeting (Divi 5)

Use the `selector` keyword in Free-Form CSS fields:
```css
/* Target the current element */
selector { background: #f5f5f5; }

/* Target child elements */
selector h4 { color: red; }
selector p { max-width: 60ch; }
selector .et_pb_text_inner { padding: 20px; }

/* Pseudo-classes */
selector:hover { transform: scale(1.02); }
selector:first-child { margin-top: 0; }

/* Pseudo-elements */
selector::before { content: ''; display: block; }
```

## Override Patterns

### Button Override (Required Pattern)
```css
body .et_pb_button {
  background-color: #000000 !important;
}
body .et_pb_button:hover {
  background-color: #222222 !important;
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

## Responsive Breakpoints

| Breakpoint | Width | Active by Default |
|------------|-------|-------------------|
| Phone | 767px | Yes |
| Phone Wide | 860px | No |
| Tablet | 980px | Yes |
| Tablet Wide | 1024px | No |
| Desktop | (base) | Yes |
| Widescreen | 1280px | No |
| Ultra Wide | 2560px | No |

## Tips for Overriding

1. **Use `body` prefix** for buttons — `body .et_pb_button`
2. **Use `!important`** on Divi module styles
3. **Use custom classes** instead of numbered selectors
4. **Use Free-Form CSS** with `selector` keyword for per-element targeting
5. **Test active breakpoints** — only 3 are on by default
6. **Check DevTools** — identify which layer overrides your CSS
7. **Use Semantic Elements** to change HTML tags without code
8. **Use Custom HTML Wrappers** instead of Code Modules for structural needs
