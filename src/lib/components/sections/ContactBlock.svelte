<script lang="ts">
	import { _ } from 'svelte-i18n';
	import * as Card from '$lib/components/ui/card';
	import { Button } from '$lib/components/ui/button';
	import { Camera, Send, ArrowUpRight } from '@lucide/svelte';

	const INSTAGRAM_URL = 'https://instagram.com/victoriasmvlph';
	const TELEGRAM_URL = 'https://t.me/victoriasmvlph';
</script>

<section
	id="contact"
	class="bg-brand-ink text-brand-cream border-hairline border-b scroll-mt-20"
	aria-label={$_('a11y.section_contact')}
>
	<div class="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
		<Card.Root
			class="bg-brand-ink text-brand-cream rounded-none border-0 p-0 shadow-none"
		>
			<Card.Header class="gap-4">
				<!-- AC1 fix-forward (CLAAAAA-124/178): decorative eyebrow Badge removed; the Card.Title is the only visible section title. -->
				<Card.Title
					class="text-brand-cream font-display text-[clamp(2.5rem,7vw,5rem)] leading-[1] font-semibold tracking-tight"
				>
					{$_('contact.title')}
				</Card.Title>
				<Card.Description class="text-brand-cream/70 max-w-2xl text-base sm:text-lg">
					{$_('contact.body')}
				</Card.Description>
			</Card.Header>
			<Card.Content class="mt-8 flex flex-col gap-3 sm:flex-row">
				<Button
					href={INSTAGRAM_URL}
					target="_blank"
					rel="noopener noreferrer"
					size="lg"
					class="bg-brand-cream text-brand-ink hover:bg-brand-yellow min-h-6 flex-1 gap-2 rounded-none px-6 py-2 text-xs font-semibold tracking-[0.18em] uppercase"
				>
					<Camera class="size-4" />
					{$_('contact.instagram_label')}
					<ArrowUpRight class="ml-1 size-4" />
				</Button>
				<Button
					href={TELEGRAM_URL}
					target="_blank"
					rel="noopener noreferrer"
					size="lg"
					variant="outline"
					class="border-brand-cream text-brand-cream hover:bg-brand-cream min-h-6 rounded-none px-6 py-2 text-xs font-semibold tracking-[0.18em] uppercase hover:text-brand-ink flex-1 gap-2"
				>
					<Send class="size-4" />
					{$_('contact.telegram_label')}
					<ArrowUpRight class="ml-1 size-4" />
				</Button>
			</Card.Content>
		</Card.Root>
	</div>
</section>
