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
    url = "https://api.spotify.com/v1/me/playlists?limit=10"
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

  #-----------------GETTING PLAYLISTS SONGS-------------------

  def interact(%{"user_id" => user_id, "party_id" => party_id, "playlist_uri" => playlist_uri}) do
    IO.inspect("got_here")
    token = AuthTokens.get_auth_token_by_user_id(user_id)
    # 1) get the list of songs for the given playlist
    # each track here is a map containing title, artist, etc.
    tracks = get_playlist_tracks(playlist_uri, token.token)
    # 2) add it to the db
    # store tracks in the db
    IO.inspect(tracks)
      #store_tracks(tracks, party_id)

    # 3) return song info back to the caller (with title, artist, track_uri, track_id)
    # here track_id means track_id in the DB
    #tracks = append_track_id(tracks)
    # 4) enqueue tracks to the spotify queue
    # track_uris = Enum.map(
    #   tracks,
    #   fn item ->
    #     item.track_uri
    #   end
    # )
    # enqueue_playlist(track_uris, token)
  end

  # returns a list of tracks given playlist_uri (and token)
  # title, artist, genre???, uri of each track
  def get_playlist_tracks(playlist_uri, token) do
    IO.inspect("Getting track playlists");
    uri = playlist_uri
    |> String.split(":")
    |> Enum.at(2)
    IO.inspect(uri)


    url = "https://api.spotify.com/v1/playlists/#{uri}/tracks"
    headers = headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    IO.inspect(data["items"])
    # tracks = Enum.map(
    #   resp.items,
    #   fn item ->
    #     title = item["track"]["name"]
    #     # assumption that there is a single artist for every track
    #     artist = item["artists"][0]["name"]
    #     track_uri = item["uri"]
    #     %{title: title, artist: artist, track_uri: track_uri}
    #   end
    # )
  end

  # given a collection of tracks, stores each track in the DB
  # return value are tracks
  def store_tracks(tracks, party_id) do
    Enum.map(
      tracks,
      fn track ->
        genre = "" # TODO: resolve having no genre in JSON response from spotify
        Server.Songs.create_song(
          %Song{artist: track.artist, title: track.title, track_uri: track.track_uri, request: true, isPlayed: false, party_id: party_id}
        )
        id = 1 # TODO: get track id from DB??
        # TODO: possibly query the DB for the song using track_uri ???
        # update track
        %{track | id: id}
      end
    )
  end
end
