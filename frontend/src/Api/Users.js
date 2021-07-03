import Agent from "./Agent.js";
import Env from "../App/Env.js";

const endpoint = `${Env.API_URL}/users`;

export default {
  agent: () => Agent(endpoint),
};
