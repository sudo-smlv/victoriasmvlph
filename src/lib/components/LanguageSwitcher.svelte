<script lang="ts">
	import { _, locale } from 'svelte-i18n';
	import { ChevronsUpDown, Check } from '@lucide/svelte';
	import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
	import { Button } from '$lib/components/ui/button';
	import { LOCALES, persistLocale, type Locale } from '$lib/i18n';

	const localeLabel: Record<Locale, string> = {
		en: 'EN',
		ru: 'RU',
		de: 'DE'
	};

	const localeFullName: Record<Locale, string> = {
		en: 'English',
		ru: 'Русский',
		de: 'Deutsch'
	};

	let current = $derived<Locale>(
		typeof $locale === 'string' && (LOCALES as readonly string[]).includes($locale)
			? ($locale as Locale)
			: 'en'
	);

	function selectLocale(next: Locale) {
		if (next === current) return;
		locale.set(next);
		persistLocale(next);
	}
</script>

<DropdownMenu.Root>
	<DropdownMenu.Trigger>
		{#snippet child({ props })}
			<Button {...props} variant="outline" size="sm" class="gap-2" aria-label={$_('a11y.select_language')}>
				<span class="font-semibold">{localeLabel[current]}</span>
				<ChevronsUpDown class="text-muted-foreground size-4" />
			</Button>
		{/snippet}
	</DropdownMenu.Trigger>
	<DropdownMenu.Content align="end" class="min-w-40">
		<DropdownMenu.Group>
			{#each LOCALES as code (code)}
				<DropdownMenu.Item onclick={() => selectLocale(code)}>
					<span class="flex-1">{localeFullName[code]}</span>
					<span class="text-muted-foreground text-xs">{localeLabel[code]}</span>
					{#if code === current}
						<Check class="text-foreground size-4" />
					{/if}
				</DropdownMenu.Item>
			{/each}
		</DropdownMenu.Group>
	</DropdownMenu.Content>
</DropdownMenu.Root>
