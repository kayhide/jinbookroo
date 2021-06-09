import Agent from "./Agent.js";

const baseUrl = "http://localhost:3000/api";
const usersUrl = `${baseUrl}/users`;

export default {
  agent: () => Agent(usersUrl),
};
