// SvelteKit needs a +layout.ts when prerendering is desired for fully static output.
// This file opts the entire app into prerender so the build is fully static.
export const prerender = true;
export const ssr = true;
export const trailingSlash = 'never';
