import axios from "axios";
import { writable } from "svelte/store";

const baseUrl = "http://localhost:3000/api";
const authUrl = `${baseUrl}/auth`;

function create(args) {
  return axios.post(authUrl, args).then((res) => {
    return res.data;
  });
}

function index(token) {
  return axios.get(authUrl, {
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
