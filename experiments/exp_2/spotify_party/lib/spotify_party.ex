defmodule SpotifyParty do
  @moduledoc """
  SpotifyParty keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def request_authorization() do
    endpoint = "https://accounts.spotify.com/authorize?client_id=083c7adf4fa44846bdbf7a5972e8ab1b&response_type=code&redirect_uri=https://events.wbdbvaustinkim.com&scope=app-remote-control&state=34fFs29kd09"
    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]
    options = [
    ]

    resp = HTTPoison.get!(endpoint, headers, options)
    IO.puts(resp)
    # data = Jason.decode!(resp.body)
  end

end
