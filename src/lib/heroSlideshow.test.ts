import { describe, expect, it } from 'vitest';
import { formatSlideLabel, nextIndex, previousIndex, SLIDE_DURATION_MS } from './heroSlideshow';

describe('nextIndex', () => {
	it('advances by one inside the slide range', () => {
		expect(nextIndex(0, 3)).toBe(1);
		expect(nextIndex(1, 3)).toBe(2);
	});

	it('wraps from the last slide back to the first', () => {
		expect(nextIndex(2, 3)).toBe(0);
	});

	it('returns 0 when called with current = 0 and total = 1', () => {
		expect(nextIndex(0, 1)).toBe(0);
	});

	it('is safe for the empty-slides edge case', () => {
		expect(nextIndex(0, 0)).toBe(0);
	});
});

describe('previousIndex', () => {
	it('steps back by one inside the slide range', () => {
		expect(previousIndex(2, 3)).toBe(1);
		expect(previousIndex(1, 3)).toBe(0);
	});

	it('wraps from the first slide to the last', () => {
		expect(previousIndex(0, 3)).toBe(2);
	});

	it('returns 0 when there is only one slide', () => {
		expect(previousIndex(0, 1)).toBe(0);
	});

	it('is safe for the empty-slides edge case', () => {
		expect(previousIndex(0, 0)).toBe(0);
	});
});

describe('formatSlideLabel', () => {
	it('substitutes 1-based current and total placeholders', () => {
		expect(formatSlideLabel('Slide {current} of {total}', 1, 3)).toBe('Slide 1 of 3');
	});

	it('handles non-English templates', () => {
		expect(formatSlideLabel('Слайд {current} из {total}', 2, 5)).toBe('Слайд 2 из 5');
	});

	it('leaves the template alone if no placeholders are present', () => {
		expect(formatSlideLabel('No placeholders here', 1, 3)).toBe('No placeholders here');
	});
});

describe('SLIDE_DURATION_MS', () => {
	it('is the expected 5 second autoplay cadence', () => {
		expect(SLIDE_DURATION_MS).toBe(5000);
	});
});
