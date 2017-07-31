# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :parliament_bot, ParliamentBotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sD+Gj7uZwFvqqtVKgT11IMBRUAY5Q3VV2xes0O/X6OBfRyHUDvKLMK+a8T0fo/Jx",
  render_errors: [view: ParliamentBotWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ParliamentBot.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
