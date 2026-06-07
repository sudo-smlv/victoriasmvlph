<script lang="ts">
	import { DropdownMenu as DropdownMenuPrimitive } from 'bits-ui';
	import { cn } from '$lib/utils';

	let {
		ref = $bindable(null),
		class: className,
		...restProps
	}: DropdownMenuPrimitive.GroupProps & { class?: string } = $props();
</script>

<DropdownMenuPrimitive.Group
	bind:ref
	class={cn(className)}
	{...restProps}
/>
