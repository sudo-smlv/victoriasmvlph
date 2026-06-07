<script lang="ts">
	import { _ } from 'svelte-i18n';
	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card';
	import { Badge } from '$lib/components/ui/badge';
</script>

<section class="mx-auto flex max-w-3xl flex-col items-start gap-8 px-4 py-16 sm:px-6 sm:py-24">
	<Badge variant="secondary">{$_('common.tagline')}</Badge>

	<Card.Root class="w-full">
		<Card.Header>
			<Card.Title class="text-3xl sm:text-4xl">{$_('common.placeholderHeading')}</Card.Title>
			<Card.Description>{$_('common.placeholderBody')}</Card.Description>
		</Card.Header>
		<Card.Content class="flex flex-col gap-3">
			<p class="text-muted-foreground text-sm">
				{$_('common.selectLanguage')}: <span class="text-foreground">RU · EN · DE</span>
			</p>
		</Card.Content>
		<Card.Footer>
			<Button>{$_('common.placeholderCta')}</Button>
		</Card.Footer>
	</Card.Root>
</section>
