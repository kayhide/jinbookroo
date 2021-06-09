import { writable, get } from "svelte/store";

const namespace = "jinbookroo";

function writable_(key, initialValue) {
  const store = writable(initialValue);
  const { subscribe, set } = store;
  const fullKey = `${namespace}.${key}`;
  const json = localStorage.getItem(fullKey);

  if (json) {
    set(JSON.parse(json));
  }

  return {
    set(value) {
      localStorage.setItem(fullKey, JSON.stringify(value));
      set(value);
    },
    update(cb) {
      const value = cb(get(store));
      this.set(value);
    },
    subscribe,
  };
}

const store = {
  accessToken: writable_("access-token", ""),
};

export default store;
