import axios from "axios";
import { derived, get, writable } from "svelte/store";

const baseUrl = "http://localhost:3000/api";
const personsUrl = `${baseUrl}/persons`;

function list() {
  return axios.get(personsUrl).then((res) => {
    return res.data;
  });
}

function show(id) {
  return axios.get(`${personsUrl}/${id}`).then((res) => {
    return res.data;
  });
}

function create(args) {
  return axios.post(personsUrl, args).then((res) => {
    return res.data;
  });
}

function destroy(id) {
  return axios.delete(`${personsUrl}/${id}`).then((res) => {
    return res.data;
  });
}

export function agent() {
  const store = writable({});
  const items = writable([]);
  const item = writable(null);
  return derived([store, items, item], ([$store, $items, $item]) => {
    return {
      items: $items,
      item: $item,
      show: (id) => {
        show(id).then((x) => {
          $store[id] = x;
          store.set($store);
          item.set(x);
        });
      },
      list: () => {
        list().then((xs) => {
          xs.forEach((x) => ($store[x.id] = x));
          store.set($store);
          items.set(xs);
        });
      },
      create: (attrs) => {
        create(attrs).then((x) => {
          $store[id] = x;
          store.set($store);
          item.set(x);
          items.set([...$items, x]);
        });
      },
      destroy: (id) => {
        destroy(id).then(() => {
          delete $store[id];
          store.set($store);
          item.set(null);
          items.set($items.filter((x) => x.id != id));
        });
      },
      fetch: (id) => {
        if (!$store[id]) {
          show(id).then((x) => {
            $store[id] = x;
            store.set($store);
          });
        }
      },
      lookup: (id) => $store[id],
    };
  });
}
