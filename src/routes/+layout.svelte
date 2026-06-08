<script lang="ts">
	import '../app.css';
	import { _ } from 'svelte-i18n';
	import { setupI18n } from '$lib/i18n';
	import { Button } from '$lib/components/ui/button';
	import { Separator } from '$lib/components/ui/separator';
	import LanguageSwitcher from '$lib/components/LanguageSwitcher.svelte';

	setupI18n();

	let { children } = $props();
</script>

<div class="bg-background text-foreground flex min-h-full flex-col">
	<header
		class="border-border/60 bg-background/80 supports-[backdrop-filter]:bg-background/60 sticky top-0 z-40 flex items-center justify-between border-b px-4 py-3 backdrop-blur sm:px-6"
	>
		<a href="/" class="text-lg font-semibold tracking-tight">
			{$_('common.appName')}
		</a>
		<div class="flex items-center gap-3">
			<span class="text-muted-foreground hidden text-sm sm:inline">{$_('common.tagline')}</span>
			<LanguageSwitcher />
		</div>
	</header>

	<main class="flex-1">
		{@render children?.()}
	</main>

	<footer class="border-border/60 border-t">
		<div
			class="text-muted-foreground mx-auto flex max-w-5xl flex-col items-center justify-between gap-3 px-4 py-6 text-xs sm:flex-row sm:px-6"
		>
			<span>© {new Date().getFullYear()} {$_('common.appName')}</span>
			<div class="flex items-center gap-3">
				<Separator orientation="vertical" class="h-4" />
				<LanguageSwitcher />
			</div>
		</div>
	</footer>
</div>
