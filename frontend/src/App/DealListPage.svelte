<script>
  import { onMount } from "svelte";
  import Fa from "svelte-fa";
  import { faTrash } from "@fortawesome/free-solid-svg-icons";
  import DealForm from "./DealForm.svelte";
  import * as Deals from "../Api/Deals.js";

  const agent = Deals.agent();
  const deals = agent.items;

  const handleCreateDeal = (e) => {
    agent.create(e.detail);
  };

  onMount(() => {
    agent.list();
  });
</script>

<style>
  .danger {
    @apply text-red-300 hover:text-red-500;
  }
</style>

<div class="mt-8 mx-16">
  <div class="page-title">Deals</div>
  <DealForm on:submit="{handleCreateDeal}" />
  {#if 0 < $deals.length}
    <div class="text-right my-2">Count: {$deals.length}</div>
    <ul class="item-list">
      {#each $deals as deal (deal.id)}
        <li class="flex items-baseline">
          <div class="flex-grow">{deal.made_on}</div>
          <button class="button danger p-2" on:click="{agent.destroy(deal.id)}"
            ><Fa icon="{faTrash}" /></button
          >
        </li>
      {/each}
    </ul>
  {:else}
    <div class="message">No deal</div>
  {/if}
</div>
