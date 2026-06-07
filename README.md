# Viktoria — Photographer Landing Page

Single-page, modern, responsive landing page for photographer Viktoria. Built with
SvelteKit + Tailwind CSS + `shadcn-svelte` components and `svelte-i18n` for
RU / EN / DE localization. Static-only build (no backend, no server runtime).

This repository currently ships the **scaffold** (CLA-2). Page content
(about, services, photo books, contact) is delivered by follow-up tasks.

## Tech stack

| Concern             | Choice                                       | Why |
|---------------------|----------------------------------------------|-----|
| Framework           | SvelteKit 2 + Svelte 5 (runes) + Vite        | Locked by CLA-1 / CLA-2 |
| Styling             | Tailwind CSS v4 via `@tailwindcss/vite`      | Required by `shadcn-svelte` |
| Component library   | `shadcn-svelte` (Svelte port of shadcn/ui)   | Locked by CLA-1 / CLA-2 |
| i18n                | `svelte-i18n` 4                              | Mature Svelte-native i18n with simple runtime + `localStorage` detection |
| Adapter             | `@sveltejs/adapter-static`                   | Fully static output, no server runtime |
| Package manager     | `npm` (lockfile committed)                   | Locked by CLA-2 |

## i18n choice — `svelte-i18n`

`svelte-i18n` is the chosen library. Rationale:

- Mature, Svelte-native, supports SSR and client-side hydration (we prerender
  pages with SvelteKit so the first paint already shows the default locale,
  and the client then upgrades to the persisted one).
- Tiny runtime, plain JSON catalogs in `src/lib/i18n/locales/`.
- Locale detection chain lives in `src/lib/i18n/index.ts`:
  1. `localStorage` key `viktoria.locale`
  2. `navigator.language`
  3. fallback `en`
- Supported locales: `en`, `ru`, `de` — set in `LOCALES`.
- Switching locale at runtime: call `locales.set('ru')` (see
  `src/lib/components/LanguageSwitcher.svelte`).
- Persistence: `persistLocale(...)` writes the choice to `localStorage`.

### Adding a new locale

1. Add the code to `LOCALES` in `src/lib/i18n/index.ts`.
2. Add a label to the `localeLabel` and `localeFullName` maps in
   `src/lib/components/LanguageSwitcher.svelte`.
3. Add `src/lib/i18n/locales/<code>.json` with the same shape as `en.json`,
   then `addMessages('<code>', <code>)` in `setupI18n()`.

### Adding a new message key

1. Add the key to every locale file under `src/lib/i18n/locales/`.
2. Use it in markup with `{$_('common.foo')}` or in code with `$_('common.foo')`.

## shadcn-svelte theme

- Base color: `slate` (set in `components.json`).
- Theming via CSS variables defined in `src/app.css` (`--background`,
  `--foreground`, `--primary`, etc.). The shadcn color tokens are
  exposed to Tailwind via `@theme inline { ... }` so utilities like
  `bg-background` and `text-muted-foreground` resolve correctly.
- Light theme is the default. The `.dark` class is wired through the
  CSS variables so a future `mode-watcher` toggle can opt in without
  touching component code.

### Adding a new shadcn-svelte component

This project ships a curated set of primitives (button, card, separator,
dropdown-menu, badge) copied into `src/lib/components/ui/`. To add more
from the official registry, run the shadcn-svelte CLI inside the project
folder:

```bash
npx shadcn-svelte@latest add <component-name>
```

Examples:

```bash
npx shadcn-svelte@latest add dialog
npx shadcn-svelte@latest add navigation-menu
npx shadcn-svelte@latest add sheet
```

After `add`, the component source lands in `src/lib/components/ui/<name>/`
and you can import it from there. The `components.json` already wires up
the `$lib/components`, `$lib/components/ui`, and `$lib/utils` aliases.

## Local development

```bash
npm install
npm run dev      # http://127.0.0.1:5173
```

## Production build

```bash
npm run build    # outputs static site to ./build
npm run preview  # serve ./build locally
```

The build is fully static — open `./build/index.html` or serve the
`build/` directory with any static host (GitHub Pages, Netlify, S3 + CDN,
etc.). The static adapter ships an `index.html` fallback so client-side
routing works on hosts that don't rewrite unknown paths.

## Project layout

```
src/
  app.css                       # Tailwind v4 entry + shadcn theme tokens
  app.html                      # SvelteKit document shell
  lib/
    components/
      LanguageSwitcher.svelte   # shadcn DropdownMenu + svelte-i18n
      ui/                       # shadcn-svelte primitives (button, card, ...)
    i18n/
      index.ts                  # init + locale detection + persistence
      locales/
        en.json
        ru.json
        de.json
    utils.ts                    # cn() helper (clsx + tailwind-merge)
  routes/
    +layout.svelte              # header, language switcher, footer
    +layout.ts                  # prerender = true (static build)
    +page.svelte                # scaffold placeholder
```

## Acceptance checklist (CLA-2)

- [x] `npm install` succeeds.
- [x] `npm run dev` boots the SvelteKit dev server and shows the placeholder page.
- [x] `npm run build` produces a static `build/` directory.
- [x] `Button`, `Card`, `Separator`, `DropdownMenu`, `Badge` shadcn primitives
      render on the placeholder.
- [x] `LanguageSwitcher` rewrites the placeholder string and persists the
      choice via `localStorage`.
- [x] README documents the i18n library choice and how to add shadcn components.
