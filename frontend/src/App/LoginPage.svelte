<script>
  import { createEventDispatcher } from "svelte";
  import * as Auth from "../Api/Auth.js";

  const dispatch = createEventDispatcher();

  let email = "";
  let password = "";

  const auth = Auth.item();
  auth.subscribe(({ token }) => dispatch("login", { token }));

  function handleLogin(event) {
    event.preventDefault();
    event.stopPropagation();
    auth.login({ email, password });
  }
</script>

<style>
  .panel {
    @apply my-16 mx-auto w-1/4;
    @apply border border-blue-400 rounded overflow-hidden;
    @apply shadow-lg;
    .panel-header {
      @apply py-2 px-4 text-lg border-b;
    }
  }
  .form {
    @apply my-4 w-full p-4 flex flex-col space-y-4;
  }
  .control {
    @apply px-4 py-2 border rounded;
  }
  .gray {
    @apply text-gray-900 border-gray-400;
    &.control {
      @apply hover:bg-gray-100;
    }
  }
  .blue {
    @apply text-blue-900 border-blue-400;
    &.control {
      @apply hover:bg-blue-100;
    }
    &.panel-header {
      @apply bg-blue-100;
    }
  }
</style>

<div class="panel">
  <div class="panel-header blue">Login</div>
  <form class="form" on:submit="{handleLogin}">
    <input
      class="control gray"
      type="email"
      placeholder="Email"
      bind:value="{email}"
    />
    <input
      class="control gray"
      type="password"
      placeholder="Password"
      bind:value="{password}"
    />
    <button class="control blue" type="submit"> Login </button>
  </form>
</div>
