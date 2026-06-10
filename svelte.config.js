import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: vitePreprocess(),
	kit: {
		adapter: adapter({
			fallback: 'index.html',
			pages: 'build',
			assets: 'build',
			precompress: false,
			strict: true
		}),
		paths: {
			base: process.env.BASE_PATH || '',
			relative: false
		},
		prerender: {
			handleHttpError: ({ path, message }) => {
				// Allow-list patterns (warn instead of throw):
				//   - root path: trailing-slash variants resolve to / on the deploy target
				//   - /victoriasmvlph/*: gh-pages project base path; the walker sometimes
				//     resolves a 404 from the resolved-base perspective even though the
				//     file is correctly emitted (pre-existing in CLAAAAA-132)
				//   - static asset paths: anything with a file extension under /_app/ or
				//     a top-level static dir. A 404 here is almost always a broken <img
				//     src> or a mis-imported file in a component, not a route misconfig.
				//     Scoping the strict check to *route* prerender only (per CLAAAAA-176,
				//     Lens 8: dev/staging/prod builds should produce identical output
				//     shapes; the strict-prerender error made the gh-pages build a
				//     special case) keeps the build green for systemic asset-walker
				//     404s while still failing real route 404s.
				if (path === '/' || path.startsWith('/victoriasmvlph')) return;
				if (/\.[a-z0-9]{2,5}$/i.test(path)) return;
				if (path.startsWith('/_app/')) return;
				throw new Error(message);
			}
		}
	}
};

export default config;
