<script>
  import { onMount } from "svelte";
  import { slide } from "svelte/transition";
  import Fa from "svelte-fa";
  import { faTrash } from "@fortawesome/free-solid-svg-icons";
  import DealForm from "./DealForm.svelte";
  import DealItem from "./DealItem.svelte";
  import Deals from "../Api/Deals.js";
  import Persons from "../Api/Persons.js";

  const deals = Deals.agent();
  const personsAgent = Persons.agent();
  let selectedId = null;
  let editing = null;

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

  let nextKey = Date.now();
  let wasCreating = false;
  $: if (wasCreating != $deals.isCreating) {
    wasCreating = $deals.isCreating;
    if (!$deals.isCreating) {
      nextKey = Date.now();
    }
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

<div class="my-8 mx-16">
  <div class="page-title">Deals</div>
  <div class="text-right my-2">Count: {$deals.items.length}</div>
  <div class="space-y-2">
    {#each $deals.items as deal (deal.id)}
      <div class="card" transition:slide="{{ duration: 200 }}">
        {#if selectedId === deal.id}
          <DealForm
            attrs="{deal}"
            on:submit="{handleUpdate(deal.id)}"
            on:cancel="{handleSelect(null)}"
          />
        {:else}
          <DealItem
            deal="{deal}"
            toName="{toName}"
            on:edit="{handleSelect(deal.id)}"
            on:delete="{handleDelete(deal.id)}"
          />
        {/if}
      </div>
    {/each}
    {#if !selectedId}
      {#key nextKey}
        <div class="card" transition:slide="{{ duration: 200 }}">
          <DealForm attrs="{null}" on:submit="{handleCreate}" />
        </div>
      {/key}
    {/if}
  </div>
</div>
