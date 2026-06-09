<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { Camera, Plus } from '@lucide/svelte';

	const tiles: ReadonlyArray<{ num: string; tone: 'cream' | 'ink' | 'orange' | 'yellow' }> = [
		{ num: '01', tone: 'cream' },
		{ num: '02', tone: 'ink' },
		{ num: '03', tone: 'orange' },
		{ num: '04', tone: 'yellow' },
		{ num: '05', tone: 'cream' }
	];
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
				href="https://instagram.com/victoriasmvlph"
				target="_blank"
				rel="noopener noreferrer"
				class="text-brand-ink hover:text-brand-orange text-xs font-semibold tracking-[0.18em] uppercase"
			>
				{$_('instagram.open_link')}
			</a>
		</div>

		<div class="mt-10 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5 lg:gap-4">
			{#each tiles as tile (tile.num)}
				<figure
					class="border-hairline relative flex aspect-square items-center justify-center overflow-hidden border"
					class:bg-brand-cream={tile.tone === 'cream'}
					class:bg-brand-ink={tile.tone === 'ink'}
					class:bg-brand-orange={tile.tone === 'orange'}
					class:bg-brand-yellow={tile.tone === 'yellow'}
				>
					<span
						class="flex items-center justify-center"
						class:text-brand-ink={tile.tone !== 'ink'}
						class:text-brand-cream={tile.tone === 'ink'}
					>
						<Camera class="size-8" />
					</span>
					<span
						class="absolute top-2 left-2 px-1.5 py-0.5 font-mono text-[10px] tracking-[0.2em] uppercase"
						class:text-brand-ink={tile.tone !== 'ink'}
						class:text-brand-cream={tile.tone === 'ink'}
					>
						№ {tile.num}
					</span>
					<span
						class="absolute right-2 bottom-2"
						class:text-brand-ink={tile.tone !== 'ink'}
						class:text-brand-cream={tile.tone === 'ink'}
						aria-hidden="true"
					>
						<Plus class="size-4" />
					</span>
				</figure>
			{/each}
		</div>
	</div>
</section>
