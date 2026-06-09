<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { Dialog } from 'bits-ui';
	import { Menu, X, ArrowUpRight } from '@lucide/svelte';
	import { Button } from '$lib/components/ui/button';
	import { Separator } from '$lib/components/ui/separator';
	import LanguageSwitcher from '$lib/components/LanguageSwitcher.svelte';

	type NavLink = { key: string; href: string };

	type Props = {
		navLinks: ReadonlyArray<NavLink>;
		onBookClick: (event: MouseEvent) => void;
	};

	let { navLinks, onBookClick }: Props = $props();

	let open = $state(false);

	function closeAndNavigate(href: string) {
		return (event: MouseEvent) => {
			event.preventDefault();
			open = false;
			window.setTimeout(() => {
				const target = document.querySelector(href);
				if (target instanceof HTMLElement) {
					target.scrollIntoView({ behavior: 'smooth', block: 'start' });
				}
			}, 320);
		};
	}

	function handleBookClick(event: MouseEvent) {
		open = false;
		window.setTimeout(() => onBookClick(event), 320);
	}
</script>

<Dialog.Root bind:open>
	<Dialog.Trigger
		class="text-brand-ink hover:text-brand-orange inline-flex h-9 w-9 items-center justify-center transition-colors duration-300 ease-out focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:outline-hidden lg:hidden"
		aria-label="Open menu"
	>
		<Menu class="size-5" />
	</Dialog.Trigger>

	<Dialog.Portal>
		<Dialog.Overlay
			class="data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 fixed inset-0 z-50 bg-brand-ink/40 backdrop-blur-sm"
		/>
		<Dialog.Content
			class="data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right fixed inset-y-0 right-0 z-50 flex h-full w-full max-w-xs flex-col gap-6 border-l border-hairline bg-brand-cream p-6 shadow-xl duration-300 sm:max-w-sm"
		>
			<div class="flex items-center justify-between">
				<span class="text-brand-orange font-display text-lg leading-none" aria-hidden="true">✺</span>
				<Dialog.Title class="sr-only">{$_('common.appName')}</Dialog.Title>
				<Dialog.Description class="sr-only">
					{$_('common.nav.about')} {$_('common.nav.services')} {$_('common.nav.books')} {$_('common.nav.contact')}
				</Dialog.Description>
				<Dialog.Close
					class="text-brand-ink hover:text-brand-orange inline-flex h-9 w-9 items-center justify-center transition-colors duration-300 ease-out focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:outline-hidden"
					aria-label="Close menu"
				>
					<X class="size-5" />
				</Dialog.Close>
			</div>

			<Separator class="bg-hairline" />

			<nav aria-label="Mobile primary" class="flex flex-col gap-1">
				{#each navLinks as link (link.href)}
					<a
						href={link.href}
						onclick={closeAndNavigate(link.href)}
						class="text-brand-ink hover:bg-brand-yellow/30 hover:text-brand-orange rounded-none px-2 py-3 text-left text-sm font-semibold tracking-[0.18em] uppercase transition-colors duration-300 ease-out"
					>
						{$_(link.key)}
					</a>
				{/each}
			</nav>

			<Separator class="bg-hairline" />

			<div class="flex flex-col gap-4">
				<div class="flex items-center justify-between">
					<span class="text-brand-ink/60 text-xs font-semibold tracking-[0.18em] uppercase">
						{$_('common.language')}
					</span>
					<LanguageSwitcher />
				</div>
				<Button
					size="default"
					onclick={handleBookClick}
					class="bg-brand-ink text-brand-cream hover:bg-brand-charcoal w-full justify-between gap-1.5 rounded-none px-4 text-xs font-semibold tracking-[0.18em] uppercase"
				>
					{$_('hero.cta_primary')}
					<ArrowUpRight class="size-4" />
				</Button>
			</div>
		</Dialog.Content>
	</Dialog.Portal>
</Dialog.Root>
