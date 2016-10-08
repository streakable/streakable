# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :streakable,
  ecto_repos: [Streakable.Repo]

# Configures the endpoint
config :streakable, Streakable.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bnq/sLn5TrjRPYCN/i5nSu4XGkfcc9QpYQoMuBVGrYBbhJDQ+Za0F7IJnpIjSxpW",
  render_errors: [view: Streakable.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Streakable.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
