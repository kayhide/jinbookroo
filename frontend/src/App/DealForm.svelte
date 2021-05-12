<script>
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import Persons from "../Api/Persons.js";

  export let attrs = null;
  let attrs_ = {};
  const dispatch = createEventDispatcher();
  const personsAgent = Persons.agent();

  const newEntry = (side) => {
    return {
      side,
      subject: "",
      person_id: "",
      description: "",
      ammount: 0,
    };
  };

  const isEmpty = ({ subject }) => !subject;

  let made_on;
  let debits = [];
  let credits = [];

  $: if (attrs_ != attrs) {
    attrs_ = attrs;
    if (attrs) {
      made_on = attrs.made_on;
      const entries = attrs.entries.map((entry) =>
        Object.assign({}, entry, { person_id: entry.person_id || "" })
      );
      debits = entries.filter(({ side }) => side === "debit");
      credits = entries.filter(({ side }) => side === "credit");
    } else {
      made_on = new Date().toISOString().substring(0, 10);
    }
  }
  $: if (!debits.slice(-1).find(isEmpty)) {
    debits = [...debits, newEntry("debit")];
  } else {
    while (2 <= debits.length && debits.slice(-2).every(isEmpty)) {
      debits = debits.slice(0, -1);
    }
  }
  $: if (!credits.slice(-1).find(isEmpty)) {
    credits = [...credits, newEntry("credit")];
  } else {
    while (2 <= credits.length && credits.slice(-2).every(isEmpty)) {
      credits = credits.slice(0, -1);
    }
  }

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();
    const entries = [...debits, ...credits].filter(({ subject }) => subject);
    if (0 < entries.length) {
      dispatch("submit", { made_on, entries });
    }
  };

  onMount(() => {
    $personsAgent.list();
  });
</script>

<style>
  .debit {
    @apply border-green-200 divide-green-200;
    .control {
      @apply focus:ring-green-300;
    }
  }
  .credit {
    @apply border-red-200 divide-red-200;
    .control {
      @apply focus:ring-red-300;
    }
  }
  .entry-control {
    @apply w-full flex justify-items-stretch;
    @apply divide-x border rounded overflow-hidden;

    .control {
      @apply ring-inset;
    }
  }
</style>

<form class="w-full space-y-1 group" on:submit="{handleSubmit}">
  <div class="p-1 flex justify-between">
    <input
      class="control gray border rounded"
      type="date"
      bind:value="{made_on}"
      placeholder="Made on"
    />
    <div
      class="flex space-x-2 opacity-0 group-hover:opacity-100 transition duration-300"
    >
      {#if attrs && attrs.id}
        <button class="control blue border rounded" type="submit">Update</button
        >
        <button
          class="control red border rounded"
          on:click="{(_) => dispatch('delete')}">Delete</button
        >
      {:else}
        <button class="control green border rounded" type="submit"
          >Create</button
        >
      {/if}
    </div>
  </div>

  <div class="w-full p-1 grid grid-cols-2 gap-x-2 gap-y-1">
    {#each Array(Math.max(debits.length, credits.length)) as _, i}
      {#each [debits[i], credits[i]] as entry}
        {#if entry}
          <div class="entry-control {entry.side}">
            <input
              class="w-full control"
              placeholder="Subject"
              bind:value="{entry.subject}"
            />
            <select
              class="w-full control bg-white"
              bind:value="{entry.person_id}"
            >
              <option value=""></option>
              {#each $personsAgent.items as person (person.id)}
                <option value="{person.id}">{person.name}</option>
              {/each}
            </select>
            <input
              class="w-full control text-right"
              type="number"
              placeholder="Ammount"
              bind:value="{entry.ammount}"
            />
          </div>
        {:else}
          <div></div>
        {/if}
      {/each}
    {/each}
  </div>
</form>
