<script>
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  import { Route, Router, Link, navigate } from "svelte-routing";
  import Style from "./App/Style.svelte";
  import Auth from "./Api/Auth.js";
  import LoginPage from "./App/LoginPage.svelte";
  import UserListPage from "./App/UserListPage.svelte";
  import PersonListPage from "./App/PersonListPage.svelte";
  import EntryListPage from "./App/EntryListPage.svelte";
  import DealListPage from "./App/DealListPage.svelte";
  import Store from "./App/Store.js";

  const route = writable(location.pathname);
  let token = Store.accessToken;

  history.pushState = new Proxy(history.pushState, {
    apply(target, arg, args) {
      route.set(args[2]);
      Reflect.apply(target, arg, args);
    },
  });

  $: switch ($route) {
    case "/logout":
      token.set(null);
      setTimeout(() => navigate("/"));
      break;
    case "/login":
      if ($token) {
        setTimeout(() => navigate("/"));
      }
      break;
    default:
      if (!$token) {
        setTimeout(() => navigate("/login"));
      }
  }

  let auth = Auth();

  $: if ($auth.verified) {
    if ($auth.token) {
      console.log("token is valid");
    } else {
      console.log("token is invalid");
      token.set(null);
      setTimeout(() => navigate("/"));
    }
  }

  onMount(() => {
    auth.verify($token);
  });
</script>

<style>
  .header-nav {
    @apply flex items-baseline bg-gray-300;
  }

  .app-title {
    @apply text-gray-900 text-xl font-bold;
  }
</style>

<Router url="{$route}">
  <nav class="header-nav p-4 space-x-2">
    <div class="app-title flex-grow">
      <Link to="/">Jinbookroo</Link>
    </div>
    {#if $auth.verified}
      <Link to="/entries">Entries</Link>
      <Link to="/persons">Persons</Link>
      <Link to="/users">Users</Link>
      <Link to="/logout">Logout</Link>
    {:else}
      <Link to="/login">Login</Link>
    {/if}
  </nav>
  <div>
    {#if !$auth.verified}
      <Route path="/login"><LoginPage /></Route>
    {/if}
    {#if $auth.verified}
      <Route path="/"><DealListPage /></Route>
      <Route path="/entries"><EntryListPage /></Route>
      <Route path="/users"><UserListPage /></Route>
      <Route path="/persons"><PersonListPage /></Route>
    {/if}
  </div>
</Router>
<div class="fixed bottom-0 text-gray-400 select-none pointer-events-none">
  <div class="m-2">
    route: {$route}
  </div>
  <div class="m-2">
    token: {$token}
  </div>
</div>
