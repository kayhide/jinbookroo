import axios from "axios";
import { derived, get, writable } from "svelte/store";

function client(entpoint) {
  return {
    list: () => axios.get(entpoint).then(({ data }) => data),

    show: (id) => axios.get(`${entpoint}/${id}`).then(({ data }) => data),

    create: (args) => axios.post(entpoint, args).then(({ data }) => data),

    update: (id, args) =>
      axios.put(`${entpoint}/${id}`, args).then(({ data }) => data),

    destroy: (id) => axios.delete(`${entpoint}/${id}`).then(({ data }) => data),
  };
}

export default function (endpoint) {
  const client_ = client(endpoint);
  const store = writable({});
  const items = writable([]);
  const item = writable(null);
  return derived([store, items, item], ([$store, $items, $item]) => {
    return {
      items: $items,
      item: $item,
      show: (id) => {
        client_.show(id).then((x) => {
          $store[id] = x;
          store.set($store);
          item.set(x);
        });
      },
      list: () => {
        client_.list().then((xs) => {
          xs.forEach((x) => ($store[x.id] = x));
          store.set($store);
          items.set(xs);
        });
      },
      create: (attrs) => {
        client_.create(attrs).then((x) => {
          $store[x.id] = x;
          store.set($store);
          item.set(x);
          items.set([...$items, x]);
        });
      },
      update: (id, attrs) => {
        client_.update(id, attrs).then((x) => {
          $store[x.id] = x;
          store.set($store);
          item.set(x);
          $items
            .filter((x) => x.id == id)
            .forEach((x_) => Object.assign(x_, x));
          items.set($items);
        });
      },
      destroy: (id) => {
        client_.destroy(id).then(() => {
          delete $store[id];
          store.set($store);
          item.set(null);
          items.set($items.filter((x) => x.id != id));
        });
      },
      fetch: (id) => {
        if (!$store[id]) {
          client_.show(id).then((x) => {
            $store[id] = x;
            store.set($store);
          });
        }
      },
      lookup: (id) => $store[id],
    };
  });
}
