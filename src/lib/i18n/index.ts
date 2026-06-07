import { addMessages, init, getLocaleFromNavigator } from 'svelte-i18n';
import { browser } from '$app/environment';
import en from './locales/en.json';
import ru from './locales/ru.json';
import de from './locales/de.json';

export const LOCALES = ['en', 'ru', 'de'] as const;
export type Locale = (typeof LOCALES)[number];
export const DEFAULT_LOCALE: Locale = 'en';
export const LOCALE_STORAGE_KEY = 'viktoria.locale';

const isLocale = (value: string | null | undefined): value is Locale =>
	typeof value === 'string' && (LOCALES as readonly string[]).includes(value);

const detectInitialLocale = (): Locale => {
	if (!browser) return DEFAULT_LOCALE;
	try {
		const stored = window.localStorage.getItem(LOCALE_STORAGE_KEY);
		if (isLocale(stored)) return stored;
	} catch {
		// localStorage may be unavailable (e.g. private mode); fall through
	}
	const nav = getLocaleFromNavigator();
	if (isLocale(nav ?? null)) return nav as Locale;
	const lowered = nav?.toLowerCase().split('-')[0];
	if (isLocale(lowered)) return lowered;
	return DEFAULT_LOCALE;
};

let initialized = false;

export function setupI18n() {
	if (initialized) return;
	initialized = true;
	addMessages('en', en);
	addMessages('ru', ru);
	addMessages('de', de);
	init({
		fallbackLocale: DEFAULT_LOCALE,
		initialLocale: detectInitialLocale()
	});
}

export function persistLocale(locale: Locale) {
	if (!browser) return;
	try {
		window.localStorage.setItem(LOCALE_STORAGE_KEY, locale);
	} catch {
		// ignore
	}
}
