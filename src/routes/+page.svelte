<script lang="ts">
	import { _, json, locale } from 'svelte-i18n';
	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card';
	import { Badge } from '$lib/components/ui/badge';
	import { Separator } from '$lib/components/ui/separator';
	import {
		Camera,
		Send,
		MapPin,
		Clock,
		Sparkles,
		Check,
		BookOpen,
		ArrowRight
	} from '@lucide/svelte';

	type Bullet = string;

	interface PackageData {
		key: 'mini' | 'moment' | 'atmosphere';
		name: string;
		price: string;
		bullets: Bullet[];
		delivery: string;
	}

	function scrollToContact(event: MouseEvent) {
		event.preventDefault();
		document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
	}

	// svelte-i18n `$format` (`$_`) is string-only, so we use `$json` for
	// array catalog entries. `stringOf` narrows the type at the boundary.
	function bulletsOf(key: string): Bullet[] {
		const value = $json(key);
		return Array.isArray(value) ? (value as Bullet[]) : [];
	}

	function stringOf(key: string): string {
		const value = $_(key);
		return typeof value === 'string' ? value : '';
	}

	const packages = $derived.by<Record<'mini' | 'moment' | 'atmosphere', PackageData>>(() => {
		// Reading $locale explicitly makes the derived re-run on language change.
		$locale;
		return {
			mini: {
				key: 'mini',
				name: stringOf('packages.mini.name'),
				price: stringOf('packages.mini.price'),
				bullets: bulletsOf('packages.mini.bullets'),
				delivery: stringOf('packages.mini.delivery')
			},
			moment: {
				key: 'moment',
				name: stringOf('packages.moment.name'),
				price: stringOf('packages.moment.price'),
				bullets: bulletsOf('packages.moment.bullets'),
				delivery: stringOf('packages.moment.delivery')
			},
			atmosphere: {
				key: 'atmosphere',
				name: stringOf('packages.atmosphere.name'),
				price: stringOf('packages.atmosphere.price'),
				bullets: bulletsOf('packages.atmosphere.bullets'),
				delivery: stringOf('packages.atmosphere.delivery')
			}
		};
	});

	// Location labels are proper nouns kept as-is across locales per the
	// CLA-3 / CLA-1 spec (city names, "Schwarzwald", etc.).
	const locations = [
		{ key: 'freiburg', label: 'Freiburg' },
		{ key: 'basel', label: 'Basel' },
		{ key: 'badenbaden', label: 'Baden-Baden' },
		{ key: 'schwarzwald', label: 'Schwarzwald' },
		{ key: 'titisee', label: 'Titisee' },
		{ key: 'schluchsee', label: 'Schluchsee' }
	];

	const INSTAGRAM_URL = 'https://instagram.com/victoriasmvlph';
	const TELEGRAM_URL = 'https://t.me/victoriasmvlph';

	function paragraphsOf(key: string): string[] {
		const value = stringOf(key);
		return value.split(/\n\n+/).map((p) => p.trim()).filter(Boolean);
	}
</script>

<!-- The page consumes the i18n catalog authored by CLA-3 (commit 4155b79 on
     feat/cla-3-i18n-catalog). The recommended-package badge label is wired
     to `packages.moment.featured`, which is defined in all three locales. -->

<!-- Editorial Hero.
     Design only — every i18n key, component, and text string is the same
     as the previous version. Layout is a two-column asymmetric grid on
     desktop (text + polaroid image) and stacked on mobile. The
     photographer can drop real <img> tags into the Card placeholders
     later, keeping the surrounding aspect ratio and the rotation. -->
<section class="mx-auto max-w-6xl px-4 pt-10 pb-12 sm:px-6 sm:pt-14 lg:pt-16 lg:pb-20">
	<!-- Top meta row: tagline + "01" indicator + decorative quote -->
	<div class="mb-8 flex flex-wrap items-center justify-between gap-3 sm:mb-10">
		<Badge variant="secondary" class="gap-1.5">
			<Sparkles class="size-3" />
			{$_('common.tagline')}
		</Badge>
		<div class="text-muted-foreground flex items-center gap-2 text-xs tracking-[0.3em] uppercase">
			<span>01 / Hero</span>
		</div>
	</div>

	<div class="grid gap-12 lg:grid-cols-12 lg:gap-10">
		<!-- Left column: typography + CTA -->
		<div class="flex flex-col gap-6 lg:col-span-7 lg:gap-7">
			<!-- Editorial kicker -->
			<div class="flex items-center gap-2 text-yellow-600 dark:text-yellow-400">
				<Sparkles class="size-4" />
				<span class="text-xs font-semibold tracking-[0.25em] uppercase">
					{$_('common.tagline')}
				</span>
			</div>

			<!-- Big display headline -->
			<h1
				class="text-foreground text-5xl leading-[0.92] font-black tracking-[-0.04em] sm:text-6xl lg:text-7xl xl:text-[5.5rem]"
			>
				{$_('hero.headline')}
			</h1>

			<!-- Subheadline with editorial indent -->
			<p
				class="text-muted-foreground max-w-xl text-base leading-relaxed sm:text-lg lg:text-xl"
			>
				{$_('hero.subheadline')}
			</p>

			<!-- CTA row + secondary "Read my story" link styled like the reference -->
			<div class="flex flex-wrap items-center gap-4 pt-2">
				<Button
					size="lg"
					onclick={scrollToContact}
					class="bg-yellow-300 text-black hover:bg-yellow-400 border-0 shadow-sm"
				>
					{$_('hero.cta_primary')}
					<ArrowRight class="size-4" />
				</Button>
				<a
					href="#about"
					class="text-foreground text-sm font-semibold tracking-[0.2em] uppercase underline decoration-2 underline-offset-4 hover:decoration-yellow-400"
				>
					{$_('common.nav.about')}
				</a>
			</div>

			<!-- Page indicator dots -->
			<div
				class="mt-2 flex items-center gap-1.5"
				aria-label="Hero pagination indicator"
			>
				<span class="bg-foreground size-2.5 rounded-full" aria-hidden="true"></span>
				<span
					class="bg-foreground/30 size-2.5 rounded-full"
					aria-hidden="true"
				></span>
				<span
					class="bg-foreground/30 size-2.5 rounded-full"
					aria-hidden="true"
				></span>
				<span
					class="bg-foreground/30 size-2.5 rounded-full"
					aria-hidden="true"
				></span>
			</div>
		</div>

		<!-- Right column: polaroid-style hero image + caption -->
		<div class="relative flex items-start justify-center lg:col-span-5 lg:justify-end">
			<!-- Decorative quote mark in the background -->
			<span
				class="text-foreground/10 absolute -top-6 -left-2 select-none text-[8rem] leading-none font-black sm:text-[10rem] lg:text-[12rem]"
				aria-hidden="true"
			>
				&rdquo;
			</span>

			<!-- Polaroid-style image card with rotation -->
			<Card.Root
				class="bg-muted/40 relative w-full max-w-md -rotate-2 overflow-hidden rounded-md border-2 p-3 shadow-lg sm:max-w-lg lg:max-w-none"
			>
				<div
					class="bg-muted/60 text-muted-foreground flex aspect-[4/5] w-full items-center justify-center gap-3"
					aria-hidden="true"
				>
					<Camera class="size-10 sm:size-12" />
				</div>
				<!-- Polaroid caption row -->
				<div class="mt-3 flex items-center justify-between gap-2">
					<span class="text-muted-foreground text-xs tracking-[0.2em] uppercase">
						01
					</span>
					<span class="text-muted-foreground text-xs italic">
						{$_('common.tagline')}
					</span>
				</div>
			</Card.Root>

			<!-- Decorative "→" arrow on the right of the polaroid -->
			<span
				class="text-foreground/40 absolute right-0 bottom-4 select-none text-3xl"
				aria-hidden="true"
			>
				→
			</span>
		</div>
	</div>
</section>

<Separator />

<section id="about" class="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
	<div class="grid gap-10 md:grid-cols-5 md:gap-12">
		<div class="md:col-span-2">
			<div class="flex items-center gap-2">
				<Sparkles class="text-muted-foreground size-4" />
				<h2 class="text-2xl font-semibold tracking-tight sm:text-3xl">
					{$_('about.title')}
				</h2>
			</div>
			<Separator class="mt-4" />
		</div>
		<div class="text-muted-foreground flex flex-col gap-5 text-base leading-relaxed md:col-span-3">
			{#each paragraphsOf('about.body') as paragraph (paragraph)}
				<p>{paragraph}</p>
			{/each}
			<div class="mt-2 flex flex-col gap-3">
				<p class="text-foreground text-sm font-semibold">
					<MapPin class="text-muted-foreground mr-1 inline size-4 align-text-bottom" />
					{$_('about.locations.title')}
				</p>
				<div class="flex flex-wrap gap-2">
					{#each locations as loc (loc.key)}
						<Badge variant="outline">{loc.label}</Badge>
					{/each}
				</div>
			</div>
		</div>
	</div>
</section>

<Separator />

<section id="services" class="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
	<div class="flex flex-col items-start gap-3">
		<Badge variant="secondary">{$_('services.title')}</Badge>
		<h2 class="text-2xl font-semibold tracking-tight sm:text-3xl">
			{$_('services.title')}
		</h2>
		<p class="text-muted-foreground max-w-2xl text-base">
			{$_('services.subtitle')}
		</p>
	</div>

	<div class="mt-10 grid gap-6 md:grid-cols-2 lg:mt-12 lg:grid-cols-3">
		<Card.Root class="flex h-full flex-col">
			<Card.Header>
				<Card.Title class="text-2xl">
					{packages.mini.name}
				</Card.Title>
			</Card.Header>
			<Card.Content class="flex flex-1 flex-col gap-4">
				<div class="text-foreground text-3xl font-semibold tracking-tight">
					{packages.mini.price}
				</div>
				<ul class="flex flex-col gap-2 text-sm">
					{#each packages.mini.bullets as bullet (bullet)}
						<li class="flex items-start gap-2">
							<Check class="text-muted-foreground mt-0.5 size-4 shrink-0" />
							<span>{bullet}</span>
						</li>
					{/each}
				</ul>
			</Card.Content>
			<Card.Footer class="text-muted-foreground flex items-center gap-2 text-xs">
				<Clock class="size-3.5" />
				{packages.mini.delivery}
			</Card.Footer>
		</Card.Root>

		<Card.Root class="ring-ring relative flex h-full flex-col ring-2">
			<Badge class="absolute -top-3 left-6 shadow-sm">
				{$_('packages.moment.featured')}
			</Badge>
			<Card.Header>
				<Card.Title class="text-2xl">
					{packages.moment.name}
				</Card.Title>
			</Card.Header>
			<Card.Content class="flex flex-1 flex-col gap-4">
				<div class="text-foreground text-3xl font-semibold tracking-tight">
					{packages.moment.price}
				</div>
				<ul class="flex flex-col gap-2 text-sm">
					{#each packages.moment.bullets as bullet (bullet)}
						<li class="flex items-start gap-2">
							<Check class="text-muted-foreground mt-0.5 size-4 shrink-0" />
							<span>{bullet}</span>
						</li>
					{/each}
				</ul>
			</Card.Content>
			<Card.Footer class="text-muted-foreground flex items-center gap-2 text-xs">
				<Clock class="size-3.5" />
				{packages.moment.delivery}
			</Card.Footer>
		</Card.Root>

		<Card.Root class="flex h-full flex-col">
			<Card.Header>
				<Card.Title class="text-2xl">
					{packages.atmosphere.name}
				</Card.Title>
			</Card.Header>
			<Card.Content class="flex flex-1 flex-col gap-4">
				<div class="text-foreground text-3xl font-semibold tracking-tight">
					{packages.atmosphere.price}
				</div>
				<ul class="flex flex-col gap-2 text-sm">
					{#each packages.atmosphere.bullets as bullet (bullet)}
						<li class="flex items-start gap-2">
							<Check class="text-muted-foreground mt-0.5 size-4 shrink-0" />
							<span>{bullet}</span>
						</li>
					{/each}
				</ul>
			</Card.Content>
			<Card.Footer class="text-muted-foreground flex items-center gap-2 text-xs">
				<Clock class="size-3.5" />
				{packages.atmosphere.delivery}
			</Card.Footer>
		</Card.Root>
	</div>
</section>

<Separator />

<section id="books" class="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
	<div class="grid gap-10 md:grid-cols-5 md:gap-12">
		<div class="md:col-span-2">
			<div class="flex items-center gap-2">
				<BookOpen class="text-muted-foreground size-4" />
				<h2 class="text-2xl font-semibold tracking-tight sm:text-3xl">
					{$_('books.title')}
				</h2>
			</div>
			<Separator class="mt-4" />
			<Card.Root class="bg-muted/40 mt-6 border-dashed p-0">
				<div
					class="bg-muted/60 text-muted-foreground flex aspect-[4/3] w-full items-center justify-center gap-3"
					aria-hidden="true"
				>
					<BookOpen class="size-8" />
				</div>
			</Card.Root>
		</div>
		<div class="text-muted-foreground flex flex-col gap-5 text-base leading-relaxed md:col-span-3">
			{#each paragraphsOf('books.body') as paragraph (paragraph)}
				<p>{paragraph}</p>
			{/each}
		</div>
	</div>
</section>

<Separator />

<section id="contact" class="mx-auto max-w-6xl scroll-mt-20 px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
	<Card.Root class="bg-card">
		<Card.Header>
			<Badge variant="secondary" class="w-fit">{$_('contact.title')}</Badge>
			<Card.Title class="text-2xl sm:text-3xl">
				{$_('contact.title')}
			</Card.Title>
			<Card.Description class="text-base">
				{$_('contact.body')}
			</Card.Description>
		</Card.Header>
		<Card.Content class="flex flex-col gap-3 sm:flex-row">
			<Button
				href={INSTAGRAM_URL}
				target="_blank"
				rel="noopener noreferrer"
				size="lg"
				class="flex-1"
			>
				<Camera class="size-4" />
				{$_('contact.instagram_label')}
			</Button>
			<Button
				href={TELEGRAM_URL}
				target="_blank"
				rel="noopener noreferrer"
				size="lg"
				variant="outline"
				class="flex-1"
			>
				<Send class="size-4" />
				{$_('contact.telegram_label')}
			</Button>
		</Card.Content>
	</Card.Root>
</section>
