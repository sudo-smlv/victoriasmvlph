import { describe, expect, it } from 'vitest';
import { INSTAGRAM_PROFILE_URL, INSTAGRAM_TILES } from './instagram';

describe('INSTAGRAM_TILES', () => {
	it('contains exactly 5 tiles (per locked ADR on CLAAAAA-143)', () => {
		expect(INSTAGRAM_TILES).toHaveLength(5);
	});

	it('every tile has a non-empty caption (PM rule 6: alt text is required)', () => {
		for (const tile of INSTAGRAM_TILES) {
			expect(tile.caption.trim().length).toBeGreaterThan(0);
		}
	});

	it('every tile has a non-empty src pointing at /instagram/0N.jpg', () => {
		for (const [i, tile] of INSTAGRAM_TILES.entries()) {
			expect(tile.src).toBe(`/instagram/0${i + 1}.jpg`);
		}
	});

	it('every tile has a postUrl matching INSTAGRAM_PROFILE_URL or an instagram.com/p/ post URL', () => {
		for (const tile of INSTAGRAM_TILES) {
			expect(tile.postUrl).toMatch(
				/^https:\/\/(www\.)?instagram\.com\/(victoriasmvlph|p\/[A-Za-z0-9_-]+)\/?$/
			);
		}
	});

	it('exports INSTAGRAM_PROFILE_URL as the canonical profile URL', () => {
		expect(INSTAGRAM_PROFILE_URL).toBe('https://instagram.com/victoriasmvlph');
	});
});
