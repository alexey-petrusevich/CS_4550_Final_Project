defmodule ServerWeb.PlaylistController do
  use ServerWeb, :controller


  # returns song info for at most 5 playlists associated with logged in user
  def get_playlists(conn, %{"user_id" => user_id, "token" => token}) do
    url = "https://api.spotify.com/v1/me/playlists"
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    options = [
      params: [
        "limit": 5
      ]
    ]
    # this response contains a collection of playlist URIs
    HTTPoison.get!(url, headers, options)
    |> list_songs(token)
  end



  # returns a list of songs given JSON response
  # title, artist, genre, uri
  def list_songs(resp, token) do
    data = Jason.decode!(resp)
    # retrieve playlist URIs
    playlist_uris = Enum.map(
                      data.items,
                      fn item ->
                        item["uri"]
                      end
                    )
                    |> get_playlist_tracks([], token)
  end


  # returns a list of tracks with
  # title, artist, genre???, uri of each track
  def get_playlist_tracks(playlist_uris, list, token) do
    if (length(playlist_uris) == 0) do
      list
    else
      playlist_uri = hd(playlist_uris)
      url = "https://api.spotify.com/v1/playlists/#{playlist_uri}}}/tracks"
      headers = headers = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer #{token}}",
      ]
      resp = HTTPoison.get!(url, headers)

      # map response into collection of map entries with required data for each track
      temp = Enum.map(
        resp.items,
        fn item ->
          title = item["track"]["name"]
          artist = item["artists"][0]["name"]
          track_uri = item["uri"]
          %{title: title, artist: artist, track_uri: track_uri}
        end
      )
      # append to the end of the list
      list = list ++ temp
      # recursive call
      get_playlist_tracks(tl(playlist_uris), list, token)
    end
  end







  def play(conn, %{"user_id" => user_id, "token" => token}) do
    url = "https://api.spotify.com/v1/me/player/play"
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.put!(url, body, headers)
  end


  def pause(conn, %{"user_id" => user_id, "token" => token}) do
    url = "https://api.spotify.com/v1/me/player/pause"
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.put!(url, body, headers)
  end


  def skip(conn, %{"user_id" => user_id, "token" => token}) do
    url = "https://api.spotify.com/v1/me/player/next"
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.post!(url, body, headers)
  end


  def add_to_queue(conn, %{"user_id" => user_id, "token" => token, "track_uri" => track_uri}) do
    url = "https://api.spotify.com/v1/me/player/queue"
    body = Jason.encode!(%{"uri": track_uri})
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.post!(url, body, headers)
  end


end
