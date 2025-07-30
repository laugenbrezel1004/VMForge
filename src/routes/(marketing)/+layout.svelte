<script lang="ts">
  import { WebsiteName } from "./../../config"
  import "../../app.css"

  interface Props {
    children?: import("svelte").Snippet
  }

  let { children }: Props = $props()
</script>

<!--<div class="navbar bg-base-100 container accent-blue-400 mx-auto">-->
<div class="navbar  container accent-blue-400 mx-auto">
  <div class="flex-1">
    <a class="btn btn-ghost normal-case text-xl" href="/">{WebsiteName}</a>
  </div>
  <div class="flex-none">
  </div>
</div>

<div class="">
  {@render children?.()}
</div>

<!-- Spacer grows so the footer can be at bottom on short pages -->
<div class="grow"></div>
<div class="">
  <div class="border-t max-w-[1000px] mx-auto"></div>
  <footer
    class="footer md:footer-horizontal p-10 gap-x-48 lg:gap-x-64 xl:gap-x-96 place-content-center text-base"
  >
    <nav>
      <span class="footer-title opacity-80">Explore</span>
      <a class="link link-hover mb-1" href="/">Overview</a>
      <a class="link link-hover my-1" href="/contact_us">Contact Us</a>
      <a
        class="link link-hover my-1"
        href="https://github.com/CriticalMoments/CMSaasStarter">Github</a
      >
    </nav>
    <aside>
      <span class="footer-title opacity-80">Sponsor</span>
      <a class="max-w-[260px]" href="https://getkiln.ai">
        <div class="font-bold text-3xl mb-1">Kiln AI</div>
        <div class="font-medium mb-3">Build High Quality AI Products</div>
        <div class="font-light">
          Use advanced AI tactics, and collaborate with your team. Free apps for
          Mac and Windows.
        </div>
        <div class="link text-sm font-bold mt-2">Learn More</div>
      </a>
    </aside>
  </footer>
</div>
