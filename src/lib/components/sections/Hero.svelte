<script lang="ts">
	import { onDestroy, onMount } from 'svelte';
	import { _ } from 'svelte-i18n';
	import { Button } from '$lib/components/ui/button';
	import { Badge } from '$lib/components/ui/badge';
	import { Camera, Sparkles, ArrowUpRight, ChevronLeft, ChevronRight } from '@lucide/svelte';

	type Slide = {
		taglineKey: 'intro.tagline_lead' | 'duo.card1_tagline' | 'duo.card2_tagline';
		swatchClass: string;
		textClass: string;
	};

	const SLIDES: Slide[] = [
		{ taglineKey: 'intro.tagline_lead', swatchClass: 'bg-brand-orange/55', textClass: 'text-brand-ink' },
		{ taglineKey: 'duo.card1_tagline', swatchClass: 'bg-brand-yellow/70', textClass: 'text-brand-ink' },
		{ taglineKey: 'duo.card2_tagline', swatchClass: 'bg-brand-ink', textClass: 'text-brand-cream' }
	];

	const SLIDE_DURATION_MS = 5000;

	let currentSlide = $state(0);
	let prefersReducedMotion = $state(false);
	let liveAnnouncement = $state('');
	let timer: ReturnType<typeof setInterval> | null = null;

	function nextSlide() {
		currentSlide = (currentSlide + 1) % SLIDES.length;
	}

	function prevSlide() {
		currentSlide = (currentSlide - 1 + SLIDES.length) % SLIDES.length;
	}

	function goToSlide(index: number) {
		if (index < 0 || index >= SLIDES.length) return;
		currentSlide = index;
	}

	function handleIndicatorKey(event: KeyboardEvent, index: number) {
		if (event.key === 'ArrowRight') {
			event.preventDefault();
			goToSlide((index + 1) % SLIDES.length);
		} else if (event.key === 'ArrowLeft') {
			event.preventDefault();
			goToSlide((index - 1 + SLIDES.length) % SLIDES.length);
		} else if (event.key === 'Home') {
			event.preventDefault();
			goToSlide(0);
		} else if (event.key === 'End') {
			event.preventDefault();
			goToSlide(SLIDES.length - 1);
		}
	}

	function clearTimer() {
		if (timer !== null) {
			clearInterval(timer);
			timer = null;
		}
	}

	function startTimer() {
		clearTimer();
		if (prefersReducedMotion) return;
		timer = setInterval(nextSlide, SLIDE_DURATION_MS);
	}

	function formatTemplate(template: string, current: number, total: number): string {
		return template.replace('{current}', String(current)).replace('{total}', String(total));
	}

	$effect(() => {
		const template = $_(`hero.slideshow_slide_label`) as string;
		liveAnnouncement = formatTemplate(template, currentSlide + 1, SLIDES.length);
	});

	$effect(() => {
		if (prefersReducedMotion) {
			clearTimer();
		} else {
			startTimer();
		}
	});

	onMount(() => {
		const mq = window.matchMedia('(prefers-reduced-motion: reduce)');
		prefersReducedMotion = mq.matches;
		const onChange = (event: MediaQueryListEvent) => {
			prefersReducedMotion = event.matches;
		};
		mq.addEventListener('change', onChange);
		return () => mq.removeEventListener('change', onChange);
	});

	onDestroy(() => {
		clearTimer();
	});

	function scrollToContact(event: MouseEvent) {
		event.preventDefault();
		document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
	}
</script>

<section
	id="hero"
	class="bg-brand-cream border-hairline border-b"
	aria-label={$_('a11y.section_hero')}
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
			<div
				role="region"
				aria-roledescription="carousel"
				aria-label={$_('hero.slideshow_label')}
				class="border-hairline bg-brand-cream relative aspect-[4/5] w-full overflow-hidden border"
			>
				{#each SLIDES as slide, i (slide.taglineKey)}
					<div
						class="absolute inset-0 flex items-center justify-center p-6 transition-opacity duration-700 ease-in-out sm:p-10"
						class:opacity-100={i === currentSlide}
						class:opacity-0={i !== currentSlide}
						class:pointer-events-none={i !== currentSlide}
						aria-hidden={i !== currentSlide}
						role="group"
						aria-roledescription="slide"
						aria-label={formatTemplate($_('hero.slideshow_slide_label'), i + 1, SLIDES.length)}
					>
						<div
							class="absolute inset-0 {slide.swatchClass}"
							aria-hidden="true"
						></div>
						<div class="relative flex flex-col items-center gap-3 text-center">
							<Camera class="size-10 sm:size-12" aria-hidden="true" />
							<p class="max-w-xs text-sm font-medium sm:text-base md:text-lg {slide.textClass}">
								{$_(slide.taglineKey)}
							</p>
						</div>
					</div>
				{/each}
				<span
					class="bg-brand-orange text-brand-ink absolute top-4 right-4 px-2 py-1 text-[10px] font-semibold tracking-[0.18em] uppercase"
				>
					{$_('common.tagline')}
				</span>
				<span
					class="bg-brand-cream text-brand-ink absolute bottom-4 left-4 border-hairline border px-2 py-1 font-mono text-[10px] tracking-widest uppercase"
					aria-hidden="true"
				>
					{String(currentSlide + 1).padStart(2, '0')} / {String(SLIDES.length).padStart(2, '0')}
				</span>
				<Button
					variant="ghost"
					size="icon"
					onclick={prevSlide}
					aria-label={$_('hero.slideshow_prev')}
					class="bg-brand-cream/80 text-brand-ink hover:bg-brand-cream absolute top-1/2 left-2 -translate-y-1/2 rounded-none p-2 backdrop-blur-sm"
				>
					<ChevronLeft class="size-5" aria-hidden="true" />
				</Button>
				<Button
					variant="ghost"
					size="icon"
					onclick={nextSlide}
					aria-label={$_('hero.slideshow_next')}
					class="bg-brand-cream/80 text-brand-ink hover:bg-brand-cream absolute top-1/2 right-2 -translate-y-1/2 rounded-none p-2 backdrop-blur-sm"
				>
					<ChevronRight class="size-5" aria-hidden="true" />
				</Button>
			</div>
			<div class="sr-only" aria-live="polite" aria-atomic="true">
				{liveAnnouncement}
			</div>
			<div class="mt-4 grid grid-cols-3 gap-3">
				{#each SLIDES as slide, i (slide.taglineKey)}
					<button
						type="button"
						onclick={() => goToSlide(i)}
						onkeydown={(event) => handleIndicatorKey(event, i)}
						aria-label={formatTemplate($_('hero.slideshow_slide_label'), i + 1, SLIDES.length)}
						aria-current={i === currentSlide ? 'true' : undefined}
						class="focus:outline-none focus-visible:ring-2 focus-visible:ring-brand-ink focus-visible:ring-offset-2"
						class:opacity-100={i === currentSlide}
						class:opacity-40={i !== currentSlide}
					>
						<div
							class="{slide.swatchClass} flex aspect-square w-full items-center justify-center border-hairline border"
							aria-hidden="true"
						>
							<Camera class="text-brand-ink/70 size-6" />
						</div>
					</button>
				{/each}
			</div>
		</div>
	</div>
</section>
