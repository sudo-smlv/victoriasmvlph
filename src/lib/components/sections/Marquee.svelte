<script lang="ts">
	// Decorative marquee strip — visual chrome only, no user-facing text.
	// Per the design spec: marquee contents are intentionally hardcoded
	// because they are repeating accent labels, not translatable copy.
	const items: ReadonlyArray<string> = [
		'Flash',
		'Reflectors',
		'Tripod',
		'Light kit',
		'Backdrop',
		'Camera',
		'Straps',
		'Editing',
		'Albums'
	];
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
