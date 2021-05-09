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
    @apply bg-green-200;
  }
  .credit {
    @apply bg-red-200;
  }
  .entry-control {
    @apply w-full p-1 flex justify-items-stretch condensed;
  }
  .condensed {
    .control {
      @apply ring-inset;
    }
  }
</style>

<form class="mt-4 w-full" on:submit="{handleSubmit}">
  <div class="mb-2 flex justify-between">
    <input
      class="control gray"
      type="date"
      bind:value="{made_on}"
      placeholder="Made on"
    />
    {#if attrs && attrs.id}
      <button class="control blue" type="submit">Update</button>
    {:else}
      <button class="control blue" type="submit">Create</button>
    {/if}
  </div>

  <div class="w-full grid grid-cols-2">
    {#each Array(Math.max(debits.length, credits.length)) as _, i}
      {#each [debits[i], credits[i]] as entry}
        {#if entry}
          <div class="entry-control {entry.side}">
            <input
              class="w-full control gray"
              placeholder="Subject"
              bind:value="{entry.subject}"
            />
            <select class="w-full control gray" bind:value="{entry.person_id}">
              <option value=""></option>
              {#each $personsAgent.items as person (person.id)}
                <option value="{person.id}">{person.name}</option>
              {/each}
            </select>
            <input
              class="w-full control gray text-right"
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
