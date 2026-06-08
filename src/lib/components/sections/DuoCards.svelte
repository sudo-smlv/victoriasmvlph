<script lang="ts">
	import { _ } from 'svelte-i18n';
	import * as Card from '$lib/components/ui/card';
	import { Camera } from '@lucide/svelte';

	// DuoCards — twin photography-card block from the design spec.
	// Labels and titles are decorative chrome (numbered cards), not user-facing
	// copy, and the spec explicitly excluded them from the i18n catalog.
	const cards: ReadonlyArray<{ number: string; label: string; title: string; tagline: string }> = [
		{
			number: '00',
			label: 'Editorial',
			title: 'Studio portrait',
			tagline: 'Controlled light, classic frame.'
		},
		{
			number: '01',
			label: 'Lifestyle',
			title: 'Outdoor walk',
			tagline: 'Cinematic location, soft light.'
		}
	];
</script>

<section
	class="bg-brand-cream border-hairline border-b"
	aria-label="Photography duo"
>
	<div
		class="mx-auto grid max-w-6xl gap-6 px-4 py-12 sm:px-6 sm:py-16 lg:grid-cols-2 lg:gap-8 lg:py-20"
	>
		{#each cards as card (card.number)}
			<Card.Root class="bg-brand-cream border-hairline rounded-none p-0">
				<div
					class="bg-brand-ink/[0.04] text-brand-ink/50 flex aspect-[4/3] w-full items-center justify-center"
					aria-hidden="true"
				>
					<Camera class="size-12 sm:size-16" />
				</div>
				<div class="flex items-start justify-between gap-4 p-5">
					<div class="flex flex-col gap-1">
						<span
							class="text-brand-ink/60 font-mono text-[10px] tracking-[0.3em] uppercase"
						>
							{card.label}
						</span>
						<h3 class="text-brand-ink font-display text-2xl font-semibold tracking-tight">
							{card.title}
						</h3>
						<p class="text-brand-ink/70 text-sm">{card.tagline}</p>
					</div>
					<span
						class="text-brand-ink/40 font-mono text-3xl leading-none tracking-tight"
						aria-hidden="true"
					>
						{card.number}
					</span>
				</div>
			</Card.Root>
		{/each}
	</div>
</section>
