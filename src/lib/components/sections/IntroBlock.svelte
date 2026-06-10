<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { Play, Plus } from '@lucide/svelte';
</script>

<section
	class="bg-brand-ink text-brand-cream border-hairline relative border-b py-20 sm:py-28"
	aria-label={$_('a11y.section_intro')}
>
	<div
		class="mx-auto flex max-w-6xl flex-col items-center gap-10 px-4 text-center sm:px-6"
	>
		<h2
			class="text-brand-cream font-display text-[clamp(3.5rem,12vw,10rem)] leading-[0.9] font-semibold tracking-tight uppercase"
		>
			{$_('intro.tagline_lead')}
			<span class="text-brand-orange">{$_('common.appName')}</span>
		</h2>
		<p class="text-brand-cream/80 max-w-2xl text-base leading-relaxed sm:text-lg">
			{$_('common.tagline')}
		</p>
		<div class="flex items-center gap-6">
			<button
				type="button"
				aria-label={$_('intro.play_showreel_label')}
				class="bg-brand-orange text-brand-ink flex size-20 items-center justify-center rounded-full transition-transform hover:scale-105"
			>
				<Play class="size-7 fill-current" />
			</button>
			<span class="font-mono text-xs tracking-[0.2em] uppercase opacity-80">
				{$_('intro.showreel')}
			</span>
		</div>
	</div>

	<div
		class="text-brand-cream/30 absolute top-6 left-6 hidden sm:flex"
		aria-hidden="true"
	>
		<Plus class="size-5" />
	</div>
	<div
		class="text-brand-cream/30 absolute right-6 bottom-6 hidden sm:flex"
		aria-hidden="true"
	>
		<Plus class="size-5" />
	</div>
</section>
