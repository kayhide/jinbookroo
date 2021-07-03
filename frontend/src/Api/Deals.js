import Agent from "./Agent.js";
import Env from "../App/Env.js";

const endpoint = `${Env.API_URL}/deals`;

export default {
  agent: () => Agent(endpoint),
};
