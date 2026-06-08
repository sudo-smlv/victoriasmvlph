<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { ArrowUpRight } from '@lucide/svelte';
	import { Button } from '$lib/components/ui/button';
	import { Separator } from '$lib/components/ui/separator';
	import LanguageSwitcher from '$lib/components/LanguageSwitcher.svelte';

	function scrollToContact(event: MouseEvent) {
		event.preventDefault();
		document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
	}

	const navLinks: ReadonlyArray<{ key: string; href: string }> = [
		{ key: 'common.nav.about', href: '#about' },
		{ key: 'common.nav.services', href: '#services' },
		{ key: 'common.nav.books', href: '#books' },
		{ key: 'common.nav.contact', href: '#contact' }
	];
</script>

<header
	class="border-hairline bg-brand-cream/90 supports-[backdrop-filter]:bg-brand-cream/60 sticky top-0 z-40 flex items-center justify-between border-b px-4 py-3 backdrop-blur sm:px-6"
>
	<a href="/" class="text-brand-ink flex items-center gap-2 font-semibold tracking-tight">
		<span class="text-brand-orange font-display text-lg leading-none" aria-hidden="true">✺</span>
		<span class="font-display text-lg uppercase">{$_('common.appName')}</span>
	</a>

	<nav aria-label="Primary" class="hidden items-center gap-6 lg:flex">
		{#each navLinks as link (link.href)}
			<a
				href={link.href}
				class="text-brand-ink hover:text-brand-orange text-xs font-semibold tracking-[0.18em] uppercase transition-colors"
			>
				{$_(link.key)}
			</a>
		{/each}
	</nav>

	<div class="flex items-center gap-3">
		<LanguageSwitcher />
		<Button
			size="sm"
			onclick={scrollToContact}
			class="bg-brand-ink text-brand-cream hover:bg-brand-charcoal gap-1.5 rounded-none px-4 text-xs font-semibold tracking-[0.18em] uppercase"
		>
			{$_('hero.cta_primary')}
			<ArrowUpRight class="size-3.5" />
		</Button>
	</div>
</header>

<Separator class="bg-hairline" />
