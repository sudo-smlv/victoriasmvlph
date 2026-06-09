<script lang="ts">
	import { onMount } from 'svelte';
	import { _ } from 'svelte-i18n';
	import { Button } from '$lib/components/ui/button';
	import { Badge } from '$lib/components/ui/badge';
	import { Camera, Sparkles, ArrowUpRight, ChevronLeft, ChevronRight, Play, Pause } from '@lucide/svelte';

	type HeroSlide = {
		alt: string;
		caption: string;
		/** Tailwind class for the placeholder swatch (used until real images are wired). */
		swatch: string;
	};

	const PLACEHOLDER_SLIDES: HeroSlide[] = [
		{ alt: 'Lifestyle portrait in golden hour light', caption: 'Golden hour, Freiburg', swatch: 'bg-brand-orange/85' },
		{ alt: 'Couple walking through Black Forest pines', caption: 'Black Forest', swatch: 'bg-brand-ink' },
		{ alt: 'Editorial Reels frame on a Basel terrace', caption: 'Basel terrace', swatch: 'bg-brand-yellow' },
		{ alt: 'Premium photo album spread', caption: 'Photo album №01', swatch: 'bg-brand-charcoal' }
	];

	const SLIDE_DURATION_MS = 5000;
	const SWIPE_THRESHOLD_PX = 40;

	let slides = $state<HeroSlide[]>(PLACEHOLDER_SLIDES);
	let activeIndex = $state(0);
	let isPlaying = $state(true);
	let prefersReducedMotion = $state(false);
	let touchStartX = 0;

	function next() {
		activeIndex = (activeIndex + 1) % slides.length;
	}
	function prev() {
		activeIndex = (activeIndex - 1 + slides.length) % slides.length;
	}
	function goTo(index: number) {
		if (index < 0 || index >= slides.length) return;
		activeIndex = index;
	}
	function togglePlay() {
		isPlaying = !isPlaying;
	}

	function handleKey(event: KeyboardEvent) {
		if (event.key === 'ArrowRight') {
			event.preventDefault();
			next();
		} else if (event.key === 'ArrowLeft') {
			event.preventDefault();
			prev();
		} else if (event.key === ' ' || event.key === 'Spacebar') {
			event.preventDefault();
			togglePlay();
		}
	}

	function handleTouchStart(event: TouchEvent) {
		touchStartX = event.touches[0]?.clientX ?? 0;
	}
	function handleTouchEnd(event: TouchEvent) {
		const delta = (event.changedTouches[0]?.clientX ?? touchStartX) - touchStartX;
		if (Math.abs(delta) < SWIPE_THRESHOLD_PX) return;
		if (delta < 0) next();
		else prev();
	}

	function scrollToContact(event: MouseEvent) {
		event.preventDefault();
		document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
	}

	onMount(() => {
		const mq = window.matchMedia('(prefers-reduced-motion: reduce)');
		prefersReducedMotion = mq.matches;
		isPlaying = !mq.matches;
		const onChange = (e: MediaQueryListEvent) => {
			prefersReducedMotion = e.matches;
			isPlaying = !e.matches;
		};
		mq.addEventListener('change', onChange);
		return () => mq.removeEventListener('change', onChange);
	});

	$effect(() => {
		if (prefersReducedMotion) return;
		if (!isPlaying) return;
		if (slides.length < 2) return;
		const id = setInterval(() => next(), SLIDE_DURATION_MS);
		return () => clearInterval(id);
	});
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
			<!-- svelte-ignore a11y_no_noninteractive_tabindex -->
			<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
			<div
				role="region"
				aria-roledescription="carousel"
				aria-label={$_('hero.headline')}
				tabindex="0"
				ontouchstart={handleTouchStart}
				ontouchend={handleTouchEnd}
				onkeydown={handleKey}
				onmouseenter={() => (isPlaying = false)}
				onmouseleave={() => {
					if (!prefersReducedMotion) isPlaying = true;
				}}
				onfocusin={() => (isPlaying = false)}
				onfocusout={() => {
					if (!prefersReducedMotion) isPlaying = true;
				}}
				class="outline-none"
			>
				<div
					class="border-hairline bg-brand-cream relative aspect-[4/5] w-full overflow-hidden border"
				>
					{#each slides as slide, i (i)}
						<div
							id="hero-slide-{i}"
							role="tabpanel"
							aria-labelledby="hero-thumb-{i}"
							aria-label={$_('hero.controls.slide_status', {
								values: {
									index: i + 1,
									total: slides.length,
									caption: slide.caption
								}
							})}
							class="absolute inset-0 transition-opacity duration-700 ease-out {i === activeIndex
								? 'opacity-100'
								: 'opacity-0'}"
						>
							<div
								class="{slide.swatch} text-brand-cream flex h-full w-full items-center justify-center"
								aria-label={slide.alt}
							>
								<Camera class="size-12 opacity-30 sm:size-16" />
							</div>
						</div>
					{/each}

					<span
						class="bg-brand-orange text-brand-ink absolute top-4 right-4 z-10 max-w-[60%] truncate px-2 py-1 text-[10px] font-semibold tracking-[0.18em] uppercase"
					>
						{slides[activeIndex]?.caption ?? ''}
					</span>
					<span
						class="bg-brand-cream text-brand-ink absolute bottom-4 left-4 z-10 border-hairline border px-2 py-1 font-mono text-[10px] tracking-widest uppercase"
					>
						№ {String(activeIndex + 1).padStart(2, '0')} / {String(slides.length).padStart(2, '0')}
					</span>

					<div class="absolute inset-y-0 left-0 z-10 flex items-center">
						<button
							type="button"
							onclick={prev}
							aria-label={$_('hero.controls.prev')}
							class="bg-brand-cream/90 text-brand-ink hover:bg-brand-cream m-2 flex h-9 w-9 items-center justify-center backdrop-blur-sm"
						>
							<ChevronLeft class="size-4" />
						</button>
					</div>
					<div class="absolute inset-y-0 right-0 z-10 flex items-center">
						<button
							type="button"
							onclick={next}
							aria-label={$_('hero.controls.next')}
							class="bg-brand-cream/90 text-brand-ink hover:bg-brand-cream m-2 flex h-9 w-9 items-center justify-center backdrop-blur-sm"
						>
							<ChevronRight class="size-4" />
						</button>
					</div>

					<button
						type="button"
						onclick={togglePlay}
						aria-label={isPlaying ? $_('hero.controls.pause') : $_('hero.controls.play')}
						aria-pressed={isPlaying}
						class="bg-brand-cream/90 text-brand-ink hover:bg-brand-cream absolute top-4 left-4 z-10 flex h-9 items-center gap-1.5 px-3 backdrop-blur-sm"
					>
						{#if isPlaying}
							<Pause class="size-3.5" />
						{:else}
							<Play class="size-3.5" />
						{/if}
						<span class="font-mono text-[10px] tracking-widest uppercase">
							{isPlaying ? $_('hero.controls.pause') : $_('hero.controls.play')}
						</span>
					</button>
				</div>

				<div
					role="tablist"
					aria-label={$_('hero.headline')}
					class="mt-4 grid gap-3"
					style="grid-template-columns: repeat({slides.length}, minmax(0, 1fr));"
				>
					{#each slides as slide, i (i)}
						<button
							type="button"
							role="tab"
							id="hero-thumb-{i}"
							aria-selected={i === activeIndex}
							aria-controls="hero-slide-{i}"
							aria-label={$_('hero.controls.slide_label', {
								values: { index: i + 1, total: slides.length }
							})}
							onclick={() => goTo(i)}
							class="group relative aspect-square overflow-hidden border-2 transition-colors {i ===
							activeIndex
								? 'border-brand-ink'
								: 'border-hairline hover:border-brand-ink/50'}"
						>
							<div
								class="{slide.swatch} text-brand-cream flex h-full w-full items-center justify-center"
							>
								<Camera class="size-5 opacity-50 transition-opacity group-hover:opacity-80" />
							</div>
						</button>
					{/each}
				</div>

				<div class="mt-3 flex items-center justify-between gap-2">
					<p
						class="text-brand-ink/70 font-mono text-[10px] tracking-widest uppercase"
						aria-live="polite"
						aria-atomic="true"
					>
						{String(activeIndex + 1).padStart(2, '0')} / {String(slides.length).padStart(2, '0')}
						— {slides[activeIndex]?.caption ?? ''}
					</p>
					<div class="flex items-center gap-1.5">
						{#each slides as _slide, i (i)}
							<button
								type="button"
								aria-label={$_('hero.controls.slide_label', {
									values: { index: i + 1, total: slides.length }
								})}
								onclick={() => goTo(i)}
								class="h-1.5 rounded-full transition-all {i === activeIndex
									? 'bg-brand-ink w-6'
									: 'bg-brand-ink/25 hover:bg-brand-ink/50 w-1.5'}"
								aria-current={i === activeIndex ? 'true' : 'false'}
							></button>
						{/each}
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
