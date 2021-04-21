import axios from "axios";
import { writable } from "svelte/store";

const baseUrl = "http://localhost:3000/api";
const usersUrl = `${baseUrl}/users`;

function list() {
  return axios.get(usersUrl).then((res) => {
    return res.data;
  });
}

function create(args) {
  return axios.post(usersUrl, args).then((res) => {
    return res.data;
  });
}

export function items() {
  const { subscribe, set, update } = writable([]);
  return {
    subscribe,
    list: () => {
      list().then((xs) => {
        set(xs);
      });
    },
    create: (attrs) => {
      create(attrs).then((x) => {
        update((xs) => [...xs, x]);
      });
    },
  };
}
