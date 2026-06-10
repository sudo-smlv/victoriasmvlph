<script lang="ts">
	import { get } from 'svelte/store';
	import { _, json, locale } from 'svelte-i18n';
	import { Badge } from '$lib/components/ui/badge';
	import { Check, Clock, ArrowUpRight } from '@lucide/svelte';

	type Bullet = string;

	interface PackageData {
		key: 'mini' | 'moment' | 'atmosphere';
		name: string;
		price: string;
		bullets: Bullet[];
		delivery: string;
	}

	function stringOf(key: string): string {
		const value = $_(key);
		return typeof value === 'string' ? value : '';
	}

	function bulletsOf(key: string): Bullet[] {
		const lookup = get(json);
		const value = lookup(key);
		return Array.isArray(value) ? (value as Bullet[]) : [];
	}

	const packages = $derived.by<Record<'mini' | 'moment' | 'atmosphere', PackageData>>(() => {
		// Reading $locale explicitly makes the derived re-run on language change.
		void $locale;
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

	const order: ReadonlyArray<'mini' | 'moment' | 'atmosphere'> = [
		'mini',
		'moment',
		'atmosphere'
	];

	function scrollToContact(event: MouseEvent) {
		event.preventDefault();
		document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
	}
</script>

<section
	id="services"
	class="bg-brand-cream border-hairline border-b"
	aria-label={$_('a11y.section_services')}
>
	<div class="mx-auto max-w-6xl px-4 py-16 sm:px-6 sm:py-20 lg:py-28">
		<div class="flex flex-col items-start gap-3">
			<span
				class="border-hairline text-brand-ink bg-brand-cream w-fit border px-3 py-1 font-mono text-[10px] tracking-[0.4em] uppercase"
				aria-hidden="true"
			>
				— 02 / {$_('services.title')}
			</span>
			<h2
				class="text-brand-ink font-display text-3xl leading-[0.95] font-semibold tracking-tight sm:text-5xl"
			>
				{$_('services.title')}
			</h2>
		</div>

		<div class="mt-12 grid gap-6 md:grid-cols-2 lg:grid-cols-3 lg:gap-8">
			{#each order as key (key)}
				{@const pkg = packages[key]}
				{@const isFeatured = key === 'moment'}
				<article
					class="bg-brand-cream border-hairline flex h-full flex-col border p-6 transition-colors hover:border-brand-ink sm:p-8"
				>
					<div class="flex items-start justify-between gap-3">
						<span class="text-brand-ink/60 font-mono text-xs tracking-[0.2em] uppercase">
							0{order.indexOf(key) + 1}
						</span>
						{#if isFeatured}
							<Badge
								class="bg-brand-orange text-brand-ink rounded-none px-2 py-0.5 text-[10px] font-semibold tracking-[0.18em] uppercase"
							>
								{$_('packages.moment.featured')}
							</Badge>
						{/if}
					</div>
					<h3 class="text-brand-ink mt-6 font-display text-3xl font-semibold tracking-tight">
						{pkg.name}
					</h3>
					<div
						class="text-brand-ink mt-4 font-mono text-3xl font-semibold tracking-tight"
					>
						{pkg.price}
					</div>
					<ul class="text-brand-ink/80 mt-6 flex flex-1 flex-col gap-3 text-sm leading-relaxed">
						{#each pkg.bullets as bullet (bullet)}
							<li class="flex items-start gap-2">
								<Check class="text-brand-orange mt-0.5 size-4 shrink-0" />
								<span>{bullet}</span>
							</li>
						{/each}
					</ul>
					<div
						class="text-brand-ink/60 mt-6 flex items-center gap-2 border-hairline border-t pt-4 text-xs tracking-[0.1em] uppercase"
					>
						<Clock class="size-3.5" />
						{pkg.delivery}
					</div>
					<button
						type="button"
						onclick={scrollToContact}
						class="text-brand-ink hover:text-brand-orange mt-6 inline-flex min-h-6 items-center gap-1.5 px-2 text-xs font-semibold tracking-[0.18em] uppercase transition-colors"
					>
						{$_('services.book_cta')}
						<ArrowUpRight class="size-3.5" />
					</button>
				</article>
			{/each}
		</div>
	</div>
</section>
