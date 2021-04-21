import axios from "axios";
import { writable } from "svelte/store";

const baseUrl = "http://localhost:3000/api";
const authUrl = `${baseUrl}/auth`;

function create(args) {
  return axios.post(authUrl, args).then((res) => {
    return res.data;
  });
}

export function item() {
  const { subscribe, set, update } = writable({ token: null });
  return {
    subscribe,
    login: (attrs) => {
      create(attrs).then(({ token }) => {
        set({ token });
      });
    },
  };
}
