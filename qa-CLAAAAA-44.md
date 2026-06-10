# CLAAAAA-44 — QA verification: header polish (transitions + responsive drawer)

Review target: `feat/cla-5-integration` @ `b91fd64` (per the issue's "reference implementation" instruction)
  - `2ba357a` responsive SiteHeader + MobileMenu + Button base
  - `b91fd64` a11y follow-up: `Dialog.Title` / `Dialog.Description` (sr-only)
  - `b1dbe30` terracotta + champagne token swap (sibling issue CLAAAAA-46, cross-verified per issue body)

Files in CLAAAAA-44 scope: 3 (+101 / −2)
  - `src/lib/components/MobileMenu.svelte` (new)
  - `src/lib/components/sections/SiteHeader.svelte`
  - `src/lib/components/ui/button/button.svelte`

## Automated checks (both green on `feat/cla-5-integration`)

| Check | Command | Result |
|---|---|---|
| Type/svelte-check | `npm run check` | 0 errors, 0 warnings |
| Production build | `npm run build` | clean (`built in 3.76s`, static adapter wrote to `build/`) |

## Verification against the issue's pass/fail criteria

### ✅ Build commands clean
Both `npm run check` and `npm run build` succeed with no warnings.

### ⚠️ Hover transitions on CTA-style buttons
- The shared `Button` base now carries `transition-colors duration-300 ease-out` (`button.svelte:7`). Every consumer of `Button` (header CTA, hero primary/secondary, contact block, mobile drawer CTA) inherits it. **PASS** for `Button`-based CTAs.
- The header CTA row also carries its own `bg-brand-ink … hover:bg-brand-charcoal` class but no override of the duration — it inherits the base. **PASS.**
- **FAIL** — `SiteHeader.svelte:34`, the desktop nav text links (`<a href="#about">` etc.), still have `transition-colors` *without* `duration-300 ease-out`. These are the same row the responsive drawer mirrors in `MobileMenu.svelte:73` (where the new tokens *are* applied), so the mobile and desktop variants of the same nav are inconsistent. This is squarely in CLAAAAA-44's stated scope ("responsive SiteHeader … consistent button transitions").

### ✅ Responsive header
- `lg:hidden` on the drawer trigger, `hidden lg:flex` on the desktop CTA row → mutually exclusive at every viewport.
- Drawer uses `w-full max-w-xs sm:max-w-sm` (≤ 24 rem) → no horizontal scroll, matches the issue's "at most min(22rem, 85vw)" intent within tolerance.
- Drawer closes on all four paths: backdrop click (bits-ui `DismissibleLayer`), Escape (`EscapeLayer`), close button (`Dialog.Close`), and successful nav/book click (`closeAndNavigate` / `handleBookClick` set `open = false` then navigate).
- i18n keys exist in `en`/`ru`/`de` for `common.appName`, `common.language`, `common.nav.{about,services,books,contact}`, `hero.cta_primary`.
- All four nav anchors resolve to existing section IDs.

### ✅ Drawer a11y
- `Dialog.Title` (`common.appName`) and `Dialog.Description` (concatenated nav keys) are present in `sr-only` form (`MobileMenu.svelte:54-57`). This makes `aria-labelledby` / `aria-describedby` resolve via bits-ui's auto-wired `titleId` / `descriptionId` and gives the dialog a proper accessible name.
- `aria-label="Open menu"` on the trigger, `aria-label="Close menu"` on the close button — both icon-only.
- `aria-label="Mobile primary"` on the drawer nav distinguishes it from the desktop nav's `aria-label="Primary"`.
- bits-ui handles `role="dialog"`, `aria-modal="true"`, focus trap, focus return, body scroll lock. **PASS.**

### ✅ i18n
All keys referenced render in all three locales (verified by grep against `en.json`, `ru.json`, `de.json`).

### ✅ Cross-branch token swap (CLAAAAA-46)
`b1dbe30` lands before `b91fd64` on the integration branch. The header's `text-brand-ink` / `text-brand-orange` / `bg-brand-cream` references all resolve to the new pastel tokens — no dangling old-orange/yellow classes.

### ⚠️ Out-of-scope hygiene (advisory, do not block)
The following user-facing elements still use `transition-colors` without the new tokens. They are outside CLAAAAA-44's explicit scope but trip the issue's "consistent across every CTA on the page" pass criterion.
- `src/lib/components/sections/SiteFooter.svelte:52, 67` — footer text links
- `src/lib/components/sections/ServicesCards.svelte:102, 141` — service card hover, "Read more" link

Recommend a follow-up issue (CLAAAAA-46 cascade candidate) to bring these in line.

### ⚠️ `prefers-reduced-motion`
The drawer's `slide-in-from-right` / `slide-out-to-right` and `fade-in-0` / `fade-out-0` play for all users. The repo already uses `@media (prefers-reduced-motion: reduce)` in `src/app.css:173` for the marquee but not for bits-ui's drawers. **Minor**, not blocking, but a 1-line follow-up (`motion-reduce:animate-none` on the overlay/content) would be a meaningful accessibility improvement.

## Verdict

**Request changes** — one in-scope blocker (header nav links inconsistent with the new transition tokens) and one non-blocking a11y nit. The MobileMenu a11y follow-up `b91fd64` correctly addresses the blocker I would otherwise have flagged on the original `2ba357a` commit.

### Required (in-scope)

1. Add `duration-300 ease-out` to the desktop nav links in `SiteHeader.svelte:34` so they match the `Button` base and the `MobileMenu` drawer's own nav links. This is the only piece of CLAAAAA-44's stated goal that is currently unmet.

### Recommended (non-blocking, file as follow-ups)

2. Add `motion-reduce:animate-none` (or equivalent) on `MobileMenu.svelte:47` and `:50` to respect `prefers-reduced-motion`.
3. Cascade the new transition tokens to `SiteFooter.svelte:52, 67` and `ServicesCards.svelte:102, 141` (CLAAAAA-46 follow-up) so every CTA on the page hovers with the same timing.

## Reproduce

```bash
cd /Users/yevhensamoilov/.paperclip/instances/default/projects/ee3b5aa2-5df9-4028-bc5c-328b694fcb4e/5ae974bc-cd7a-48f2-920c-6eb81cf75035/_default
git checkout feat/cla-5-integration
git pull --ff-only origin feat/cla-5-integration
npm install
npm run check   # 0 errors, 0 warnings
npm run build   # clean
```
