// Instagram grid tiles — curated static data per ADR-001 (CLAAAAA-143).
//
// Contract:
//   - Exactly 5 tiles when populated (PM rule 1). Empty is allowed only as a
//     transitional state during the curated-drop rollout — see "Transitional
//     empty state" below.
//   - Each populated tile carries a real `caption` for the alt attribute
//     (PM rule 6). Empty captions on a populated entry fail the build.
//   - Each populated entry gets a `// source:` provenance comment (ADR Lens 9).
//   - Image sources are loaded via Vite's `import.meta.glob` against
//     `static/instagram/*.{jpg,jpeg}` so `@sveltejs/enhanced-img` can process
//     them at build time into the responsive `<picture>` output.
//
// Transitional empty state (this commit):
//   The curated photo drop from @VICTORIASMVLPH has not landed yet. The
//   `RAW_TILES` array is empty, so this module exports an empty read-only
//   array. The `InstagramGrid.svelte` component detects the empty state and
//   falls back to the existing placeholder render per the ADR rollback
//   clause ("broken build is acceptable, broken live site is not"). This
//   keeps the production build green and visible while Viktoria's drop is
//   in flight; once photos land, the data file is updated in place and the
//   component picks them up on the next build with no other code change.
//
// Build-time guarantee (post-drop):
//   When the array is non-empty, this module throws at import time if any
//   entry is missing a `caption` (PM rule 6 — caption is required; the
//   exception to the runtime-fallback rule). That fails the build loudly
//   instead of shipping a section with no alt text.

export type InstagramTile = {
	readonly src: string;
	readonly caption: string;
	readonly postUrl: string;
};

const RAW_TILES: ReadonlyArray<InstagramTile> = [
	// Entries to be filled in by Viktoria's curated drop. Each entry MUST
	// include a non-empty `caption` and a `// source:` provenance comment
	// above it. Example shape (do not uncomment — illustrative only):
	//
	// {
	//   src: '/instagram/01.jpg',
	//   // source: https://www.instagram.com/p/SHORTCODE
	//   caption: 'Studio still life, natural light',
	//   postUrl: 'https://www.instagram.com/p/SHORTCODE/'
	// },
];

function assertValidInstagramTiles(
	tiles: ReadonlyArray<InstagramTile>
): ReadonlyArray<InstagramTile> {
	if (tiles.length === 0) {
		// Transitional empty state — the component handles this and falls
		// back to the placeholder render. See module header.
		return tiles;
	}
	if (tiles.length !== 5) {
		throw new Error(
			`INSTAGRAM_TILES must contain exactly 5 entries when populated (PM rule 1). Got ${tiles.length}.`
		);
	}
	tiles.forEach((tile, index) => {
		const label = `INSTAGRAM_TILES[${index}]`;
		if (!tile.src || typeof tile.src !== 'string') {
			throw new Error(`${label}.src must be a non-empty string.`);
		}
		if (!tile.caption || typeof tile.caption !== 'string' || tile.caption.trim() === '') {
			throw new Error(
				`${label}.caption is required and must be a non-empty string (PM rule 6).`
			);
		}
		if (!tile.postUrl || typeof tile.postUrl !== 'string') {
			throw new Error(`${label}.postUrl must be a non-empty string.`);
		}
	});
	return tiles;
}

export const INSTAGRAM_TILES: ReadonlyArray<InstagramTile> = assertValidInstagramTiles(RAW_TILES);

// Eagerly loaded image map keyed by filename (e.g. "01.jpg"). Vite's glob
// import means `@sveltejs/enhanced-img` will see these as static asset
// references at build time and emit the responsive `<picture>` output to
// `build/instagram/`. The map is `undefined` when no real images are
// present (transitional state) — the component handles that.
const IMAGE_MODULES = import.meta.glob<{ default: string }>(
	'/static/instagram/*.{jpg,jpeg,JPG,JPEG}',
	{ eager: true }
);

export function resolveInstagramSrc(filename: string): string | undefined {
	if (!filename) return undefined;
	const mod = IMAGE_MODULES[`/static/instagram/${filename}`];
	return mod?.default;
}
