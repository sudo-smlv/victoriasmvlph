/**
 * Pure helpers for the Hero slideshow.
 *
 * Kept in a `.ts` file (not inside the Svelte component) so the slide-advance
 * logic can be unit-tested without spinning up Svelte. The Hero.svelte
 * component imports and delegates to these helpers.
 */

export const SLIDE_DURATION_MS = 5000;

/**
 * Advance a circular slide index by one. Pure — no I/O, no `Date.now()`,
 * safe to call from inside `$effect` and from tests.
 *
 * @param current  the index of the current slide (0-based)
 * @param total    total number of slides; must be > 0
 * @returns the index of the next slide
 */
export function nextIndex(current: number, total: number): number {
	if (total <= 0) return 0;
	return (current + 1) % total;
}

/**
 * Step a circular slide index back by one. Pure.
 *
 * @param current  the index of the current slide (0-based)
 * @param total    total number of slides; must be > 0
 * @returns the index of the previous slide
 */
export function previousIndex(current: number, total: number): number {
	if (total <= 0) return 0;
	return (current - 1 + total) % total;
}

/**
 * Build a 1-based "Slide N of M" label from a template with `{current}` and
 * `{total}` placeholders. The Hero slideshow uses the localized template
 * `hero.slideshow_slide_label` so non-Latin locales can keep their own
 * sentence order.
 */
export function formatSlideLabel(template: string, current: number, total: number): string {
	return template.replace('{current}', String(current)).replace('{total}', String(total));
}
