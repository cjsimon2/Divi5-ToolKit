# Responsive Breakpoints Reference (2025)

## Overview

This guide provides research-backed breakpoint recommendations for Divi 5 development, based on 2025 device statistics and industry best practices.

## 2025 Device Statistics

### Traffic Distribution
- **Mobile**: 62% of global web traffic
- **Desktop**: 36% of global web traffic
- **Tablet**: 1.7% of global web traffic

### Most Common Screen Widths

| Device Type | Resolution | Market Share |
|-------------|------------|--------------|
| **Mobile** | 360×800 | 10.27% |
| **Mobile** | 390×844 (iPhone 14/15) | 6.26% |
| **Mobile** | 393×873 (Pixel, iPhone 15 Pro) | 5.23% |
| **Mobile** | 375×812 (iPhone X/XS) | 4.31% |
| **Tablet** | 768×1024 (iPad portrait) | 14.24% |
| **Tablet** | 810×1080 | 10.09% |
| **Desktop** | 1920×1080 (Full HD) | 19.13% |
| **Desktop** | 1536×864 | 8.91% |
| **Desktop** | 1366×768 | 8.07% |

## Recommended 7-Breakpoint System

> **These are recommended *customized* widths, not Divi's defaults.** Out of the box,
> Divi 5 ships with Phone **767px** and Tablet **980px** active, plus Phone Wide
> **860px**, Tablet Wide **1024px**, Widescreen **1280px**, and Ultra Wide **2560px**
> available but disabled. If you keep the defaults, write media queries against
> 767px/980px (see the `divi5-compatibility` skill). The ranges below are what this
> guide recommends *changing* the widths to, based on 2025 device data.

Based on Divi 5's native breakpoint system and 2025 device data:

| # | Breakpoint | Width Range | Target Devices |
|---|------------|-------------|----------------|
| 1 | **Phone Portrait** | ≤479px | iPhone, Android phones (portrait) |
| 2 | **Phone Landscape** | 480–767px | Phones rotated, phablets |
| 3 | **Tablet Portrait** | 768–1023px | iPad portrait, Android tablets |
| 4 | **Tablet Landscape** | 1024–1279px | iPad landscape, small laptops |
| 5 | **Desktop** | 1280–1535px | Standard laptops/monitors (BASE) |
| 6 | **Widescreen** | 1536–1919px | Large monitors, high-res laptops |
| 7 | **Ultra Wide** | ≥1920px | Full HD, 4K, ultrawide monitors |

## CSS Media Query Implementation

### Desktop-First Approach (Recommended for Custom CSS)

```css
/* ========================================
   RESPONSIVE BREAKPOINTS (Desktop-First)
   ======================================== */

/* BASE: Desktop (1280–1535px) - No media query needed */

/* Ultra Wide (≥1920px) - Full HD monitors, 4K, ultrawides */
@media (min-width: 1920px) {
  /* Increase content width, adjust typography */
}

/* Widescreen (≥1536px) - Large monitors */
@media (min-width: 1536px) {
  /* Slightly larger content area */
}

/* Tablet Landscape (≤1279px) - iPad landscape, small laptops */
@media (max-width: 1279px) {
  /* Adjust grid columns, reduce padding */
}

/* Tablet Portrait (≤1023px) - iPad portrait, tablets */
@media (max-width: 1023px) {
  /* Stack columns, adjust navigation */
}

/* Phone Landscape (≤767px) - Phones rotated, phablets */
@media (max-width: 767px) {
  /* Single column, larger touch targets */
}

/* Phone Portrait (≤479px) - Small phones */
@media (max-width: 479px) {
  /* Compact layout, minimum font sizes */
}
```

### Mobile-First Approach (Alternative)

```css
/* ========================================
   RESPONSIVE BREAKPOINTS (Mobile-First)
   ======================================== */

/* BASE: Phone Portrait (≤479px) - Start here */

/* Phone Landscape (≥480px) */
@media (min-width: 480px) {
  /* Slightly wider layout */
}

/* Tablet Portrait (≥768px) */
@media (min-width: 768px) {
  /* Two-column layouts */
}

/* Tablet Landscape (≥1024px) */
@media (min-width: 1024px) {
  /* Multi-column, full navigation */
}

/* Desktop (≥1280px) */
@media (min-width: 1280px) {
  /* Full desktop layout */
}

/* Widescreen (≥1536px) */
@media (min-width: 1536px) {
  /* Extended content width */
}

/* Ultra Wide (≥1920px) */
@media (min-width: 1920px) {
  /* Maximum content width, larger typography */
}
```

## Divi 5 Breakpoint Configuration

### Enabling Additional Breakpoints

1. Open Visual Builder on any page
2. Click the **three-dot icon** next to device icons in top bar
3. Click **Sitewide Responsive Breakpoints**
4. Enable the breakpoints you need
5. Customize width values as needed

### Recommended Divi 5 Settings

| Breakpoint (this guide) | Divi 5 Name | Divi Default Width | Recommended Width |
|------------|-------------|--------------------|-------------------|
| Phone Portrait | Phone | 767px | 479px |
| Phone Landscape | Phone Wide | 860px | 767px |
| Tablet Portrait | Tablet | 980px | 1023px |
| Tablet Landscape | Tablet Wide | 1024px | 1279px |
| Desktop | Desktop | BASE | BASE |
| Widescreen | Widescreen | 1280px | 1536px |
| Ultra Wide | Ultra Wide | 2560px | 1920px |

If you adopt the recommended widths, also update any custom media queries to match.
If you keep Divi's defaults, use 767px/980px (and 860/1024/1280/2560 where enabled)
in your media queries instead of the ranges in this guide.

## Typography Scaling

### Recommended Font Sizes by Breakpoint

| Element | Phone | Tablet | Desktop | Widescreen | Ultra Wide |
|---------|-------|--------|---------|------------|------------|
| Base (html) | 14px | 15px | 16px | 17px | 18px |
| H1 | 28px | 36px | 48px | 56px | 64px |
| H2 | 24px | 28px | 36px | 42px | 48px |
| H3 | 20px | 22px | 28px | 32px | 36px |
| Body | 15px | 16px | 17px | 18px | 19px |
| Small | 12px | 13px | 14px | 15px | 16px |

### Fluid Typography with clamp()

```css
/* Modern fluid typography - reduces breakpoint CSS */
:root {
  --font-h1: clamp(1.75rem, 4vw + 1rem, 4rem);
  --font-h2: clamp(1.5rem, 3vw + 0.75rem, 3rem);
  --font-h3: clamp(1.25rem, 2vw + 0.5rem, 2.25rem);
  --font-body: clamp(0.938rem, 0.5vw + 0.875rem, 1.188rem);
}

h1 { font-size: var(--font-h1); }
h2 { font-size: var(--font-h2); }
h3 { font-size: var(--font-h3); }
body { font-size: var(--font-body); }
```

## Layout Patterns by Breakpoint

### Content Max-Width

| Breakpoint | Max-Width | Row Width |
|------------|-----------|-----------|
| Phone | 100% | 100% |
| Tablet | 720px | 100% |
| Desktop | 1140px | 80% |
| Widescreen | 1320px | 75% |
| Ultra Wide | 1500px | 70% |

### Grid Columns

| Breakpoint | Typical Columns |
|------------|-----------------|
| Phone Portrait | 1 column |
| Phone Landscape | 1–2 columns |
| Tablet Portrait | 2 columns |
| Tablet Landscape | 2–3 columns |
| Desktop | 3–4 columns |
| Widescreen | 4–6 columns |
| Ultra Wide | 4–6 columns |

## Touch Target Guidelines

| Breakpoint | Minimum Touch Target |
|------------|---------------------|
| Phone | 44×44px (Apple), 48×48px (Google) |
| Tablet | 44×44px |
| Desktop | 24×24px (mouse) |

## Testing Checklist

- [ ] Phone Portrait (360px, 375px, 390px, 414px)
- [ ] Phone Landscape (667px, 736px, 812px)
- [ ] Tablet Portrait (768px, 810px, 820px)
- [ ] Tablet Landscape (1024px, 1080px, 1180px)
- [ ] Desktop (1280px, 1366px, 1440px)
- [ ] Widescreen (1536px, 1680px, 1800px)
- [ ] Ultra Wide (1920px, 2560px, 3440px)

## Framework Comparison

| Framework | Breakpoints |
|-----------|-------------|
| **Divi 5 (defaults)** | 767, 860, 980, 1024, BASE, 1280, 2560 |
| **Divi 5 (this guide's recommended widths)** | 479, 767, 1023, 1279, BASE, 1536, 1920 |
| **Bootstrap 5** | 576, 768, 992, 1200, 1400 |
| **Tailwind CSS** | 640, 768, 1024, 1280, 1536 |
| **Material UI** | 600, 900, 1200, 1536 |

## Sources

- [BrowserStack: Responsive Design Breakpoints 2025](https://www.browserstack.com/guide/responsive-design-breakpoints)
- [BrowserStack: Common Screen Resolutions](https://www.browserstack.com/guide/common-screen-resolutions)
- [Elegant Themes: Divi 5 Customizable Breakpoints](https://www.elegantthemes.com/blog/divi-resources/everything-you-need-to-know-about-divi-5s-customizable-breakpoints)
- [W3Schools: Media Query Breakpoints](https://www.w3schools.com/howto/howto_css_media_query_breakpoints.asp)
- [StatCounter: Screen Resolution Stats](https://gs.statcounter.com/screen-resolution-stats)
- [NN/g: Breakpoints in Responsive Design](https://www.nngroup.com/articles/breakpoints-in-responsive-design/)
