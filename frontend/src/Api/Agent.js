import axios from "axios";
import { derived, get, writable } from "svelte/store";
import Store from "../App/Store.js";

function client(entpoint) {
  const headers = (token) => {
    return {
      Authorization: `Bearer ${token}`,
    };
  };
  return {
    list: (token, params) =>
      axios
        .get(entpoint, {
          params,
          headers: headers(token),
        })
        .then(({ data }) => data),

    show: (token, id) =>
      axios
        .get(`${entpoint}/${id}`, {
          headers: headers(token),
        })
        .then(({ data }) => data),
    create: (token, args) =>
      axios
        .post(entpoint, args, {
          headers: headers(token),
        })
        .then(({ data }) => data),

    update: (token, id, args) =>
      axios
        .put(`${entpoint}/${id}`, args, {
          headers: headers(token),
        })
        .then(({ data }) => data),

    destroy: (token, id) =>
      axios
        .delete(`${entpoint}/${id}`, {
          headers: headers(token),
        })
        .then(({ data }) => data),
  };
}

export default function (endpoint) {
  const client_ = client(endpoint);
  const token = Store.accessToken;
  const store = writable({});
  const items = writable([]);
  const item = writable(null);
  const submittings = writable({ creatings: 0, updatings: 0, destroyings: 0 });
  return derived(
    [token, store, items, item, submittings],
    ([$token, $store, $items, $item, $submittings]) => {
      const { creatings, updatings, destroyings } = $submittings;
      return {
        items: $items,
        item: $item,
        isCreating: 0 < creatings,
        isUpdating: 0 < updatings,
        isDestroying: 0 < destroyings,
        submitting: 0 < creatings + updatings + destroyings,
        show: (id) => {
          client_.show($token, id).then((x) => {
            $store[id] = x;
            store.set($store);
            item.set(x);
          });
        },
        list: (params) => {
          client_.list($token, params).then((xs) => {
            xs.forEach((x) => ($store[x.id] = x));
            store.set($store);
            items.set(xs);
          });
        },
        create: (attrs) => {
          submittings.update((x) =>
            Object.assign(x, { creatings: x.creatings + 1 })
          );
          client_.create($token, attrs).then((x) => {
            $store[x.id] = x;
            store.set($store);
            item.set(x);
            items.set([...$items, x]);
            submittings.update((x) =>
              Object.assign(x, { creatings: x.creatings - 1 })
            );
          });
        },
        update: (id, attrs) => {
          submittings.update((x) =>
            Object.assign(x, { updatings: x.updatings + 1 })
          );
          client_.update($token, id, attrs).then((x) => {
            $store[x.id] = x;
            store.set($store);
            item.set(x);
            $items
              .filter((x) => x.id == id)
              .forEach((x_) => Object.assign(x_, x));
            items.set($items);
            submittings.update((x) =>
              Object.assign(x, { updatings: x.updatings - 1 })
            );
          });
        },
        destroy: (id) => {
          submittings.update((x) =>
            Object.assign(x, { destroyings: x.destroyings + 1 })
          );
          client_.destroy($token, id).then(() => {
            delete $store[id];
            store.set($store);
            item.set(null);
            items.set($items.filter((x) => x.id != id));
            submittings.update((x) =>
              Object.assign(x, { destroyings: x.destroyings - 1 })
            );
          });
        },
        fetch: (id) => {
          if (!$store[id]) {
            client_.show($token, id).then((x) => {
              $store[id] = x;
              store.set($store);
            });
          }
        },
        lookup: (id) => $store[id],
      };
    }
  );
}
