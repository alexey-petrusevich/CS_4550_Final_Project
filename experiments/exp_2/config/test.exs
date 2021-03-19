use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :spotify_party, SpotifyParty.Repo,
  # username: "postgres",
  # password: "postgres",
  # database: "spotify_party_test#{System.get_env("MIX_TEST_PARTITION")}",
  username: "event_app",
  password: "wobi6ienohCh",
  database: "event_app_07_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :spotify_party, SpotifyPartyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
