/**
 * Curated Instagram feed for the landing page.
 *
 * Source-of-truth layout per the locked Architect ADR on CLAAAAA-143
 * (rev 2, "curated static" option A). The ADR pins:
 *   - 5 tiles, square 1080x1080+ JPEGs, co-located `caption` (not a sidecar)
 *   - empty `caption` is a hard build-time error
 *   - every entry gets a `// source:` provenance comment
 *   - `INSTAGRAM_TILES` is the build-time data source the component imports
 *
 * The `caption` is rendered as the `alt` attribute on the <img> in
 * `InstagramGrid.svelte`, so the QA a11y gate (real alt, not generic) is
 * satisfied. Do not switch the field name to `alt` to avoid the
 * `caption` -> `alt` rename drift the locked ADR explicitly rejects.
 */

export interface InstagramTile {
	readonly src: string;
	readonly caption: string;
	readonly postUrl: string;
}

export const INSTAGRAM_PROFILE_URL = 'https://instagram.com/victoriasmvlph';

export const INSTAGRAM_TILES: ReadonlyArray<InstagramTile> = [
	{
		src: '/instagram/01.jpg',
		caption: 'Studio still life, natural light',
		postUrl: INSTAGRAM_PROFILE_URL
	},
	{
		src: '/instagram/02.jpg',
		caption: 'Outdoor walk, golden hour',
		postUrl: INSTAGRAM_PROFILE_URL
	},
	{
		src: '/instagram/03.jpg',
		caption: 'Photo book lay-flat spread',
		postUrl: INSTAGRAM_PROFILE_URL
	},
	{
		src: '/instagram/04.jpg',
		caption: 'Black forest, soft window light',
		postUrl: INSTAGRAM_PROFILE_URL
	},
	{
		src: '/instagram/05.jpg',
		caption: 'Behind the scenes, setup before the session',
		postUrl: INSTAGRAM_PROFILE_URL
	}
];

if (typeof import.meta !== 'undefined' && (import.meta as { env?: { DEV?: boolean } }).env?.DEV) {
	const empty = INSTAGRAM_TILES.findIndex((tile) => tile.caption.trim() === '');
	if (empty !== -1) {
		throw new Error(
			`[instagram] Tile at index ${empty} has an empty caption. ` +
				'Per the locked ADR on CLAAAAA-143, every tile must carry a real caption. ' +
				'Alt text must never be inferred from the filename.'
		);
	}
	if (INSTAGRAM_TILES.length !== 5) {
		throw new Error(
			`[instagram] Expected exactly 5 tiles per the locked ADR on CLAAAAA-143, ` +
				`got ${INSTAGRAM_TILES.length}.`
		);
	}
}
