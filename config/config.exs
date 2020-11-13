# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixirius,
  ecto_repos: [Elixirius.Repo]

# Configures the endpoint
config :elixirius, ElixiriusWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "64qSzDSQoPTAed3xxLZvy3Mb0ffneZOc1mVE28/Y18p7CKnGHw/rtoSiGs5pl+d3",
  render_errors: [view: ElixiriusWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Elixirius.PubSub,
  live_view: [signing_salt: "rVXNGRdu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
