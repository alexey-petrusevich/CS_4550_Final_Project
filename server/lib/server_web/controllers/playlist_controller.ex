defmodule ServerWeb.PlaylistController do
  use ServerWeb, :controller
  alias Server.AuthTokens
  alias Server.Songs.Song
  alias Server.Songs.Songs


  # TODO: 2) change preloading songs to the queue automatically to given playlist (??)


  def enqueue_playlist(conn, %{"user_id" => user_id, "playlist_uri" => playlist_uri}) do
    token = AuthTokens.get_auth_token_by_user_id(user_id)
    track_uris = get_playlist_tracks(playlist_uri)
    enqueue_playlist(track_uris, token)
  end


  def enqueue_playlist(track_uris, token) do
    Enum.map(
      track_uris,
      fn track_uri ->
        url = "https://api.spotify.com/v1/me/player/queue"
        body = Jason.encode!(%{"uri": track_uri})
        headers = [
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer #{token}}"
        ]
        HTTPoison.post!(url, body, headers)
      end
    )
  end


  def interact(conn, %{"user_id" => user_id, "party_id" => party_id, "playlist_uri" => playlist_uri}) do
    token = AuthTokens.get_auth_token_by_user_id(user_id)
    # 1) get the list of songs for the given playlist
    # each track here is a map containing title, artist, etc.
    tracks = get_playlist_tracks(playlist_uri, token)
    # 2) add it to the db
    # store tracks in the db
    store_tracks(tracks, party_id)
    # 3) return song info back to the caller (with title, artist, track_uri, track_id)
    # here track_id means track_id in the DB
    tracks = append_track_id(tracks)
    # 4) enqueue tracks to the spotify queue
    track_uris = Enum.map(tracks, fn item ->
      item.track_uri
    end)
    enqueue_playlist(track_uris, token)
  end


  # returns a list of playlist items containing playlist title and URI
  def get_playlist_uris(conn, %{"user_id" => user_id}) do
    token = AuthTokens.get_auth_token_by_user_id(user_id)
    fetch_playlist_uris(token)
  end


  # returns a list of playlist URIs given spotify access token
  def fetch_playlist_uris(token) do
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
    |> list_playlist_uris()
  end


  # returns a list of playlist URIs given JSON response
  # together with playlist URIs returns playlist title
  # each item represents a map
  def list_playlist_uris(resp) do
    data = Jason.decode!(resp)
    playlist_items = Enum.map(
      data.items,
      fn item ->
        playlist_title = item["name"]
        playlist_uri = item["uri"]
        %{playlist_title: playlist_title, playlist_uri: playlist_uri}
      end
    )
    playlist_items
  end


  # returns a list of tracks given playlist_uri (and token)
  # title, artist, genre???, uri of each track
  def get_playlist_tracks(playlist_uri, token) do
    url = "https://api.spotify.com/v1/playlists/#{playlist_uri}}}/tracks"
    headers = headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    tracks = Enum.map(
      resp.items,
      fn item ->
        title = item["track"]["name"]
        # assumption that there is a single artist for every track
        artist = item["artists"][0]["name"]
        track_uri = item["uri"]
        %{title: title, artist: artist, track_uri: track_uri}
      end
    )
  end


  # given a collection of tracks, stores each track in the DB
  # return value are tracks
  def store_tracks(tracks) do
    Enum.map(
      tracks,
      fn track ->
        genre = "" # TODO: resolve having no genre in JSON response from spotify
        Server.Songs.create_song(
          %Song{artist: track.artist, genre: genre, title: track.title, track_uri: track.track_uri}
        )
        id = 1 # TODO: get track id from DB??
        # update track
        %{track | id: id}
      end
    )
  end

end
