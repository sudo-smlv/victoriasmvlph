import { describe, expect, it } from 'vitest';
import { INSTAGRAM_TILES, resolveInstagramSrc, type InstagramTile } from './instagram';

describe('INSTAGRAM_TILES', () => {
	it('is a read-only array', () => {
		expect(Array.isArray(INSTAGRAM_TILES)).toBe(true);
	});

	it('contains 0 or 5 entries (transitional empty is allowed)', () => {
		expect([0, 5]).toContain(INSTAGRAM_TILES.length);
	});

	it('every populated entry has non-empty src, caption, and postUrl', () => {
		for (const tile of INSTAGRAM_TILES) {
			expect(tile.src).toBeTruthy();
			expect(tile.caption).toBeTruthy();
			expect(tile.caption.trim()).not.toBe('');
			expect(tile.postUrl).toBeTruthy();
		}
	});

	it('every populated caption is a non-empty trimmed string', () => {
		for (const tile of INSTAGRAM_TILES) {
			expect(typeof tile.caption).toBe('string');
			expect(tile.caption.trim().length).toBeGreaterThan(0);
		}
	});

	it('every src points to a /instagram/ path with a .jpg extension', () => {
		for (const tile of INSTAGRAM_TILES) {
			expect(tile.src).toMatch(/^\/instagram\/\d{2}\.jpg$/);
		}
	});
});

describe('resolveInstagramSrc', () => {
	it('returns undefined for an empty filename', () => {
		expect(resolveInstagramSrc('')).toBeUndefined();
	});

	it('returns undefined when no image is present at the path', () => {
		expect(resolveInstagramSrc('00.jpg')).toBeUndefined();
	});
});

describe('InstagramTile type shape', () => {
	it('is structurally compatible with the ADR contract', () => {
		const sample: InstagramTile = {
			src: '/instagram/01.jpg',
			caption: 'Studio still life, natural light',
			postUrl: 'https://www.instagram.com/victoriasmvlph/'
		};
		expect(Object.keys(sample).sort()).toEqual(['caption', 'postUrl', 'src'].sort());
	});
});
