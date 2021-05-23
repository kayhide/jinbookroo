import Agent from "./Agent.js";

const baseUrl = "http://localhost:3000/api";
const personsUrl = `${baseUrl}/entries`;

export default {
  agent: () => Agent(personsUrl),
};
