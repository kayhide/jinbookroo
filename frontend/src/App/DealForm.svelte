<script>
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import * as Persons from "../Api/Persons.js";

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

  let made_on;
  let entries = [];
  $: entries.forEach((entry, i) => (entry.index = i));
  $: debits = entries.filter((entry) => entry.side === "debit");
  $: credits = entries.filter((entry) => entry.side === "credit");

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();
    const entries_ = entries.filter((entry) => entry.subject);
    if (0 < entries_.length) {
      dispatch("submit", { made_on, entries: entries_ });
    }
  };

  const withEntry = (event, f) => {
    const elm = event.target.closest("[data-entry-index]");
    const entry = elm ? entries[elm.dataset.entryIndex] || null : null;
    if (entry) {
      f(entry);
    }
  };

  const handleKeydown = (event) => {
    switch (event.key) {
      case "Enter":
        withEntry(event, (entry) => {
          entries = [...entries, newEntry(entry.side)];
          event.preventDefault();
        });
        break;
      case "Delete":
        if (event.shiftKey) {
          withEntry(event, (entry) => {
            entries = entries.filter((e) => e != entry);
            event.preventDefault();
          });
        }
        break;
    }
  };

  onMount(() => {
    const now = new Date();
    made_on = now.toISOString().substring(0, 10);
    entries = [newEntry("debit"), newEntry("credit")];
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
  .entry-form {
    @apply p-1;
  }
  .condensed {
    .control {
      @apply ring-inset;
    }
  }
</style>

<form class="mt-4 mb-2 flex justify-between" on:submit="{handleSubmit}">
  <input
    class="control gray"
    type="date"
    bind:value="{made_on}"
    placeholder="Made on"
  />
  <button class="control blue" type="submit"> Create </button>
</form>

<div class="w-full flex items-start">
  {#each [debits, credits] as entries, i}
    <div class="w-full {i === 0 ? 'debit' : 'credit'}">
      {#each entries as entry}
        <form
          class="entry-form condensed {entry.side}"
          data-entry-index="{entry.index}"
        >
          <div class="w-full flex justify-items-stretch">
            <input
              class="w-full control gray"
              placeholder="Subject"
              on:keydown="{handleKeydown}"
              bind:value="{entry.subject}"
            />
            <select
              class="w-full control gray"
              on:keydown="{handleKeydown}"
              bind:value="{entry.person_id}"
            >
              <option value=""></option>
              {#each $personsAgent.items as person (person.id)}
                <option value="{person.id}">{person.name}</option>
              {/each}
            </select>
            <input
              class="w-full control gray text-right"
              type="number"
              placeholder="Ammount"
              on:keydown="{handleKeydown}"
              bind:value="{entry.ammount}"
            />
          </div>
        </form>
      {/each}
    </div>
  {/each}
</div>
