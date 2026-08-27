---
name: responsive
description: Check that a Divi 5 page works across device sizes (small phones, iPhones, tablets, laptops, widescreen, ultrawide). Uses live viewport testing via a browser MCP server (Chrome DevTools or Playwright) when one is available; falls back to static CSS analysis when not.
argument-hint: [url-or-css-file-or-directory]
allowed-tools: Read, Glob, Grep, WebFetch, ToolSearch, mcp__chrome-devtools, mcp__playwright
---

# Divi 5 Responsive Device Check

You are verifying that a Divi 5 page (or its CSS) behaves correctly across real device sizes. **Use ultrathink mode** — responsive breakage is usually several small issues compounding, not one big one.

## Step 1: Read Project Config

Read `.claude/divi5-toolkit.local.md` if it exists. Apply (defaults if missing):

```yaml
active_breakpoints:        # which Divi breakpoints this project uses
  - phone                  # 767px (default width)
  - tablet                 # 980px (default width)
  - desktop                # base
divi_version: "5.11"
accessibility_level: aa    # aa | aaa | off — governs touch-target strictness
css_prefix: my             # used in any fix CSS you generate
```

**Important:** If the project has customized its Divi breakpoint widths (e.g., to the 2025-recommended set in `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/references/responsive-breakpoints-2025.md`), test against those widths. Ask the user if you can't tell. Divi's defaults are Phone 767 / Phone Wide 860 / Tablet 980 / Tablet Wide 1024 / Widescreen 1280 / Ultra Wide 2560.

## Step 2: Pick the Mode

1. **Live mode (preferred)** — the user gave a URL *and* a browser automation MCP server is available (Chrome DevTools MCP or Playwright MCP — check the available tools; use ToolSearch if tools are deferred). Drive a real browser through the device matrix.
2. **Static mode (fallback)** — no URL or no browser server. Analyze the project's CSS files for responsive risk patterns instead.
3. If the user gave a URL but no browser server is available: run static mode on any local CSS, then tell them live testing is one config block away — the README's **Optional MCP Servers** section has the Playwright snippet, or `npx chrome-devtools-mcp@latest` for Chrome DevTools MCP. Offer to re-run after setup.

## Step 3: The Device Matrix

Test these sizes (CSS pixels). They cover the 2025 device distribution and exercise every Divi breakpoint zone:

| # | Device class | Viewport | Exercises (Divi defaults) |
|---|-------------|----------|---------------------------|
| 1 | Small Android (Galaxy/Pixel) | 360×800 | Phone (≤767) |
| 2 | iPhone 14/15 | 390×844 | Phone (≤767) |
| 3 | iPhone Pro Max / large phone | 430×932 | Phone (≤767) |
| 4 | Phone landscape | 844×390 | Phone Wide zone + short viewport |
| 5 | iPad portrait | 810×1080 | Tablet (768–980) |
| 6 | iPad landscape / small laptop | 1024×768 | Tablet Wide zone |
| 7 | Most common laptop | 1366×768 | Desktop (base) |
| 8 | Full HD / widescreen | 1920×1080 | Widescreen (≥1280 if enabled) |
| 9 | QHD / ultrawide | 2560×1440 | Ultra Wide (≥2560 if enabled) |

Skip zones whose breakpoints aren't in `active_breakpoints` only if the user asks for a quick pass — content still renders at those sizes even when no Divi breakpoint targets them, so the full matrix is the default.

## Step 4A: Live Mode Checks

For each viewport in the matrix: resize/emulate, wait for load, screenshot, then run the checks. Test the phone sizes first — that's where Divi layouts break most.

1. **Horizontal overflow (the #1 mobile breakage).** Evaluate in the page:
   ```js
   (() => {
     const w = document.documentElement.clientWidth;
     const offenders = [...document.querySelectorAll('body *')]
       .filter(el => el.getBoundingClientRect().right > w + 1 || el.getBoundingClientRect().left < -1)
       .slice(0, 10)
       .map(el => ({ tag: el.tagName, cls: el.className?.toString?.().slice(0, 80), w: Math.round(el.getBoundingClientRect().width) }));
     return { hasOverflow: document.documentElement.scrollWidth > w, offenders };
   })()
   ```
   Report each offender with its class chain (Divi modules are identifiable by `et_pb_*`).
2. **Visual review of the screenshot.** Look for: overlapping or clipped text, headings wrapping mid-word, columns that failed to stack, hero text escaping its section, images stretched/cropped oddly, buttons colliding, footer columns crushed.
3. **Navigation usability.** At phone sizes: is there a working hamburger/mobile menu? Does the desktop menu overflow instead of collapsing?
4. **Touch targets** (phone sizes only; skip if `accessibility_level: off`). Evaluate interactive elements (`a`, `button`, `input`, `.et_pb_button`) with rendered size < 24×24px → violation (WCAG 2.2 SC 2.5.8 AA); < 44×44px → recommendation (WCAG 2.1 SC 2.5.5 AAA).
5. **Text legibility.** Body text < 16px at phone sizes is an iOS auto-zoom trigger on inputs and a readability flag.
6. **Fixed/sticky elements.** At 844×390 (landscape), check that fixed headers/banners don't consume most of the short viewport or cover content.
7. **Breakpoint boundary spot-check.** Take one screenshot 1px above and 1px below each active Divi breakpoint (e.g., 767/768, 980/981) — layout jumps are expected, broken layouts are not.

## Step 4B: Static Mode Checks

Scan the CSS (`**/*.css`, plus `<style>` blocks if the user points at HTML/PHP) for responsive risk patterns. Report with file:line.

| # | Pattern | Risk | Fix |
|---|---------|------|-----|
| S1 | Media query values that match neither Divi's default widths nor the project's customized widths | CSS and builder previews disagree | Align to the project's actual breakpoint widths |
| S2 | Fixed `width` > 360px without a `max-width: 100%` guard | Horizontal overflow on phones | Add `max-width: 100%` or use fluid units |
| S3 | `min-width` > 767px on containers | Forces phone overflow | Remove or scope to desktop media query |
| S4 | `width: 100vw` | Includes scrollbar width → permanent horizontal scroll on desktop | Use `100%` |
| S5 | `height: 100vh` on heroes/sections | Mobile URL-bar jump and clipped content | Use `100svh`/`100dvh` with `100vh` fallback |
| S6 | `font-size` in `vw` units only (no `clamp()`/`calc()` with a rem part) | Doesn't respond to user zoom (WCAG 1.4.4); microscopic on phones | `clamp(min, vw + rem, max)` |
| S7 | `img` styled without `max-width: 100%; height: auto` | Image overflow on small screens | Add the guard (Divi usually provides it — flag only where overridden) |
| S8 | `position: absolute` with fixed px offsets inside hero/header sections | Elements escape containers as the section shrinks | Use relative/percentage positioning or per-breakpoint values |
| S9 | Negative margins wider than ~300px | Phone overflow | Scope to desktop or reduce |
| S10 | Tables / `pre` / code blocks with no `overflow-x: auto` wrapper | Unscrollable overflow on phones | Add wrapper with `overflow-x: auto` |
| S11 | `.et_pb_row` / `.et_pb_section` width or padding overrides without responsive handling | Fights Divi's own stacking behavior | Prefer builder sizing options; if CSS, add phone/tablet media queries |
| S12 | Interactive elements with padding implying < 44px targets at phone sizes (skip if `accessibility_level: off`) | Touch usability | `min-height: 44px` or padding ≥ `0.75em 1em` |
| S13 | No media queries at all AND no fluid values (`clamp`/`min`/`max`/`vw`) | Desktop-only CSS | Start from `${CLAUDE_PLUGIN_ROOT}/skills/divi5-css-patterns/examples/responsive-7-breakpoints.css` |

Also check **coverage**: for each breakpoint in `active_breakpoints`, does the CSS (or the builder, per the user) actually adjust anything? A project with tablet enabled but zero tablet-zone rules usually means untested tablet rendering.

## Step 5: Generate Report

```
========================================
DIVI 5 RESPONSIVE DEVICE CHECK
Mode: [Live via <server> | Static CSS analysis]
Target: [URL or files]
Breakpoints: [project's active set + widths]
========================================

DEVICE MATRIX RESULTS:
  360×800   Small Android     [PASS | n issues]
  390×844   iPhone 14/15      [PASS | n issues]
  430×932   iPhone Pro Max    [PASS | n issues]
  844×390   Phone landscape   [PASS | n issues]
  810×1080  iPad portrait     [PASS | n issues]
  1024×768  iPad landscape    [PASS | n issues]
  1366×768  Laptop            [PASS | n issues]
  1920×1080 Widescreen        [PASS | n issues]
  2560×1440 Ultrawide         [PASS | n issues]

P0 — BROKEN (unusable at one or more sizes):
1. [viewport(s)] [element/file:line] [what happens]
   Fix: [concrete CSS or builder setting, with paste location]

P1 — DEGRADED (works but looks wrong or hurts usability):
1. ...

P2 — RISK (static-analysis pattern likely to break):
1. ...

VERIFY:
[how to re-check after fixes — re-run this command, or hard-refresh + DevTools device toolbar]
========================================
```

In live mode, reference the screenshots you took when describing each issue. In static mode, label findings as *risks* (patterns), not confirmed breakage — and say which ones live testing would confirm.

## Step 6: Offer Next Actions

- **Fix CSS** → generate the fixes directly (use `css_prefix`), or `/divi5-toolkit:convert` for a whole file
- **Validate the fixes** → `/divi5-toolkit:validate`
- **Whole-project health** → `/divi5-toolkit:audit` (Category C covers responsive scoring)
- **Performance at mobile sizes** → the `divi5-performance` agent (slow mobile rendering is a different failure mode than broken layout)
- **No browser server yet?** → offer the Playwright/Chrome DevTools MCP setup from the README's Optional MCP Servers section

## Important Notes

- A page can be responsive and still wrong: builder-level settings (column stacking order, hidden-on-mobile elements, per-breakpoint padding) are not visible in CSS files. In static mode, say explicitly that builder settings weren't checked.
- Don't equate "no media queries" with "broken" — well-built fluid CSS (`clamp()`, grid `auto-fit`) needs few breakpoints. Judge by behavior/risk, not query count.
- When a fix exists as a builder-native option (responsive settings per breakpoint, 5.5 Aspect Ratio for image sizing), present it before custom CSS, consistent with the rest of this plugin.
- Divi renders its 7 breakpoints with the widths configured in **Sitewide Responsive Breakpoints** — always resolve the *actual* widths before judging media-query alignment.
