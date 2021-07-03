import Agent from "./Agent.js";
import Env from "../App/Env.js";

const endpoint = `${Env.API_URL}/entries`;

export default {
  agent: () => Agent(endpoint),
};
