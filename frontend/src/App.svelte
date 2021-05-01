<script>
  import { writable } from "svelte/store";
  import { Route, Router, Link, navigate } from "svelte-routing";
  import TailwindStyles from "./TailwindStyles.svelte";
  import LoginPage from "./App/LoginPage.svelte";
  import UserList from "./App/UserList.svelte";
  import PersonList from "./App/PersonList.svelte";
  import { Store } from "./App/Store.js";

  const route = writable(location.pathname);
  let token = Store.accessToken;

  const handleLogin = (e) => {
    token.set(e.detail.token);
  };

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
</script>

<Router url="{$route}">
  <nav class="p-4 flex space-x-2 items-baseline bg-gray-300">
    <div class="flex-grow text-gray-900 text-xl">
      <Link to="/">Jinbookroo</Link>
    </div>
    {#if $token}
      <Link to="/persons">Persons</Link>
      <Link to="/users">Users</Link>
      <Link to="/logout">Logout</Link>
    {:else}
      <Link to="/login">Login</Link>
    {/if}
  </nav>
  <div>
    {#if !$token}
      <Route path="/login"><LoginPage on:login="{handleLogin}" /></Route>
    {/if}
    {#if $token}
      <Route path="/"><UserList /></Route>
      <Route path="/users"><UserList /></Route>
      <Route path="/persons"><PersonList /></Route>
    {/if}
  </div>
</Router>
<div class="fixed bottom-0 text-gray-400">
  <div class="m-2">
    route: {$route}
  </div>
  <div class="m-2">
    token: {$token}
  </div>
</div>
