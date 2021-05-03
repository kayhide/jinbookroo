import axios from "axios";
import { writable } from "svelte/store";

const baseUrl = "http://localhost:3000/api";
const dealsUrl = `${baseUrl}/deals`;

function list() {
  return axios.get(dealsUrl).then((res) => {
    return res.data;
  });
}

function show(id) {
  return axios.get(`${dealsUrl}/${id}`, args).then((res) => {
    return res.data;
  });
}

function create(args) {
  return axios.post(dealsUrl, args).then((res) => {
    return res.data;
  });
}

function destroy(id) {
  return axios.delete(`${dealsUrl}/${id}`).then((res) => {
    return res.data;
  });
}

export function agent() {
  const items = writable([]);
  const item = writable(null);
  return {
    items,
    item,
    show: (id) => {
      show(id).then((x) => {
        item.set(x);
      });
    },
    list: () => {
      list().then((xs) => {
        items.set(xs);
      });
    },
    create: (attrs) => {
      create(attrs).then((x) => {
        items.update((xs) => [...xs, x]);
      });
    },
    destroy: (id) => {
      destroy(id).then(() => {
        items.update((xs) => xs.filter((x) => x.id != id));
      });
    },
  };
}
