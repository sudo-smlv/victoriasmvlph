<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { Button } from '$lib/components/ui/button';
	import { Badge } from '$lib/components/ui/badge';
	import { Camera, Sparkles, ArrowUpRight } from '@lucide/svelte';

	function scrollToContact(event: MouseEvent) {
		event.preventDefault();
		document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
	}
</script>

<section
	id="hero"
	class="bg-brand-cream border-hairline border-b"
	aria-label="Hero"
>
	<div
		class="mx-auto grid max-w-6xl gap-10 px-4 py-12 sm:px-6 sm:py-16 lg:grid-cols-12 lg:gap-12 lg:py-24"
	>
		<div class="flex flex-col gap-6 lg:col-span-7">
			<Badge
				variant="outline"
				class="border-brand-ink text-brand-ink w-fit gap-1.5 rounded-none bg-transparent px-3 py-1 text-[10px] font-semibold tracking-[0.18em] uppercase"
			>
				<Sparkles class="size-3" />
				{$_('common.tagline')}
			</Badge>
			<h1
				class="text-brand-ink text-[clamp(2.75rem,8vw,6.5rem)] leading-[0.95] font-semibold tracking-tight font-display"
			>
				{$_('hero.headline')}
			</h1>
			<p class="text-brand-ink/80 max-w-2xl text-base leading-relaxed sm:text-lg">
				{$_('hero.subheadline')}
			</p>
			<div class="flex flex-wrap items-center gap-3">
				<Button
					size="lg"
					onclick={scrollToContact}
					class="bg-brand-ink text-brand-cream hover:bg-brand-charcoal gap-2 rounded-none px-6 text-xs font-semibold tracking-[0.18em] uppercase"
				>
					{$_('hero.cta_primary')}
					<ArrowUpRight class="size-4" />
				</Button>
				<Button
					size="lg"
					variant="outline"
					href="#services"
					class="border-brand-ink text-brand-ink hover:bg-brand-ink rounded-none px-6 text-xs font-semibold tracking-[0.18em] uppercase hover:text-brand-cream"
				>
					{$_('services.title')}
					<ArrowUpRight class="size-4" />
				</Button>
			</div>
		</div>

		<div class="lg:col-span-5">
			<div class="border-hairline bg-brand-cream relative aspect-[4/5] w-full overflow-hidden border">
				<div
					class="bg-brand-ink/[0.04] text-brand-ink/60 flex h-full w-full items-center justify-center"
					aria-hidden="true"
				>
					<Camera class="size-12 sm:size-16" />
				</div>
				<span
					class="bg-brand-orange text-brand-ink absolute top-4 right-4 px-2 py-1 text-[10px] font-semibold tracking-[0.18em] uppercase"
				>
					{$_('common.tagline')}
				</span>
				<span
					class="bg-brand-cream text-brand-ink absolute bottom-4 left-4 border-hairline border px-2 py-1 font-mono text-[10px] tracking-widest uppercase"
				>
					№ 01 / 24
				</span>
			</div>
			<div class="mt-4 grid grid-cols-3 gap-3">
				<div
					class="bg-brand-yellow text-brand-ink flex aspect-square items-center justify-center"
					aria-hidden="true"
				>
					<span class="font-display text-2xl">✺</span>
				</div>
				<div
					class="border-hairline text-brand-ink/50 flex aspect-square items-center justify-center border border-dashed"
					aria-hidden="true"
				>
					<Camera class="size-6" />
				</div>
				<div
					class="border-hairline text-brand-ink/50 flex aspect-square items-center justify-center border border-dashed"
					aria-hidden="true"
				>
					<Camera class="size-6" />
				</div>
			</div>
		</div>
	</div>
</section>
