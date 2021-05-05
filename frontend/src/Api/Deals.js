import Agent from "./Agent.js";

const baseUrl = "http://localhost:3000/api";
const dealsUrl = `${baseUrl}/deals`;

export default {
  agent: () => Agent(dealsUrl),
};
