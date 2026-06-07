<script lang="ts">
	import { DropdownMenu as DropdownMenuPrimitive } from 'bits-ui';
	import { cn } from '$lib/utils';
	import type { Snippet } from 'svelte';

	type Props = DropdownMenuPrimitive.TriggerProps & {
		class?: string;
		children?: Snippet;
	};

	let {
		ref = $bindable(null),
		class: className,
		children,
		...restProps
	}: Props = $props();
</script>

<DropdownMenuPrimitive.Trigger
	bind:ref
	class={cn(
		'ring-offset-background focus-visible:ring-ring data-[state=open]:bg-accent data-[state=open]:text-accent-foreground inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium transition-colors focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:outline-hidden disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0',
		className
	)}
	{...restProps}
>
	{@render children?.()}
</DropdownMenuPrimitive.Trigger>
