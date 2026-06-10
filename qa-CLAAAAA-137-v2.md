# CLAAAAA-137 (v2) — QA live-URL smoke check after `feat/cla-5-integration` hotfix merge

- **Live URL:** https://sudo-smlv.github.io/victoriasmvlph/
- **Run at:** 2026-06-10T08:05–08:12Z
- **Build under test:** `origin/main` HEAD `88c6238` (CLAAAAA-176 follow-up) → `243cf51` (CLAAAAA-116 cherry-pick) → `aa80747` (CLAAAAA-115 cherry-pick) → `9e3d686` (PR #5).
- **Live deploy:** `last-modified: Wed, 10 Jun 2026 08:05:33 GMT` (~10 min before this run). Build is fresh, CDN settled.
- **HTTP:** 200 (Playwright `networkidle`).
- **Console errors:** 0. **4xx/5xx network errors:** 0.
- **Scripts:** `/tmp/qa-smoke-137/v2-*.mjs`. **Screenshots:** `v2-final-desktop.png`, `v2-final-en.png`, `v2-final-de.png`, `v2-final-mobile.png`, `v2-locale-en.png`, `v2-locale-de.png`.

**Verdict: REQUEST CHANGES (still).** The cherry-pick hotfix made real progress on the build (AC2 hero-tagline corner gone, AC3 eyebrows 02/03/04/05 with brand color and aria-hidden, AC4 slideshow rotates, AC5 i18n RU/EN/DE works, no console/network errors), but the user-visible duplication that the original CLAAAAA-120 ticket complained about is **still on the page** in all three locales, and the 24×24 touch-target contract is still violated on desktop and mobile.

## Pass / fail matrix against the 6 acceptance criteria

| # | Criterion | Result | Evidence |
| - | --------- | ------ | -------- |
| 1 | No duplicate section titles on services / books / about / contact | **FAIL** | Each section title appears in user-visible text **3–7 times** per locale. RU: `Обо мне` × 3, `Фотокниги` × 7 (incl. 2 body paragraphs), `Пакеты`/`Услуги` × 5. EN: `Services` × 5, `About` × 5, `Photo Books` × 5. DE: `Leistungen`/`Pakete` × ~5, `Über mich` × 3, `Fotobücher` × 7. The decorative eyebrow span is `aria-hidden="true"` (correct per PM amendment 3), but the `<h2>` with the bare title is still present right below it, AND every section title is also in the **footer** nav. The user complains specifically about that double — see the "Lines mentioning" lists in v2-final.mjs output. |
| 2 | No duplicate hero tagline | **PASS** (with caveat) | Only **one** user-visible occurrence of `Фотограф и создатель…` remains — in the Sparkles badge at the top of the hero. The orange corner span (CLAAAAA-115 B.2 target) is gone. The Sparkles tagline is also repeated in the brand-intro block (`ЭТО — VIKTORIA` / `Фотограф и создатель визуальных историй`) further down, but that's a different section, not the hero. The user's original complaint was the in-hero duplicate; that is resolved. |
| 3 | Eyebrow badges unified, brand color, numbered 02/03/04/05, `aria-hidden="true"` on the decorative one | **PASS** | All four eyebrows present in correct order with brand color. `oklch(0.16 0.01 280)` (brand-ink) for 02/03/04, `oklch(0.97 0.02 85)` (brand-cream) for 05/Contact. All four have `aria-hidden="true"`. Numbering `— 02 /`, `— 03 /`, `— 04 /`, `— 05 /` matches the spec. |
| 4 | Hero slideshow rotates | **PASS** | Counter element (`span.font-mono[aria-hidden="true"]`) advanced from `01 / 03` to `02 / 03` after a 6s wait. Three slide images in DOM (`.bg-brand-orange/55` panels), three indicator dots. Manual `aria-label="Предыдущий слайд"` / `Следующий слайд` / `Воспроизвести шоурил` controls present. |
| 5 | i18n RU/EN/DE parity | **PASS** | Switcher menu opens (`button[aria-label*="ыбрать язык"]` → dropdown with `English EN`, `Русский RU`, `Deutsch DE` menuitems). EN locale renders its own copy (`Services`, `Photo Books`, `Get in touch`, `Photographer & visual storyteller`, `Book a session`). DE locale renders its own (`Leistungen`, `Fotobücher`, `Kontakt`, `Fotografin & visuelle Geschichtenerzählerin`, `Termin buchen`). No fallback to RU strings observed. |
| 6 | 24×24 touch targets on book CTA, header nav, footer CTA (CLAAAAA-116) | **FAIL** | **Desktop:** 7 violations. **Mobile:** 9 violations. The `Book this package` (per-card) and `Book a session` (header) buttons are now `min-h-6` = 24 px on desktop (good, in main scope). **Violations are all in the footer** (Desktop: footer nav 4×, footer social 2×, plus `ОТКРЫТЬ INSTAGRAM →` in main = 7; Mobile: same plus 2 hero CTAs at 16 px height = 9). Footer nav links are 152×20, social links 152×20. Mobile hero CTAs (`НАПИСАТЬ В INSTAGRAM`, `НАПИСАТЬ В TELEGRAM`) are 310×16/18. None of these got the `min-h-6` / `px-3` treatment from `5442de0`. |

**Score: 4 PASS, 2 FAIL.**

## What's new vs the previous REQUEST CHANGES

Compared to my run at 07:42Z against `9e3d686` (score 2.5/6), the hotfix produced these concrete deltas:

- **AC2** (hero-tagline dedup) flipped FAIL → PASS. The orange corner span is gone. Only the Sparkles badge tagline remains visible.
- **AC3** (eyebrow badges) flipped PARTIAL → PASS. Numbering is now `02/03/04/05`, all four have `aria-hidden="true"`, all four use brand color.
- **AC4** (slideshow) remains PASS. Now confirmed with the live counter advance (`01 / 03` → `02 / 03`).
- **AC5** (i18n) remains PASS. Confirmed in-script by switching the menu and reading body text.
- **AC1** (section-title dedup) remains FAIL. The fix cherry-picked from CLAAAAA-115 added `aria-hidden="true"` to the decorative eyebrow (PM amendment 3), but it did NOT remove the `<h2>` with the bare title, AND the section titles are still repeated in the footer nav. The user-visible string is therefore visible twice per section (h2 + footer nav) in every locale.
- **AC6** (24×24 touch targets) remains FAIL. CLAAAAA-116 cherry-pick fixed the in-scope elements (per-card `Book this package`, header `Book a session`, primary nav) but did NOT extend to the footer nav, footer social, and mobile contact CTAs.

## Root cause for the two remaining failures

Both are scope / acceptance-criteria gaps in the CLAAAAA-115 and CLAAAAA-116 cherry-picks vs what CLAAAAA-120 / CLAAAAA-122 actually required:

- **AC1 fail:** The CLAAAAA-115 B.4 acceptance ("Remove the `<h2>` with the bare title; eyebrow is the only visible section title") was **not honored** in the cherry-pick. The PM amendment 3 (`aria-hidden` on the eyebrow) was applied, but the `h2` removal was not. Additionally, the original ticket CLAAAAA-120 also complained about section titles being in the footer nav, which has not been addressed at all.
- **AC6 fail:** The CLAAAAA-116 scope was "book_cta, header nav, footer CTA". The per-card `Book this package` and header `Book a session` got the fix. The **footer nav** (4 items) and **footer social links** (2 items) — both within the ticket's stated scope — did not. The mobile contact-section CTAs (`НАПИСАТЬ В INSTAGRAM`, `НАПИСАТЬ В TELEGRAM`) are also 16–18 px tall and untouched.

## Required before this can move to `done`

Both remaining ACs are missing-commit / scope-completeness issues, not architectural ones. Two paths to green:

1. **Fix-forward (preferred):** Cherry-pick (or hand-port) two small follow-ups onto `main`:
   - **AC1:** In each `src/lib/components/sections/{ServicesCards,About,Books,ContactCTA}.svelte`, remove the `<h2>` (the eyebrow is the only visible section title per B.4). Optionally also consider whether the footer nav should repeat the section titles at all (the user's escalation asked for "одинаковые элементы" = same elements, which can also be read as "stop repeating").
   - **AC6:** In `src/lib/components/SiteFooter.svelte`, change the footer nav and social links from `min-h-5` / `py-1` to `min-h-6` / `py-2` (or use `min-h-6 px-3` to match the header pattern). Optionally also fix the mobile `ContactButtons` (the two hero CTAs at 16 px height).
2. **Rollback:** Per the CEO's note, `git revert -m 1 <hotfix-merge-sha>` or use Pages one-click rollback to revert the entire hotfix and re-open CLAAAAA-175. This is an architect call, not mine.

After either path, I re-run this smoke check on the same URL. All six ACs must PASS for CLAAAAA-137 to close.

Routing this back to the **architect** (per agent instructions) — change request is on the cherry-pick completeness, not on the hotfix mechanism itself.
