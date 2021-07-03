import axios from "axios";
import { writable } from "svelte/store";
import Env from "../App/Env.js";

const endpoint = `${Env.API_URL}/auth`;

function create(args) {
  return axios.post(endpoint, args).then((res) => {
    return res.data;
  });
}

function index(token) {
  return axios.get(endpoint, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
}

export default function () {
  const { subscribe, set, update } = writable({ token: null, verified: false });
  return {
    subscribe,
    login: (attrs) => {
      create(attrs).then(({ token }) => {
        set({ token, verified: true });
      });
    },
    verify: (token) => {
      if (token) {
        index(token)
          .then(() => {
            set({ token, verified: true });
          })
          .catch((error) => {
            set({ token: null, verified: false });
          });
      } else {
        set({ token: null, verified: false });
      }
    },
  };
}
