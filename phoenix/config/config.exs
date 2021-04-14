# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jinbookroo,
  ecto_repos: [Jinbookroo.Repo]

# Configures the endpoint
config :jinbookroo, JinbookrooWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CVlFVBc1D68nKObF64JKpHHMsY3mLOoJU5cjg33UueQyWc8K8yOuUqXnqaD12F+I",
  render_errors: [view: JinbookrooWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Jinbookroo.PubSub,
  live_view: [signing_salt: "/iB18zPm"]

config :jinbookroo, JinbookrooWeb.Auth.Guardian,
  issuer: "jinbookroo",
  secret_key: "IFJRIw7VrGKj/9s2qGBGl8F15Rs9UgfwYbiloZoAfmV36wJ3RQfy05f389p8o0Kq"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
