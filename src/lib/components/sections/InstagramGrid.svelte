<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { INSTAGRAM_PROFILE_URL, INSTAGRAM_TILES, type InstagramTile } from '$lib/data/instagram';

	const tiles: ReadonlyArray<InstagramTile> = INSTAGRAM_TILES;
</script>

<section
	class="bg-brand-cream border-hairline border-b"
	aria-label={$_('instagram.grid_label')}
>
	<div class="mx-auto max-w-6xl px-4 py-16 sm:px-6 sm:py-20 lg:py-24">
		<div class="flex flex-col items-start gap-3 sm:flex-row sm:items-end sm:justify-between">
			<div class="flex flex-col gap-2">
				<span class="text-brand-ink/60 font-mono text-[10px] tracking-[0.2em] uppercase">
					{$_('instagram.handle')}
				</span>
				<h3
					class="text-brand-ink font-display text-2xl font-semibold tracking-tight sm:text-3xl"
				>
					{$_('instagram.headline')}
				</h3>
			</div>
			<a
				href={INSTAGRAM_PROFILE_URL}
				target="_blank"
				rel="noopener noreferrer"
				class="text-brand-ink hover:text-brand-orange text-xs font-semibold tracking-[0.18em] uppercase"
			>
				{$_('instagram.open_link')}
			</a>
		</div>

		<div class="mt-10 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5 lg:gap-4">
			{#each tiles as tile (tile.src)}
				<a
					href={tile.postUrl}
					target="_blank"
					rel="noopener noreferrer"
					class="border-hairline focus-visible:ring-brand-orange block overflow-hidden border focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-offset-brand-cream"
					aria-label={tile.caption}
				>
					<figure class="bg-brand-cream aspect-square">
						<img
							src={tile.src}
							alt={tile.caption}
							loading="lazy"
							decoding="async"
							class="h-full w-full object-cover"
							width="1080"
							height="1080"
						/>
					</figure>
				</a>
			{/each}
		</div>
	</div>
</section>
