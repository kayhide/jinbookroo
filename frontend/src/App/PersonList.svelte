<script>
  import { onMount } from "svelte";
  import * as Persons from "../Api/Persons.js";

  let name = "";
  const agent = Persons.agent();
  const persons = agent.items;

  const handleCreatePerson = (event) => {
    event.preventDefault();
    event.stopPropagation();
    agent.create({ name });
  };

  onMount(() => {
    agent.list();
  });
</script>

<style>
</style>

<div class="mt-8 mx-16">
  <div class="page-title">Persons</div>
  <form class="my-4" on:submit="{handleCreatePerson}">
    <input class="control gray" bind:value="{name}" placeholder="Name" />
    <button class="control blue" type="submit"> Create </button>
  </form>
  {#if 0 < $persons.length}
    <div class="text-right my-2">Count: {$persons.length}</div>
    <ul class="item-list">
      {#each $persons as person}
        <li>
          <div class="w-1/2">{person.name}</div>
        </li>
      {/each}
    </ul>
  {:else}
    <div class="message">No person</div>
  {/if}
</div>
