defmodule Server.Playlists do
  alias Server.AuthTokens
  alias Server.Songs


  # returns a list of playlist items containing playlist title and URI
  def get_playlist_uris(user_id) do
    token = AuthTokens.get_auth_token_by_user_id(user_id)
    fetch_playlist_uris(token.token)
  end


  # returns a list of playlist URIs given spotify access token
  def fetch_playlist_uris(token) do
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
    store_tracks(tracks, party_id)
  end

  # returns a list of tracks given playlist_uri (and token)
  # title, artist, genre???, uri of each track
  def get_playlist_tracks(playlist_uri, token) do
    uri = playlist_uri
    |> String.split(":")
    |> Enum.at(2)


    url = "https://api.spotify.com/v1/playlists/#{uri}/tracks"
    headers = headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)

    tracks = Enum.map(
      data["items"],
      fn item ->
        title = item["track"]["name"]
        track_uri = item["track"]["uri"]
        # assumption that there is a single artist for every track
        artist = item["track"]["artists"] |> Enum.at(0) |> Map.get("name")
        artist_uri = item["track"]["artists"] |> Enum.at(0) |> Map.get("uri")
        # idk why item["track]["artists"][0] isnt working anymore

        # TODO alex : call the two new apis (get artist genre and get track data) and update
        #             track fields to be written to the database rather than defaults I hardcoded below
        %{title: title, track_uri: track_uri, artist: artist, artist_uri: artist_uri}
      end
    )
    tracks
  end

  #given a collection of tracks, stores each song in the DB
  def store_tracks(tracks, party_id) do
   Enum.map(
     tracks,
     fn track ->
       genre = "" # TODO: resolve having no genre in JSON response from spotify
       Server.Songs.create_song(
         %{artist: track.artist, artist_uri: "uri",
              title: track.title, track_uri: track.track_uri,
              party_id: party_id, played: false, genre: "Hip hop",
              energy: "0", danceability: "0", loudness: "0",
              valence: ""}
       )
     end
   )
  end
end
