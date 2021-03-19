# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :test_spotify, TestSpotifyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rxTN/UgvAIqbJi5BCLtbixE6dJ4nwMCa9MCc2ybPotAxWvIIX22Z/P6kOcNbfGxw",
  render_errors: [view: TestSpotifyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TestSpotify.PubSub,
  live_view: [signing_salt: "ofRI969Y"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
