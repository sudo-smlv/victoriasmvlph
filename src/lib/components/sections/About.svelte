<script lang="ts">
	import { _ } from 'svelte-i18n';
	import * as Card from '$lib/components/ui/card';
	import { Badge } from '$lib/components/ui/badge';
	import { Separator } from '$lib/components/ui/separator';
	import { Camera, MapPin, ArrowUpRight } from '@lucide/svelte';

	function stringOf(key: string): string {
		const value = $_(key);
		return typeof value === 'string' ? value : '';
	}

	function paragraphsOf(key: string): string[] {
		return stringOf(key)
			.split(/\n\n+/)
			.map((p) => p.trim())
			.filter(Boolean);
	}

	const locations: ReadonlyArray<{ key: string; label: string }> = [
		{ key: 'freiburg', label: 'Freiburg' },
		{ key: 'basel', label: 'Basel' },
		{ key: 'badenbaden', label: 'Baden-Baden' },
		{ key: 'schwarzwald', label: 'Schwarzwald' },
		{ key: 'titisee', label: 'Titisee' },
		{ key: 'schluchsee', label: 'Schluchsee' }
	];
</script>

<section id="about" class="bg-brand-cream border-hairline border-b" 	aria-label={$_('a11y.section_about')}>
	<div class="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
		<div class="grid gap-10 md:grid-cols-12 md:gap-12">
			<div class="flex flex-col gap-4 md:col-span-5">
				<span
					class="border-hairline text-brand-ink bg-brand-cream w-fit border px-3 py-1 font-mono text-[10px] tracking-[0.4em] uppercase"
				>
					— 03 / {$_('about.title')}
				</span>
				<h2
					class="text-brand-ink font-display text-[clamp(2rem,5vw,3.5rem)] leading-[1] font-semibold tracking-tight"
				>
					{$_('about.title')}
				</h2>
				<Card.Root class="bg-brand-yellow text-brand-ink rounded-none border-0 p-0">
					<div
						class="flex aspect-[4/5] w-full items-center justify-center"
						aria-hidden="true"
					>
						<Camera class="size-12 sm:size-16" />
					</div>
				</Card.Root>
			</div>

			<div
				class="text-brand-ink/80 flex flex-col gap-5 text-base leading-relaxed md:col-span-7"
			>
				{#each paragraphsOf('about.body') as paragraph (paragraph)}
					<p>{paragraph}</p>
				{/each}

				<Separator class="bg-hairline mt-2" />

				<div class="flex flex-col gap-3">
					<p class="text-brand-ink text-sm font-semibold">
						<MapPin class="text-brand-ink/70 mr-1 inline size-4 align-text-bottom" />
						{$_('about.locations.title')}
					</p>
					<div class="flex flex-wrap gap-2">
						{#each locations as loc (loc.key)}
							<Badge
								variant="outline"
								class="border-brand-ink text-brand-ink rounded-none bg-transparent px-3 py-1 text-[11px] font-semibold tracking-[0.18em] uppercase"
							>
								{loc.label}
							</Badge>
						{/each}
					</div>
				</div>

				<div class="mt-2 flex items-center gap-2">
					<ArrowUpRight class="text-brand-orange size-4" />
					<span class="font-mono text-[10px] tracking-[0.3em] uppercase opacity-70">
						{$_('common.appName')}
					</span>
				</div>
			</div>
		</div>
	</div>
</section>
