<script lang="ts">
	import '../app.css';
	import { setupI18n } from '$lib/i18n';

	setupI18n();

	let { children } = $props();
</script>

<div class="bg-background text-foreground flex min-h-full flex-col font-body">
	{@render children?.()}
</div>
