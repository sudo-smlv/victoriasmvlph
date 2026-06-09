<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { Separator } from '$lib/components/ui/separator';
	import { Camera, ArrowUpRight } from '@lucide/svelte';

	const studio = [
		{ labelKey: 'common.nav.about', href: '#about' },
		{ labelKey: 'common.nav.services', href: '#services' },
		{ labelKey: 'common.nav.books', href: '#books' },
		{ labelKey: 'common.nav.contact', href: '#contact' }
	];

	const social = [
		{ labelKey: 'footer.instagram', href: 'https://instagram.com/victoriasmvlph' },
		{ labelKey: 'footer.telegram', href: 'https://t.me/victoriasmvlph' }
	];
</script>

<footer class="bg-brand-ink text-brand-cream" 	aria-label={$_('a11y.site_footer')}>
	<Separator class="bg-brand-cream/15" />
	<div
		class="mx-auto grid max-w-6xl gap-10 px-4 py-16 sm:px-6 sm:py-20 lg:grid-cols-12 lg:gap-12"
	>
		<div class="lg:col-span-5">
			<div class="flex items-center gap-2">
				<span class="text-brand-orange font-display text-2xl" aria-hidden="true">✺</span>
				<span class="font-display text-2xl font-semibold tracking-tight uppercase">
					{$_('common.appName')}
				</span>
			</div>
			<p class="text-brand-cream/70 mt-4 max-w-md text-sm leading-relaxed">
				{$_('hero.subheadline')}
			</p>
			<div
				class="border-hairline mt-6 aspect-[4/3] w-32 overflow-hidden border bg-brand-charcoal"
				aria-hidden="true"
			>
				<div class="text-brand-cream/30 flex h-full w-full items-center justify-center">
					<Camera class="size-8" />
				</div>
			</div>
		</div>

		<div class="grid grid-cols-2 gap-8 lg:col-span-4">
			<div class="flex flex-col gap-3">
				<span class="text-brand-cream/50 font-mono text-[10px] tracking-[0.2em] uppercase">
					— {$_('common.nav.services')}
				</span>
				{#each studio as link (link.href)}
					<a
						href={link.href}
						class="text-brand-cream hover:text-brand-orange text-sm transition-colors"
					>
						{$_(link.labelKey)}
					</a>
				{/each}
			</div>
			<div class="flex flex-col gap-3">
				<span class="text-brand-cream/50 font-mono text-[10px] tracking-[0.2em] uppercase">
					{$_('footer.social_heading')}
				</span>
				{#each social as link (link.href)}
					<a
						href={link.href}
						target="_blank"
						rel="noopener noreferrer"
						class="text-brand-cream hover:text-brand-orange inline-flex items-center gap-1 text-sm transition-colors"
					>
						{$_(link.labelKey)}
						<ArrowUpRight class="size-3.5" />
					</a>
				{/each}
			</div>
		</div>

		<div class="flex flex-col gap-3 lg:col-span-3 lg:items-end">
			<span class="text-brand-cream/50 font-mono text-[10px] tracking-[0.2em] uppercase">
				— {$_('common.nav.contact')}
			</span>
			<p class="text-brand-cream/70 text-sm">
				{$_('contact.body')}
			</p>
			<a
				href="#contact"
				class="text-brand-orange inline-flex items-center gap-1.5 text-xs font-semibold tracking-[0.18em] uppercase"
			>
				{$_('hero.cta_primary')}
				<ArrowUpRight class="size-3.5" />
			</a>
		</div>
	</div>

	<div class="border-brand-cream/15 border-t">
		<div
			class="text-brand-cream/60 mx-auto flex max-w-6xl flex-col items-start justify-between gap-2 px-4 py-6 text-xs sm:flex-row sm:items-center sm:px-6"
		>
			<span>{$_('common.footer.copyright')}</span>
			<span class="font-mono tracking-[0.2em] uppercase">№ 2026 / 01</span>
		</div>
	</div>
</footer>
