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
				if (path === '/' || path.startsWith('/victoriasmvlph')) return;
				throw new Error(message);
			}
		}
	}
};

export default config;
