<script>
  import { onMount } from "svelte";
  import Fa from "svelte-fa";
  import { faTrash } from "@fortawesome/free-solid-svg-icons";
  import DealForm from "./DealForm.svelte";
  import DealItem from "./DealItem.svelte";
  import Deals from "../Api/Deals.js";
  import Persons from "../Api/Persons.js";

  const deals = Deals.agent();
  const personsAgent = Persons.agent();
  let selectedId = null;

  const handleCreate = (e) => {
    $deals.create(e.detail);
    selectedId = null;
  };
  const handleUpdate = (id) => (e) => {
    $deals.update(id, e.detail);
    selectedId = null;
  };
  const handleDelete = (id) => (e) => {
    $deals.destroy(id);
    selectedId = null;
  };
  const handleSelect = (id) => (_) => {
    selectedId = id;
  };

  $: toName = (person_id) => {
    if (person_id) {
      const person = $personsAgent.lookup(person_id);
      return person ? person.name : null;
    }
    return null;
  };

  $: person_ids = [
    ...new Set(
      $deals.items.flatMap(({ entries }) =>
        entries.map(({ person_id }) => person_id).filter((x) => x)
      )
    ),
  ];
  $: {
    person_ids.forEach($personsAgent.fetch);
  }

  onMount(() => {
    $deals.list();
  });
</script>

<style>
  .card {
    @apply w-full block bg-gray-100 rounded-lg;
    @apply flex px-4 py-2 border border-gray-200;
    @apply focus-within:shadow transition duration-300;
  }
</style>

<div class="mt-8 mx-16">
  <div class="page-title">Deals</div>
  <div class="text-right my-2">Count: {$deals.items.length}</div>
  <div class="space-y-2">
    {#each $deals.items as deal (deal.id)}
      {#if selectedId === deal.id}
        <div class="card">
          <DealForm attrs="{deal}" on:submit="{handleUpdate(deal.id)}" />
        </div>
      {:else}
        <div class="card">
          <DealItem
            deal="{deal}"
            toName="{toName}"
            on:edit="{handleSelect(deal.id)}"
            on:delete="{handleDelete(deal.id)}"
          />
        </div>
      {/if}
    {/each}
    <div class="card">
      <DealForm attrs="{null}" on:submit="{handleCreate}" />
    </div>
  </div>
</div>
