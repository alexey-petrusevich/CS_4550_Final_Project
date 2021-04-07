defmodule Server.Playlists do
  alias Server.AuthTokens

  # returns a list of playlist items containing playlist title and URI
  def get_playlist_uris(user_id) do
    IO.inspect(user_id)
    token = AuthTokens.get_auth_token_by_user_id(user_id)
    IO.inspect(token)
    user_playlists = fetch_playlist_uris(token.token)

    IO.inspect(user_playlists)
    user_playlists
  end


  # returns a list of playlist URIs given spotify access token
  def fetch_playlist_uris(token) do
    IO.inspect("got here")
    IO.inspect(token)
    url = "https://api.spotify.com/v1/me/playlists?limit=5"
    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}"},
    ]
    # this response contains a collection of playlist URIs
    HTTPoison.get!(url, headers)
    |> list_playlist_uris()
  end


  # returns a list of playlist URIs given JSON response
  # together with playlist URIs returns playlist title
  # each item represents a map
  def list_playlist_uris(resp) do
    IO.inspect("Got to list playlist uris")
    IO.inspect(resp)
    data = Jason.decode!(resp.body)
    playlist_items = Enum.map(
      data["items"],
      fn item ->
        playlist_title = item["name"]
        playlist_length = item["tracks"]["total"]
        playlist_uri = item["uri"]
        %{playlist_title: playlist_title, playlist_uri: playlist_uri, num_tracks: playlist_length}
      end
    )
    playlist_items
  end

end
