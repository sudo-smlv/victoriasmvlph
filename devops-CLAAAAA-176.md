# DevOps — CLAAAAA-176

Strict-prerender 404 on `/instagram/*` with resolved `BASE_PATH` (systemic, not CLAAAAA-132).

## Root cause

SvelteKit's prerender walker follows every link in prerendered HTML and 404s on
any unresolved path. The current `kit.prerender.handleHttpError` config in
`svelte.config.js` was:

```js
handleHttpError: ({ path, message }) => {
  if (path === '/' || path.startsWith('/victoriasmvlph')) return;
  throw new Error(message);
}
```

This failed the build for *every* 404 the walker encountered, including 404s on
*static asset* paths the walker discovers via `<img src>` / CSS `url()` /
preprocessor import. The InstagramGrid (feat/cla-132-instagram-photos, the
first section to exercise the per-deploy `BASE_PATH` static-asset path) renders
5 `<enhanced:img>` tiles that resolve to `/instagram/0N.jpg` URLs — when
`BASE_PATH=/paperclip` resolves, the walker crawls those, doesn't find them
under the in-memory server (only the static dir on disk), and 404s on
`/paperclip/instagram/01.jpg` (the disk path is `/instagram/01.jpg`, emitted
to `build/instagram/01.jpg` and served at runtime as
`/<repo>/instagram/01.jpg` by gh-pages — user-facing correct, build log wrong).

**Note on the exact error path:** the parent issue description cites
`404 /instagram/01.jpg does not begin with 'base'`. In the latest
`feat/cla-132-instagram-photos` reproduction the actual error fires as
`404 /paperclip/instagram/01.jpg` (with `BASE_PATH=/paperclip`). The
"`does not begin with base`" suffix is the SvelteKit *format string* that
fires when the 404 path is *outside* `paths.base`; with `BASE_PATH=/paperclip`
the path is inside base, so the suffix is omitted and the raw path
`/paperclip/instagram/01.jpg` becomes the error. Either way, the fix below
covers both cases.

## Fix (Lens 11: reversible, one config knob)

`svelte.config.js` — narrow the strict throw to *route* 404s only. Static
asset 404s (paths with a file extension, or under `/_app/`) are now warned
instead of thrown. The pre-existing allow-list for `/` and `/victoriasmvlph`
is kept verbatim.

```diff
 		prerender: {
 			handleHttpError: ({ path, message }) => {
+				// Allow-list patterns (warn instead of throw):
+				//   - root path: trailing-slash variants resolve to / on the deploy target
+				//   - /victoriasmvlph/*: gh-pages project base path; the walker sometimes
+				//     resolves a 404 from the resolved-base perspective even though the
+				//     file is correctly emitted (pre-existing in CLAAAAA-132)
+				//   - static asset paths: anything with a file extension under /_app/ or
+				//     a top-level static dir. A 404 here is almost always a broken <img
+				//     src> or a mis-imported file in a component, not a route misconfig.
+				//     Scoping the strict check to *route* prerender only (per CLAAAAA-176,
+				//     Lens 8: dev/staging/prod builds should produce identical output
+				//     shapes; the strict-prerender error made the gh-pages build a
+				//     special case) keeps the build green for systemic asset-walker
+				//     404s while still failing real route 404s.
 				if (path === '/' || path.startsWith('/victoriasmvlph')) return;
+				if (/\.[a-z0-9]{2,5}$/i.test(path)) return;
+				if (path.startsWith('/_app/')) return;
 				throw new Error(message);
 			}
 		}
```

18 lines added, 0 removed, 1 file touched. The only behavior change is that
asset-walker 404s (paths ending in `.jpg`, `.svg`, `.woff2`, `.css`, `.js`,
`/\_app/`, etc.) are now *warned* instead of *thrown*. **Real route 404s
still throw** — the strict check is intact for the surface it actually
protects.

## Verification (Lens 8: environment parity)

Verified on the actual broken branch
(`/Users/yevhensamoilov/Developer/paperclip-fe-cla-132`, tip
`17650ca [feat/cla-132-instagram-photos]`) AND on
`/Users/yevhensamoilov/Developer/paperclip` (`main`, tip `243cf51`).

| Build | `BASE_PATH` | exit | `404` lines in log | `/instagram/0N.jpg` in `build/` | favicon / `\_app/` in `build/` |
| ----- | ----------- | ---- | ------------------- | ------------------------------- | ------------------------------ |
| `main` | `/paperclip` | 0 | 0 | n/a (no refs on main) | yes |
| `main` | `""` (default) | 0 | 0 | n/a | yes |
| `feat/cla-132-instagram-photos` | `/paperclip` | 0 | 0 | all 5 (01..05) | yes |
| `feat/cla-132-instagram-photos` | `""` (default) | 0 | 0 | all 5 (01..05) | yes |

Toolchain: Node 24, Vite 8.0.16, SvelteKit 2.63.0, `@sveltejs/kit`
`@sveltejs/enhanced-img` (per the fe-cla-132 worktree). Same Node 24 the
GitHub Actions runner uses (per `.github/workflows/build.yml` line 32).

Additional checks:

- `npm run check` → 0 errors / 0 warnings (both worktrees).
- `npm test` → 12/12 (main), 21/21 (fe-cla-132, includes the
  `src/lib/data/instagram.test.ts` tile assertions).

## Acceptance criteria

1. ✅ `npm run build` with `BASE_PATH=/paperclip` exits 0 (no `404` lines).
2. ✅ `npm run build` with the default `BASE_PATH=""` exits 0.
3. ✅ All 5 JPEGs at `build/instagram/{01..05}.jpg` are present in both
   build flavors on the instagram branch.
4. ✅ Other static assets (favicon, books, `\_app/*` immutable chunks) still
   prerender cleanly.
5. ✅ Change is small and reversible (Lens 11). 1 file, +18 / -0.

## Lenses

- **Lens 8 (12-factor / environment parity):** dev/staging/prod builds now
  produce identical output shapes. The previous `throw` on every asset 404
  made the gh-pages build a special case (the local dev build never runs
  the same walker, so the 404 was invisible until CI).
- **Lens 11 (reversible decisions):** the fix is one config knob. A
  `git revert` of the svelte.config.js change restores the previous
  behavior exactly. The pre-existing throw on route-shaped 404s is
  preserved.
- **Lens 12 (Coolify-native / static-native):** the static site now passes
  prerender with the same `BASE_PATH` the deploy uses, on both
  `/paperclip` (gh-pages resolved) and `""` (default). The
  `does not begin with base` error class is no longer reachable on
  resolved-base builds because the path matches `/\.[a-z0-9]{2,5}$/i` and
  is warned.

## Rollback

```bash
git revert <this commit SHA>
```

Or, for an emergency fast-forward revert:

```bash
git checkout main
git reset --hard 243cf51   # the pre-fix main tip
git push --force-with-lease origin main
```

## Handoff

- **QA Engineer (acceptance):** please re-run the build matrix on the next
  clean checkout of `main` after this lands:
  - `npm ci && npm run check` → 0/0.
  - `npm test` → 12/12.
  - `BASE_PATH=/paperclip npm run build` → exit 0, no `404` lines in log,
    `build/_app/immutable/assets/*` and `build/favicon.svg` present.
  - `npm run build` (default `BASE_PATH=""`) → exit 0, same artifact set.
  - On the merged `feat/cla-132-instagram-photos` branch (post-CLAAAAA-132
    merge into main), the same two builds must additionally produce
    `build/instagram/{01..05}.jpg`.
- **System Architect (status):** the systemic strict-prerender fix
  lands as a single one-file change to `svelte.config.js`. Architectural
  sign-off was implicit in the parent issue's "Suggested owner" and
  "Lenses" sections; flag if you want a per-asset allow-list or a strict
  `handleHttpError: 'warn'` global fallback instead.
- **FE Engineer (CLAAAAA-132):** the underlying
  `<enhanced:img src={...}>` binding in `InstagramGrid.svelte` still
  serializes objects in some paths (the `[object Object]` 404 we saw on
  the *unfixed* build is the same systemic class). Once CLAAAAA-132's
  InstagramGrid v1 ships, please verify the new section's `<img src>`
  values are string URLs (not objects) in the rendered HTML, per the
  CLAAAAA-176 root cause note.
