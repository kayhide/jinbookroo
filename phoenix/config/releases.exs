import Config

config :jinbookroo, Jinbookroo.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  database: "",
  ssl: String.to_existing_atom(System.get_env("DB_SSL_ENABLED", "true")),
  pool_size: 2

config :jinbookroo, JinbookrooWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
