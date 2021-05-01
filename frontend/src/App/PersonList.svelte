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
  .control {
    @apply px-4 py-2 border rounded;
  }
  .gray {
    @apply text-gray-900 border-gray-400 hover:bg-gray-100;
  }
  .blue {
    @apply text-blue-900 border-blue-400 hover:bg-blue-100;
  }
  .message {
    @apply mt-4 p-4 text-gray-700 bg-gray-100;
  }
</style>

<div class="m-16 font-sanserif">
  <div class="text-lg">Persons</div>
  <form class="my-4" on:submit="{handleCreatePerson}">
    <input class="control gray" bind:value="{name}" placeholder="Name" />
    <button class="control blue" type="submit"> Create </button>
  </form>
  {#if 0 < $persons.length}
    <div class="text-right">Count: {$persons.length}</div>
    <ul class="my-2 py-2 bg-gray-100 rounded-lg">
      {#each $persons as user}
        <li class="w-h flex px-4 py-2 border-b border-gray-400">
          <div class="w-1/2">{user.name}</div>
        </li>
      {/each}
    </ul>
  {:else}
    <div class="message">No person</div>
  {/if}
</div>
