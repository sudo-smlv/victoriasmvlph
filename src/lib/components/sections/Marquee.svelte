<script lang="ts">
	import { get } from 'svelte/store';
	import { json, locale } from 'svelte-i18n';

	const items = $derived.by<string[]>(() => {
		// Reading $locale explicitly makes the derived re-run on language change.
		void $locale;
		const lookup = get(json);
		const raw = lookup('marquee.items');
		return Array.isArray(raw) ? (raw as string[]) : [];
	});
</script>

<div
	class="bg-brand-yellow text-brand-ink border-hairline overflow-hidden border-y py-3"
	aria-hidden="true"
>
	<div class="marquee-track flex w-max gap-10 whitespace-nowrap">
		{#each [...items, ...items, ...items, ...items] as item, i (i)}
			<span class="font-display text-sm font-semibold tracking-[0.18em] uppercase">
				· {item}
			</span>
		{/each}
	</div>
</div>
