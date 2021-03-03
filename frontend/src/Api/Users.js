import axios from "axios";

export function list() {
  return axios.get("http://localhost:3000/api/users").then((res) => {
    return res.data;
  });

}

export function create(args) {
  return axios.post("http://localhost:3000/api/users", args).then((res) => {
    return res.data;
  });
}
