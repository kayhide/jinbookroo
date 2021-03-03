<script>
  import axios from "axios";
  import TailwindStyles from "./TailwindStyles.svelte";
  import { onMount } from "svelte";

  const message = "Learn Svelte";

  let name = "";
  let email = "";
  let users = [];

  function loadUsers() {
    axios.get("http://localhost:3000/api/users").then((res) => {
      users = res.data;
    });
  }

  function handleCreateUser(event) {
    event.preventDefault();
    event.stopPropagation();
    axios
      .post("http://localhost:3000/api/users", { name, email })
      .then((res) => {
        console.log(res.data);
        loadUsers();
      });
  }

  onMount(() => {
    loadUsers();
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
</style>

<div class="m-16 font-sanserif">
  <div class="text-lg">Users</div>
  <form class="my-4" on:submit="{handleCreateUser}">
    <input class="control gray" bind:value="{name}" placeholder="Name" />
    <input class="control gray" bind:value="{email}" placeholder="Email" />
    <button class="control blue" type="submit"> Create </button>
  </form>
  <div class="text-right">Count: {users.length}</div>
  <ul class="my-2 py-2 bg-gray-100 rounded-lg">
    {#each users as user}
      <li class="w-h flex px-4 py-2 border-b border-gray-400">
        <div class="w-1/2">{user.name}</div>
        <div class="w-1/2">{user.email}</div>
      </li>
    {/each}
  </ul>
</div>
