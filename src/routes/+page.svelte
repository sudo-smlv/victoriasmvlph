<script lang="ts">
	import { _, json, locale } from 'svelte-i18n';
	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card';
	import { Badge } from '$lib/components/ui/badge';
	import { Separator } from '$lib/components/ui/separator';
	import { Camera, Send, MapPin, Calendar, Clock, Sparkles, Check, BookOpen } from '@lucide/svelte';

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

<section class="mx-auto flex max-w-6xl flex-col gap-8 px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
	<div class="flex flex-col items-start gap-6">
		<Badge variant="secondary" class="gap-1.5">
			<Sparkles class="size-3" />
			{$_('common.tagline')}
		</Badge>
		<h1 class="text-4xl leading-tight font-semibold tracking-tight sm:text-5xl lg:text-6xl">
			{$_('hero.headline')}
		</h1>
		<p class="text-muted-foreground max-w-2xl text-base sm:text-lg">
			{$_('hero.subheadline')}
		</p>
		<div class="flex flex-wrap items-center gap-3">
			<Button size="lg" onclick={scrollToContact}>
				<Calendar class="size-4" />
				{$_('hero.cta_primary')}
			</Button>
		</div>
	</div>

	<!-- Hero image placeholder.
	     The repo does not ship real photographs. The photographer can swap
	     this Card for a real <img> (e.g. an Unsplash URL with
	     ?auto=format&fit=crop&w=...) while keeping the surrounding aspect
	     ratio. -->
	<Card.Root class="bg-muted/40 overflow-hidden border-dashed p-0">
		<div
			class="bg-muted/60 text-muted-foreground flex aspect-[16/9] w-full items-center justify-center gap-3 sm:aspect-[21/9]"
			aria-hidden="true"
		>
			<Camera class="size-8 sm:size-10" />
			<span class="text-sm font-medium sm:text-base">{$_('common.tagline')}</span>
		</div>
	</Card.Root>
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
