<script>
  import { onMount } from "svelte";
  import Fa from "svelte-fa";
  import { faTrash } from "@fortawesome/free-solid-svg-icons";
  import Persons from "../Api/Persons.js";

  let name = "";
  const agent = Persons.agent();

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
  <div class="page-title">Persons</div>
  <form class="my-4" on:submit="{handleSubmit}">
    <input class="control gray" bind:value="{name}" placeholder="Name" />
    {#if selected}
      <button class="control blue" type="submit">Update</button>
    {:else}
      <button class="control blue" type="submit">Create</button>
    {/if}
  </form>
  {#if 0 < $agent.items.length}
    <div class="text-right my-2">Count: {$agent.items.length}</div>
    <ul class="item-list">
      {#each $agent.items as person (person.id)}
        <li on:click="{handleSelect(person)}">
          <div class="flex-grow">{person.name}</div>
          <button
            class="button danger p-2"
            on:click="{$agent.destroy(person.id)}"
            ><Fa icon="{faTrash}" /></button
          >
        </li>
      {/each}
    </ul>
  {:else}
    <div class="message">No person</div>
  {/if}
</div>
