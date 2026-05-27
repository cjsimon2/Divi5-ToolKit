# Core Web Vitals Reference (Divi 5, 2026)

Comprehensive reference for diagnosing and fixing Core Web Vitals issues on Divi 5 sites. For the strategy overview see the parent skill at `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/SKILL.md`.

## The Three Metrics

| Metric | Measures | Target (good) | Target (needs improvement) | Target (poor) |
|--------|----------|--------------|----------------------------|---------------|
| **LCP** (Largest Contentful Paint) | Time until the largest visible element renders | ≤ 2.5s | 2.5s – 4.0s | > 4.0s |
| **INP** (Interaction to Next Paint) | Slowest interaction latency on the page | ≤ 200ms | 200ms – 500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | Sum of unexpected layout shifts over page lifetime | ≤ 0.1 | 0.1 – 0.25 | > 0.25 |

INP replaced FID (First Input Delay) on March 12, 2024. FID is no longer a Core Web Vital.

Source: [web.dev/vitals](https://web.dev/vitals/)

## LCP: Largest Contentful Paint

### What the LCP element is

The LCP element is the largest visible element painted in the viewport during the loading phase. Candidates:

- `<img>` and `<svg>` elements
- `<video>` poster images
- Background images loaded via `url()` in CSS
- Block-level text elements containing text nodes

The LCP element changes as the page loads — Chrome reports the largest at the moment user input is received or all content has settled.

### Divi-specific LCP causes

| Symptom in Lighthouse | Cause | Divi fix |
|-----------------------|-------|----------|
| "Largest Contentful Paint element" is the hero image, > 2.5s | Hero image not preloaded; lazy-loaded | Set `fetchpriority="high"` on the Image Module (Advanced → Attributes); add `<link rel="preload" as="image">` in Theme Builder header |
| "Largest Contentful Paint element" is the H1, > 2.5s | Heading font not preloaded; FOIT or slow FOUT | Preload heading font WOFF2; set `font-display: swap` |
| "Eliminate render-blocking resources" flags `style.css` | Critical CSS or Inline Stylesheets disabled | Theme Options → Builder → Advanced → Performance → enable both |
| "Reduce unused CSS" flags `style.css` | Dynamic CSS disabled, or RUCSS plugin breaking Divi | Enable Dynamic CSS; if using WP Rocket RUCSS, safelist `.et_pb_*` |
| "Largest Contentful Paint image was lazily loaded" | Plugin auto-applied `loading="lazy"` to hero | Exclude hero image URL from lazy-load plugin; set `loading="eager"` |
| "Preload Largest Contentful Paint image" suggestion | Hero is a background image | Move to `<img>` element OR add `<link rel="preload" as="image">` |
| Hero is a video poster, > 2.5s | Video preloaded entirely | Set `preload="metadata"` on the Video Module; use a dedicated poster image |

### Universal LCP fixes

1. Preload the LCP image
2. Preload the heading font
3. Set `fetchpriority="high"` on the LCP image
4. Use WebP (50-70% smaller than JPEG at same quality)
5. Use a CDN for image delivery
6. Ensure the server responds in < 200ms (TTFB)

## INP: Interaction to Next Paint

### What INP measures

INP measures the latency of every user interaction (click, tap, keypress) and reports the longest. A single bad interaction can ruin INP.

The interaction latency is the time from input to the next paint that reflects a visual response.

### Divi-specific INP causes

| Symptom | Cause | Divi fix |
|---------|-------|----------|
| Menu click slow | Heavy jQuery menu script | Theme Options → Performance → Defer jQuery |
| First scroll janky | Animation modules with scroll triggers | Use CSS animations on `transform`/`opacity` only (compositor properties) |
| Form submit > 500ms | Synchronous validation in builder JS | Use HTML5 form validation; defer custom JS |
| Search filter laggy | Live-filtering a large Loop Builder result set | Debounce input (300ms); paginate results |
| Mobile menu open jank | Long task in main thread on tap | Move expensive work to `requestIdleCallback`; preload menu HTML |
| Carousel swipe drops frames | Layout thrash in swipe handler | Use CSS scroll-snap instead of JS carousel where possible |

### Universal INP fixes

1. Break up long tasks (> 50ms) with `setTimeout` / `scheduler.yield`
2. Use `transform` and `opacity` for animations (avoid layout/paint)
3. Use `content-visibility: auto` for off-screen sections
4. Avoid synchronous third-party scripts on interactive elements
5. Use `passive: true` on scroll/touch event listeners

## CLS: Cumulative Layout Shift

### What CLS counts

A layout shift occurs when a visible element changes its position from one rendered frame to the next. CLS is the sum of the largest burst of shifts within a 5-second session window.

Shifts are weighted by impact fraction (how much of the viewport moved) and distance fraction (how far things moved).

### Divi-specific CLS causes

| Symptom | Cause | Divi fix |
|---------|-------|----------|
| Hero image causes shift | No reserved space | Set Aspect Ratio (5.5+) in Sizing options |
| Text reflows when font loads | Web font swap with different metrics | Set `size-adjust`/`ascent-override`/`descent-override` on `@font-face` |
| Sticky header pops in | `position: sticky` applied via JS | Apply sticky CSS server-side (Theme Options → Custom CSS) |
| Ad slot pushes content down | No reserved space for ad | Set `min-height` matching expected ad size |
| Cookie banner shifts content | Inserted after layout | Position cookie banner with `position: fixed` |
| Loop Builder items shift | Images load with intrinsic dimensions later | Set Aspect Ratio on Loop image module; or set `width`/`height` attributes |
| Section Divider shifts during load | Divider rendered via JS | Use Divi's native section dividers (rendered server-side) |
| Animations on scroll | `transition` properties that affect layout | Animate `transform` and `opacity` only |

### Universal CLS fixes

1. Always specify image/video dimensions OR use `aspect-ratio` CSS
2. Reserve space for dynamically inserted content
3. Don't insert content above existing content (except in response to user interaction)
4. Use `transform` for animations (doesn't trigger layout)
5. Use `font-display: optional` or metric overrides to prevent font swap shift

## Diagnostic Tools

### In-browser

| Tool | What it shows |
|------|---------------|
| **Chrome DevTools → Performance** | Frame-by-frame timeline. Layout shifts highlighted. INP per-interaction breakdown. |
| **Chrome DevTools → Lighthouse** | Synthetic CWV report with specific fix suggestions. |
| **Chrome DevTools → Coverage** | Unused CSS/JS per file. Run on a typical page. |
| **Chrome DevTools → Network** | Waterfall view. Identifies render-blocking resources by their position before the LCP. |
| **Chrome DevTools → Web Vitals extension** | Real-time CWV overlay as you interact with the page. |

### Real-user monitoring (RUM)

| Tool | What it provides |
|------|------------------|
| **Google Search Console → Core Web Vitals report** | Field data from real Chrome users. URLs grouped by status. |
| **PageSpeed Insights** | Lab + field data side-by-side. The field "Origin Summary" is the truth. |
| **CrUX Dashboard** (datastudio.google.com/c/u/0/navigation/reporting) | 28-day rolling CWV by origin. |

### Lab-data caveats

Lighthouse runs on a single throttled simulation. Field data from real users (PageSpeed Insights "Field Data" section, or Search Console) is what Google uses for ranking. A green Lighthouse score with red field data means your real users have a worse experience than the lab predicts.

## Performance Budgets (suggested)

| Resource | Target |
|----------|--------|
| Total HTML | < 50 KB compressed |
| Critical CSS (inlined) | ≤ 14 KB compressed |
| Total CSS | < 100 KB compressed |
| Total JS | < 200 KB compressed |
| Total images (above the fold) | < 500 KB |
| Total page weight | < 1.5 MB |
| Number of requests | < 50 |
| Time to Interactive | < 3.5s on 4G mobile |

## Divi-Specific Performance Settings Reference

Theme Options → Builder → Advanced → Performance:

| Setting | Default | Recommended | Effect |
|---------|---------|-------------|--------|
| Dynamic CSS | On | **On** | Per-page CSS, only modules used on the page |
| Critical CSS | On | **On** | Auto-extract above-the-fold, defer rest |
| Critical Threshold Height | 1500px | 1500–2500px | Larger = more inlined critical, larger initial payload |
| Inline Stylesheets | On | **On** | Inline the per-page CSS instead of external link |
| Defer Generated CSS | On | **On** | Loaded after first paint |
| Improve Google Fonts Loading | On | **Off** (use local fonts instead) | Adds `display=swap` but still external request |
| Load Dynamic Stylesheet In-line | On | **On** | Inlines instead of separate file |
| Defer jQuery And jQuery Migrate | Off | **On** (test first) | Significantly improves INP, may break poorly-written third-party plugins |
| Defer Gutenberg Block CSS | Off | **On** (Divi sites don't use blocks) | Removes ~10KB from every page |

## Plugin Compatibility Matrix

| Plugin | Verdict | Notes |
|--------|---------|-------|
| **Perfmatters** | Best fit for Divi 5 | Lazy-load CSS backgrounds, script manager, preload links — all complement Divi's pipeline |
| **WP Rocket** | Compatible with care | Disable RUCSS or safelist `.et_pb_*`. Disable "Load CSS Asynchronously" |
| **LiteSpeed Cache** | Compatible | Disable CSS/JS Combine (Divi's per-page CSS is already optimal) |
| **Autoptimize** | Avoid | Conflicts with Divi's pipeline more than it helps |
| **WP-Optimize** | Avoid CSS minification, OK for cache | Caching works; CSS minification breaks Dynamic CSS |
| **Hummingbird** | OK for caching, disable Asset Optimization | Same issue as Autoptimize |
| **W3 Total Cache** | OK for page/object cache, avoid minify | Same |
| **Smush / ShortPixel / Imagify** | Use one for image optimization | WebP conversion is the high-value feature |

## Reference Files

- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/SKILL.md` — Strategy overview
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/examples/critical-css.css` — Critical CSS template
- `${CLAUDE_PLUGIN_ROOT}/skills/divi5-performance/examples/font-loading.css` — Local font loading template

## Sources

- [web.dev: Core Web Vitals](https://web.dev/vitals/)
- [web.dev: INP overview](https://web.dev/inp/)
- [Divi Dynamic CSS & Frontend Performance](https://help.elegantthemes.com/en/articles/5502417-divi-dynamic-css-frontend-performance-feature)
- [Divi Critical CSS Explained](https://www.elegantthemes.com/blog/divi-resources/divi-critical-css)
- [Speeding Up Divi From Every Angle](https://www.elegantthemes.com/blog/theme-releases/divi-performance)
- [Speed Up Your Slow Divi Website In 22 Steps (2026)](https://onlinemediamasters.com/divi-slow-loading-website/)
- [Core Web Vitals 2026: INP, LCP & CLS Guide](https://www.digitalapplied.com/blog/core-web-vitals-2026-inp-lcp-cls-optimization-guide)
