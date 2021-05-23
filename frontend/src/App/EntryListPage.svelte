<script>
  import { onMount } from "svelte";
  import Entries from "../Api/Entries.js";
  import Persons from "../Api/Persons.js";

  const entries = Entries.agent();
  const persons = Persons.agent();

  let lastSelectedPersonId = null;
  let selectedPersonId = null;

  $: if (lastSelectedPersonId != selectedPersonId) {
    if (selectedPersonId) {
      $entries.list({ person_id: selectedPersonId });
    }
    lastSelectedPersonId = selectedPersonId;
  }

  $: balances = $entries.items.reduce(
    (acc, entry) => [
      ...acc,
      (acc.slice(-1)[0] || 0) +
        (entry.side == "debit" ? 1 : -1) * entry.ammount,
    ],
    []
  );

  onMount(() => {
    $persons.list();
  });
</script>

<div class="mt-8 mx-16">
  <select class="control" bind:value="{selectedPersonId}">
    <option value="{null}"></option>
    {#each $persons.items as person (person.id)}
      <option value="{person.id}">{person.name}</option>
    {/each}
  </select>
  <div class="page-title mt-2">Entries</div>
  {#if selectedPersonId && 0 < $entries.items.length}
    <div class="text-right my-2">Count: {$entries.items.length}</div>
    <ul class="item-list">
      <li class="flex justify-between">
        <div class="w-full text-center">Date</div>
        <div class="w-full text-center">Subject</div>
        <div class="w-full text-center">Increase</div>
        <div class="w-full text-center">Decrease</div>
        <div class="w-full text-center">Balance</div>
      </li>
      {#each $entries.items as entry, i (entry.id)}
        <li class="flex justify-between">
          <div class="w-full">{entry.made_on}</div>
          <div class="w-full">{entry.subject}</div>
          <div class="w-full text-right">
            {entry.side == "debit" ? entry.ammount : ""}
          </div>
          <div class="w-full text-right">
            {entry.side == "credit" ? entry.ammount : ""}
          </div>
          <div class="w-full text-right">{balances[i]}</div>
        </li>
      {/each}
    </ul>
  {:else}
    <div class="message">No entry</div>
  {/if}
</div>
