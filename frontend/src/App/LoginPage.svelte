<script>
  import { createEventDispatcher } from "svelte";
  import * as Auth from "../Api/Auth.js";
  import { Store } from "./Store.js";

  let email = "";
  let password = "";

  const auth = Auth.item();

  const handleLogin = (event) => {
    event.preventDefault();
    event.stopPropagation();
    auth.login({ email, password });
  };

  $: if ($auth.token != Store.$accessToken) {
    Store.accessToken.set($auth.token);
  }
</script>

<style>
</style>

<div class="panel">
  <div class="panel-header blue">Login</div>
  <form class="form" on:submit="{handleLogin}">
    <input
      class="control gray"
      type="email"
      autofocus
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
