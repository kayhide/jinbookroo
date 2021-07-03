const httpProxy = require('http-proxy');
const proxy = httpProxy.createServer({ target: 'http://localhost:3001' })

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    public: {url: '/', static: true},
    src: {url: '/dist'},
  },
  plugins: [
    '@snowpack/plugin-svelte'
  ],
  routes: [
    {
      src: '/api/.*',
      dest: (req, res) => {
        proxy.web(req, res);
      },
    },
    {
      match: "routes",
      src: ".*",
      dest: "/"
    },
  ],
  env: {
    API_URL: process.env.SNOWPACK_PUBLIC_API_URL || "http://localhost:3000/api"
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    /* ... */
  },
};
