---
name: Divi 5 Performance
description: Use this skill when optimizing Divi 5 site performance, improving Core Web Vitals (LCP, INP, CLS), reducing render-blocking CSS, working with Divi's Critical CSS / Dynamic CSS / Inline Stylesheet system, configuring font loading (WOFF2, preload, font-display), lazy-loading background images, preloading above-the-fold images, debugging slow Divi pages, or auditing cache-plugin interactions (WP Rocket RUCSS, LiteSpeed, Autoptimize, Perfmatters). Covers Divi 5.6's per-page component CSS, Section 5.5 Aspect Ratio for CLS prevention, and the per-module helper class pattern for lazy-loading.
user-invocable: false
---

# Divi 5 Performance Optimization

**Divi 5 Version:** 5.6.0 (May 2026)
**Core Web Vitals targets:** LCP < 2.5s, INP < 200ms, CLS < 0.1

## Overview

Divi 5 was rebuilt for performance. The Dynamic Framework breaks the monolithic Divi stylesheet into hundreds of small per-module components and assembles a unique per-page stylesheet on demand — pages that use 5 modules only ship the CSS for those 5 modules. Combined with Critical CSS extraction (inlined above-the-fold styles) and Inline Stylesheets (eliminates an external CSS request), Divi 5 removes all render-blocking CSS by default.

What this skill covers: the configuration knobs, the CSS patterns that make Divi 5's pipeline work well, and the integration patterns with third-party performance plugins.

## The Divi 5 Performance Pipeline

Three Theme Options work together. Enable in: **Divi → Theme Options → Builder → Advanced → Performance**.

| Option | What it does | When to disable |
|--------|--------------|-----------------|
| **Dynamic CSS** | Per-page stylesheet with only the CSS for modules used on that page. Replaces the monolithic `style.css`. | Only if a plugin specifically requires the full stylesheet — almost never |
| **Critical CSS** | Auto-extracts above-the-fold CSS, inlines it in `<head>`, defers the rest with `<link rel="preload" ... onload>`. | If a cache plugin's own Critical CSS is running (avoid double-work) |
| **Inline Stylesheets** | Inlines the small per-page CSS file in `<head>` instead of loading via `<link>`. Removes one render-blocking request. | If your stylesheet is unusually large (>50KB inlined hurts more than it helps) |

**Verification:** View source on a frontend page. You should see no `<link rel="stylesheet">` blocking the parser — only inline `<style>` tags and deferred preloads. Run Lighthouse and confirm "Eliminate render-blocking resources" is not flagged.

## Core Web Vitals: What Hurts You in Divi 5

### LCP (Largest Contentful Paint) — target < 2.5s

The LCP element is almost always a hero image, hero heading, or hero video poster. Top causes of slow LCP on Divi sites:

1. **Hero image not preloaded** — Divi doesn't auto-preload above-the-fold images. Fix: add `<link rel="preload" as="image" href="...">` for the hero image (Theme Builder header or a `wp_head` hook).
2. **Lazy-loaded hero image** — `loading="lazy"` on the LCP image delays it past the LCP window. Fix: set `loading="eager"` and `fetchpriority="high"` on the hero image, or exclude it from lazy-load plugins.
3. **Render-blocking fonts** — Web fonts blocking text paint. Fix: host locally, preload the heading font, set `font-display: swap`.
4. **Background image as LCP** — Browsers don't preload CSS background images. If your hero uses a `background-image`, either preload it manually or move it to an `<img>` element.

### INP (Interaction to Next Paint) — target < 200ms

Replaced FID in March 2024. Measures the slowest interaction on the page. Divi-specific causes:

1. **Heavy JavaScript on first interaction** — Divi's jQuery, slider scripts, animation scripts. Fix: enable Divi's "Defer jQuery" option, defer non-critical Divi scripts.
2. **Long animation chains** — Stagger animations on scroll/click can block the main thread. Fix: use CSS animations (compositor-only properties) instead of jQuery effects.
3. **Live filter/search modules** — Heavy DOM manipulation. Fix: debounce, paginate results.

### CLS (Cumulative Layout Shift) — target < 0.1

Divi 5.5 added **Aspect Ratio** settings on all image elements specifically to prevent CLS. Use them.

1. **Images without intrinsic dimensions** — image renders, layout shifts when dimensions settle. Fix: set Aspect Ratio (5.5+) on all images, or set explicit `width`/`height` attributes.
2. **Web font swap shift** — text shifts when web font loads. Fix: use `size-adjust`, `ascent-override`, `descent-override` on `@font-face` to match fallback metrics. Or use `font-display: optional`.
3. **Dynamic content injection** — ads, related posts, comments. Fix: reserve space with `min-height` or `aspect-ratio`.
4. **Sticky modules** — `position: sticky` headers that pop in. Fix: apply sticky CSS server-side, not via JS.

## Critical CSS Strategy

Divi 5's auto-Critical CSS works for most pages. When to override:

### When to write your own Critical CSS

- Above-the-fold uses heavy `@font-face`, `clip-path`, or custom keyframes that the auto-extractor misses
- Theme Builder header has dynamic content the extractor can't analyze statically
- You need cross-page critical CSS (header, nav, footer-skeleton)

### How to add hand-crafted Critical CSS

Put it in **Theme Options → Custom CSS** (loads in `<head>` early enough to be critical). Keep it lean: ≤14KB compressed is the magic number (one TCP roundtrip).

```css
/* Critical CSS — render the hero before any external CSS loads */
.et_pb_section_0,
.et_pb_section.hero-section {
  background: linear-gradient(180deg, #0a1929 0%, #1a3a5c 100%);
  padding: 6rem 0 4rem !important;
}

.hero-section h1 {
  font-size: clamp(2.5rem, 5vw + 1rem, 4.5rem);
  color: #ffffff !important;
  margin: 0 0 1rem;
}

.hero-section .et_pb_button {
  background: #ff6b35 !important;
  border-color: #ff6b35 !important;
  padding: 1rem 2rem !important;
}
```

See `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/examples/critical-css.css` for full template.

## Font Loading Strategy

Default Divi behavior loads Google Fonts via external request. This costs LCP and CLS. **Always host fonts locally** for production.

### Steps

1. **Disable Google Fonts in Divi** — Theme Options → General → Use Google Fonts → No
2. **Download only used weights** from google-webfonts-helper or Google Fonts
3. **Convert to WOFF2** (smallest format, broad support)
4. **Define in CSS:**

```css
@font-face {
  font-family: 'Inter';
  font-style: normal;
  font-weight: 400;
  font-display: swap;       /* show fallback immediately */
  src: url('/wp-content/fonts/inter-400.woff2') format('woff2');
  /* Metric overrides to reduce CLS on swap */
  size-adjust: 107%;
  ascent-override: 90%;
  descent-override: 22%;
}
```

5. **Preload the heading font** (the one in the LCP element):

```html
<link rel="preload" href="/wp-content/fonts/inter-700.woff2" as="font" type="font/woff2" crossorigin>
```

Add via `wp_head` action or Theme Builder header HTML block.

See `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/examples/font-loading.css` for full pattern.

## Image Optimization

### Lazy-load background images (Divi-specific)

Divi modules with `background-image` styles don't lazy-load by default — browsers can't see CSS background images until parse. Use a helper class to defer them:

```css
/* In Theme Options → Custom CSS */
.et_pb_section.lazy-bg {
  background-image: none !important;
}

.et_pb_section.lazy-bg.is-visible {
  background-image: var(--bg-image) !important;
}
```

```js
/* Add a tiny IntersectionObserver to flip the class */
const lazyBgEls = document.querySelectorAll('.lazy-bg');
const io = new IntersectionObserver((entries) => {
  entries.forEach((e) => {
    if (e.isIntersecting) {
      e.target.classList.add('is-visible');
      io.unobserve(e.target);
    }
  });
}, { rootMargin: '200px' });
lazyBgEls.forEach((el) => io.observe(el));
```

Or use **Perfmatters** (lazy-load CSS backgrounds setting) or **WP Rocket**'s LazyLoad if you don't want custom JS.

### Above-the-fold images: preload + eager

```html
<!-- In Theme Builder header HTML or wp_head -->
<link rel="preload" as="image" href="/wp-content/uploads/hero.webp" fetchpriority="high">
```

In the Image Module's Advanced tab → Attributes, add `fetchpriority="high"` and `loading="eager"`.

### Aspect Ratio (Divi 5.5+) — eliminates CLS

For every image module, set Sizing → Aspect Ratio. The browser reserves space before the image loads, no shift on paint.

| Use case | Aspect Ratio |
|----------|--------------|
| Hero banner | 21:9 or 16:9 |
| Card thumbnail | 4:3 or 3:2 |
| Product photo | 1:1 |
| Portrait | 3:4 or 4:5 |

## Cache Plugin Interactions

### WP Rocket

| Setting | Recommendation | Notes |
|---------|---------------|-------|
| File Optimization → Minify CSS | On | Compatible |
| File Optimization → Remove Unused CSS (RUCSS) | Off OR Safelist `/et-cache/`, `.et_pb_*` | RUCSS removes Divi's Dynamic CSS, breaks site |
| File Optimization → Load CSS Asynchronously | Off (Divi already handles this) | Avoid double-work |
| Media → LazyLoad images | On | Excludes already-eager images |

### LiteSpeed Cache

- Enable Object Cache (Redis/Memcached)
- ESI on Cart/Checkout for WooCommerce
- CSS/JS Combine OFF for Divi 5 (per-page CSS already optimal)

### Autoptimize

- Generally avoid with Divi 5 — Divi's pipeline supersedes most Autoptimize features
- If using: disable JS aggregation (Divi defers its own JS), disable CSS aggregation

### Perfmatters

- Most Divi-friendly performance plugin
- Use for: lazy-load CSS backgrounds, script manager (disable WooCommerce JS on non-shop pages), preload links

## Auditing Checklist

Before declaring a Divi site "fast":

- [ ] Lighthouse Performance ≥ 90 on mobile (4G throttle)
- [ ] LCP < 2.5s on hero page (test the heaviest landing page)
- [ ] CLS < 0.1 across full page scroll
- [ ] INP < 200ms on primary interaction (menu open, button click, form submit)
- [ ] No render-blocking CSS in Coverage tab (Chrome DevTools)
- [ ] No external Google Fonts requests in Network tab
- [ ] Hero image is `fetchpriority="high"` and not lazy-loaded
- [ ] All images have explicit `width`/`height` or Aspect Ratio
- [ ] Total transferred page weight < 1.5MB (excluding video)
- [ ] No JS errors in Console

Run the `divi5-performance` agent on a project for an automated walkthrough.

## When Custom CSS Hurts Performance

| Pattern | Why it's slow | Fix |
|---------|---------------|-----|
| `*` selectors with expensive properties | Repaints entire tree on layout | Scope to specific elements |
| `transform` on `transition: all` | Triggers all property transitions | `transition: transform 0.3s` only |
| `box-shadow` on hover via JS | Triggers paint | Pre-define the shadow, only transition `opacity` of a pseudo-element |
| `filter: blur()` on large elements | GPU-heavy | Apply to small overlays, not full-section backgrounds |
| `position: fixed` with frequent layout updates | Triggers compositor layers | Use `will-change: transform` and animate `transform` only |
| Web font as `font-family` fallback chain miss | Layout shift on swap | Set `size-adjust`/`ascent-override` (see Font Loading section) |

## Common Misconfigurations

### "Divi is slow because of jQuery"
Often blamed, rarely the cause in 5.x. Profile in DevTools Performance tab before blaming jQuery. Most "Divi is slow" issues are unoptimized images or external scripts (analytics, chat widgets, ad networks), not Divi itself.

### "Critical CSS is breaking my site"
Divi's Critical CSS sometimes misses elements that render just below the fold on tablet. Symptoms: flash of unstyled content (FOUC) on a specific module. Fix: add that module's selectors to Theme Options → Custom CSS so they're loaded in the critical bucket.

### "My PageSpeed score dropped after adding the Theme Builder header"
Theme Builder content is dynamically injected — Critical CSS may not include header styles. Add header CSS to Theme Options Custom CSS to make it critical.

## Reference Files

- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/examples/critical-css.css` — Hand-crafted critical CSS template
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/examples/font-loading.css` — Local @font-face with CLS-prevention overrides
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/references/core-web-vitals.md` — Full Core Web Vitals reference with Divi-specific causes and fixes

## Resources

- [Divi Dynamic CSS Documentation](https://help.elegantthemes.com/en/articles/5502417-divi-dynamic-css-frontend-performance-feature)
- [Divi Critical CSS Explained](https://www.elegantthemes.com/blog/divi-resources/divi-critical-css)
- [Speed Up Divi: 22 Steps](https://onlinemediamasters.com/divi-slow-loading-website/)
- [web.dev Core Web Vitals](https://web.dev/vitals/)
- [Core Web Vitals 2026 Guide](https://www.digitalapplied.com/blog/core-web-vitals-2026-inp-lcp-cls-optimization-guide)
