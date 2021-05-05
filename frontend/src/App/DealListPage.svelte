<script>
  import { onMount } from "svelte";
  import Fa from "svelte-fa";
  import { faTrash } from "@fortawesome/free-solid-svg-icons";
  import DealForm from "./DealForm.svelte";
  import * as Deals from "../Api/Deals.js";
  import * as Persons from "../Api/Persons.js";

  const dealsAgent = Deals.agent();
  const deals = dealsAgent.items;
  const personsAgent = Persons.agent();

  const handleCreateDeal = (e) => {
    dealsAgent.create(e.detail);
  };

  $: toName = (person_id) => {
    if (person_id) {
      const person = $personsAgent.lookup(person_id)
      return person ? person.name : null;
    }
    return null;
  };

  $: person_ids = [
    ...new Set(
      $deals.flatMap(({ entries }) =>
        entries.map(({ person_id }) => person_id).filter((x) => x)
      )
    ),
  ];
  $: {
    person_ids.forEach($personsAgent.fetch);
  }

  onMount(() => {
    dealsAgent.list();
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
        <li class="flex flex-col">
          <div class="flex items-baseline">
            <div class="flex-grow">{deal.made_on}</div>
            <button
              class="button danger p-2"
              on:click="{dealsAgent.destroy(deal.id)}"
              ><Fa icon="{faTrash}" /></button
            >
          </div>
          {#each deal.entries as entry (entry.id)}
            <div
              class="flex {entry.side === 'debit'
                ? 'justify-start'
                : 'justify-end'}"
            >
              <div class="w-1/2 p-2 flex">
                <div class="flex-1">{entry.subject}</div>
                <div class="flex-1">{toName(entry.person_id) || ""}</div>
                <div class="flex-1 text-right">{entry.ammount}</div>
              </div>
            </div>
          {/each}
        </li>
      {/each}
    </ul>
  {:else}
    <div class="message">No deal</div>
  {/if}
</div>
