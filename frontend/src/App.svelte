<script>
  import { Route, Router, Link } from "svelte-routing";
  import TailwindStyles from "./TailwindStyles.svelte";
  import UserList from "./App/UserList.svelte";

  export let url = location.pathname;

  history.pushState = new Proxy(history.pushState, {
    apply(target, arg, args) {
      url = args[2];
      Reflect.apply(target, arg, args);
    },
  });
</script>

<div class="m-2">
  {url}
</div>
<Router url="{url}">
  <nav>
    <Link to="/">Users</Link>
    <Link to="/users">Users</Link>
  </nav>
  <div>
    <Route path="/"><UserList /></Route>
    <Route path="/users"><UserList /></Route>
  </div>
</Router>
