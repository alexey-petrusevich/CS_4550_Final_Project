defmodule SpotifyParty.Repo do
  use Ecto.Repo,
    otp_app: :spotify_party,
    adapter: Ecto.Adapters.Postgres
end
