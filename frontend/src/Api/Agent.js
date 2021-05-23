import axios from "axios";
import { derived, get, writable } from "svelte/store";

function client(entpoint) {
  return {
    list: (params) => axios.get(entpoint, { params }).then(({ data }) => data),

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
  const submittings = writable({ creatings: 0, updatings: 0, destroyings: 0 });
  return derived(
    [store, items, item, submittings],
    ([$store, $items, $item, $submittings]) => {
      const { creatings, updatings, destroyings } = $submittings;
      return {
        items: $items,
        item: $item,
        isCreating: 0 < creatings,
        isUpdating: 0 < updatings,
        isDestroying: 0 < destroyings,
        submitting: 0 < creatings + updatings + destroyings,
        show: (id) => {
          client_.show(id).then((x) => {
            $store[id] = x;
            store.set($store);
            item.set(x);
          });
        },
        list: (params) => {
          client_.list(params).then((xs) => {
            xs.forEach((x) => ($store[x.id] = x));
            store.set($store);
            items.set(xs);
          });
        },
        create: (attrs) => {
          submittings.update((x) =>
            Object.assign(x, { creatings: x.creatings + 1 })
          );
          client_.create(attrs).then((x) => {
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
          client_.update(id, attrs).then((x) => {
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
          client_.destroy(id).then(() => {
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
            client_.show(id).then((x) => {
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
