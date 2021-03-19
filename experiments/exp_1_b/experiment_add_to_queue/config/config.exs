# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :spotify_party,
  ecto_repos: [SpotifyParty.Repo]

# Configures the endpoint
config :spotify_party, SpotifyPartyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rLAyaJbKkcXnQdWSRipD7Xzq8P5EUfoIlB92mtHXX4Qsp5XJfFTrpmv46wFeavqY",
  render_errors: [view: SpotifyPartyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SpotifyParty.PubSub,
  live_view: [signing_salt: "IKSfh+lO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
