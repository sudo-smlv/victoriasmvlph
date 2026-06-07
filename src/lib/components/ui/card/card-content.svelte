<script lang="ts">
	import { cn } from '$lib/utils';
	import type { WithElementRef } from 'bits-ui';
	import type { HTMLAttributes } from 'svelte/elements';

	let {
		class: className,
		ref = $bindable(null),
		children,
		...restProps
	}: WithElementRef<HTMLAttributes<HTMLElement>> & { ref?: HTMLElement | null } = $props();
</script>

<div
	bind:this={ref}
	data-slot="card-content"
	class={cn('p-6 pt-0', className)}
	{...restProps}
>
	{@render children?.()}
</div>
