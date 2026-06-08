<script lang="ts">
	import { _ } from 'svelte-i18n';
	import * as Card from '$lib/components/ui/card';
	import { Separator } from '$lib/components/ui/separator';
	import { BookOpen, ArrowUpRight } from '@lucide/svelte';

	function stringOf(key: string): string {
		const value = $_(key);
		return typeof value === 'string' ? value : '';
	}

	function paragraphsOf(key: string): string[] {
		return stringOf(key)
			.split(/\n\n+/)
			.map((p) => p.trim())
			.filter(Boolean);
	}
</script>

<section id="books" class="bg-brand-cream border-hairline border-b" aria-label="Photo books">
	<div class="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16 lg:py-24">
		<div class="grid gap-10 md:grid-cols-12 md:gap-12">
			<div class="flex flex-col gap-4 md:col-span-5">
				<span
					class="border-hairline text-brand-ink bg-brand-cream w-fit border px-3 py-1 font-mono text-[10px] tracking-[0.4em] uppercase"
				>
					— 04 / {$_('books.title')}
				</span>
				<h2
					class="text-brand-ink font-display text-[clamp(2rem,5vw,3.5rem)] leading-[1] font-semibold tracking-tight"
				>
					{$_('books.title')}
				</h2>
				<Card.Root class="bg-brand-ink text-brand-cream rounded-none border-0 p-0">
					<div
						class="flex aspect-[4/3] w-full items-center justify-center"
						aria-hidden="true"
					>
						<BookOpen class="size-12 sm:size-16" />
					</div>
				</Card.Root>
			</div>

			<div
				class="text-brand-ink/80 flex flex-col gap-5 text-base leading-relaxed md:col-span-7"
			>
				{#each paragraphsOf('books.body') as paragraph (paragraph)}
					<p>{paragraph}</p>
				{/each}
				<Separator class="bg-hairline mt-2" />
				<div class="flex items-center gap-2">
					<ArrowUpRight class="text-brand-orange size-4" />
					<span class="font-mono text-[10px] tracking-[0.3em] uppercase opacity-70">
						{$_('common.appName')}
					</span>
				</div>
			</div>
		</div>
	</div>
</section>
