<script>
  import { onMount } from "svelte";
  import Entries from "../Api/Entries.js";

  let name = "";
  const agent = Entries.agent();

  let selected = null;

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();
    if (selected && selected.id) {
      $agent.update(selected.id, { name });
    } else {
      $agent.create({ name });
    }
  };

  const handleSelect = (person) => (_) => {
    selected = person;
    name = person.name;
  };

  onMount(() => {
    $agent.list();
  });
</script>

<style>
  .danger {
    @apply text-red-300 hover:text-red-500;
  }
</style>

<div class="mt-8 mx-16">
  <div class="page-title">Entries</div>
  {#if 0 < $agent.items.length}
    <div class="text-right my-2">Count: {$agent.items.length}</div>
    <ul class="item-list">
      <li class="flex justify-between">
        <div class="w-full text-center">Date</div>
        <div class="w-full text-center">Subject</div>
        <div class="w-full text-center">Increase</div>
        <div class="w-full text-center">Decrease</div>
        <div class="w-full text-center">Balance</div>
      </li>
      {#each $agent.items as entry (entry.id)}
        <li class="flex justify-between" on:click="{handleSelect(entry)}">
          <div class="w-full">{entry.made_on}</div>
          <div class="w-full">{entry.subject}</div>
          <div class="w-full text-right">
            {entry.side == "debit" ? entry.ammount : ""}
          </div>
          <div class="w-full text-right">
            {entry.side == "credit" ? entry.ammount : ""}
          </div>
          <div class="w-full text-right">{entry.ammount}</div>
        </li>
      {/each}
    </ul>
  {:else}
    <div class="message">No entry</div>
  {/if}
</div>
