<script>
  import { Route, Router, Link } from "svelte-routing";
  import TailwindStyles from "./TailwindStyles.svelte";
  import LoginPage from "./App/LoginPage.svelte";
  import UserList from "./App/UserList.svelte";
  import { Store } from "./App/Store.js";

  export let url = location.pathname;

  history.pushState = new Proxy(history.pushState, {
    apply(target, arg, args) {
      url = args[2];
      Reflect.apply(target, arg, args);
    },
  });

  let token = Store.accessToken;
  function handleLogin(e) {
    token.set(e.detail.token);
  }
</script>

<div class="m-2">
  {url}
</div>
<div class="m-2">
  {$token}
</div>
<Router url="{url}">
  <nav>
    <Link to="/">Users</Link>
    <Link to="/users">Users</Link>
    <Link to="/login">Login</Link>
  </nav>
  <div>
    <Route path="/login"><LoginPage on:login="{handleLogin}" /></Route>
    <Route path="/"><UserList /></Route>
    <Route path="/users"><UserList /></Route>
  </div>
</Router>
