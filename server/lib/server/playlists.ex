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
    store_tracks(tracks, party_id, token)
  end


  # returns a list of tracks given playlist_uri (and token)
  # each track represents a map entry containing the following data:
  # - artist
  # - title
  # - track_uri
  # - genre: empty
  # - energy: 0
  # - danceability: 0
  # - loudness: 0
  # - valence: 0
  # NOTE: actual songs stats are updated when a song is added to the queue
  def get_playlist_tracks(playlist_uri, token) do
    uri = playlist_uri
          |> String.split(":")
          |> Enum.at(2)
    url = "https://api.spotify.com/v1/playlists/#{uri}/tracks"
    headers = [
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
        artist = item["track"]["artists"]
                 |> Enum.at(0)
                 |> Map.get("name")
        artist_uri = item["track"]["artists"]
                     |> Enum.at(0)
                     |> Map.get("uri")
        %{
          artist: artist,
          title: title,
          track_uri: track_uri,
          genre: "empty",
          energy: 0,
          danceability: 0,
          loudness: 0,
          valence: 0
        }
      end
    )
    tracks
  end

"""
  "spotify:playlist:37i9dQZF1DX6uhsAfngvaD"
  BQC_XI0Jl1lMRcgiHM9vFUXua6JZ6ZSd2YHYDNMkBa9q6zRm6L_cTP_d6TTYwYGaU5TInwMeHakaj3A17vu0NBKGHHaSrb3nmxjS8xU9_RknL5f8sqBHRpYlNiBYc4jLu79qdr_ceAJQesw5QmDklnEMCXprxDHultQZes8ctFlXmLGutrTCXzJtzuyV721KhNxcv1O6SP_67EnQnLYXPofEcDuSr6la4OOv8wloDnRqHEnQVSZa1Hubp55VyqQzeNJcPfKFYop0OGN9M7DmrIeJghtMC4tMqRwOA15J6jz3
"""

  # given a collection of tracks, stores each song in the DB
  def store_tracks(tracks, party_id, token) do
    Enum.map(
      tracks,
      fn track ->
        Server.Songs.create_song(
          %{
            artist: track.artist,
            title: track.title,
            track_uri: track.track_uri,
            party_id: party_id,
            played: false,
            genre: track.genre,
            energy: track.energy,
            danceability: track.danceability,
            loudness: track.loudness,
            valence: track.valence
          }
        )
      end
    )
  end

end
