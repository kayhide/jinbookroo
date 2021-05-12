<script>
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import Fa from "svelte-fa";
  import { faTrash } from "@fortawesome/free-solid-svg-icons";
  import Persons from "../Api/Persons.js";

  export let deal;
  export let toName;
  export let selected = false;
  export let onDelete = (_) => {};
  const dispatch = createEventDispatcher();

  $: debits = deal.entries.filter(({ side }) => side === "debit");
  $: credits = deal.entries.filter(({ side }) => side === "credit");
</script>

<style>
  .entry-control {
    @apply w-full flex justify-items-stretch;
    @apply border border-gray-400 rounded overflow-hidden;
    @apply divide-x divide-gray-400;
  }
</style>

<div class="w-full space-y-1 group">
  <div class="p-1 flex justify-between">
    <input
      class="control border border-transparent"
      type="date"
      disabled
      bind:value="{deal.made_on}"
      placeholder="Made on"
    />
    <div
      class="flex space-x-2 opacity-0 group-hover:opacity-100 transition duration-300"
    >
      <button
        class="control blue border rounded"
        on:click="{(_) => dispatch('edit')}">Edit</button
      >
      <button
        class="control red border rounded"
        on:click="{(_) => dispatch('delete')}">Delete</button
      >
    </div>
  </div>

  <div class="w-full p-1 grid grid-cols-2 gap-x-2 gap-y-1">
    {#each Array(Math.max(debits.length, credits.length)) as _, i}
      {#each [debits[i], credits[i]] as entry}
        {#if entry}
          <div class="entry-control {entry.side}">
            <div class="w-full control">{entry.subject}</div>
            <div class="w-full control">{toName(entry.person_id) || ""}</div>
            <div class="w-full control text-right">{entry.ammount}</div>
          </div>
        {:else}
          <div></div>
        {/if}
      {/each}
    {/each}
  </div>
</div>
