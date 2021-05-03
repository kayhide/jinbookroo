<script>
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  let made_on;
  let entries = [];

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();
    dispatch("submit", { made_on, entries });
  };

  onMount(() => {
    const now = new Date();
    made_on = now.toISOString().substring(0, 10);
  });
</script>

<style>
</style>

<form class="my-4" on:submit="{handleSubmit}">
  <input
    class="control gray"
    type="date"
    bind:value="{made_on}"
    placeholder="Made on"
  />
  <button class="control blue" type="submit"> Create </button>
</form>
