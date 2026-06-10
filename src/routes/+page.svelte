<script lang="ts">
	import SiteHeader from '$lib/components/sections/SiteHeader.svelte';
	import Hero from '$lib/components/sections/Hero.svelte';
	import Marquee from '$lib/components/sections/Marquee.svelte';
	import IntroBlock from '$lib/components/sections/IntroBlock.svelte';
	import ServicesCards from '$lib/components/sections/ServicesCards.svelte';
	import About from '$lib/components/sections/About.svelte';
	import BooksBlock from '$lib/components/sections/BooksBlock.svelte';
	import ContactBlock from '$lib/components/sections/ContactBlock.svelte';
	import InstagramGrid from '$lib/components/sections/InstagramGrid.svelte';
	import SiteFooter from '$lib/components/sections/SiteFooter.svelte';
</script>

<SiteHeader />
<main>
	<Hero />
	<Marquee />
	<IntroBlock />
	<ServicesCards />
	<About />
	<BooksBlock />
	<ContactBlock />
	<InstagramGrid />
</main>
<SiteFooter />
