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
  # - genre
  # - energy
  # - danceability
  # - loudness
  # - valence
  # tested
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


        # TODO: add genre, and other things only when the track is added to the queue???
        # TODO: set genre, dancebility, etc. with default values
        # TODO: move requesting actual stats only when the song gets added to the queue


        genre = get_track_genre(artist_uri, token);
        {energy, danceability, loudness, valence} = get_track_stats(track_uri, token)
        %{
          artist: artist,
          title: title,
          track_uri: track_uri,
          genre: genre,
          energy: energy,
          danceability: danceability,
          loudness: loudness,
          valence: valence
        }
      end
    )
    tracks
  end


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


  # return track genre given track_artist and spotify access token
  # in case there are more than one genres, return the first return by API
  # if no genres returned by API call, returns "none" for genre
  def get_track_genre(track_artist, token) do
    track_artist = get_artists_id(track_artist)
    url = "https://api.spotify.com/v1/artists/#{track_artist}"
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    # manual delay because requesting too fast fails
    Process.sleep(100)
    genres = data["genres"]
    if (length(genres) == 0) do
      "none"
    else
      hd(data["genres"])
    end
  end


  # returns a tuple containing the following data given track_uri and access token:
  # {energy, danceability, loudness, valence}
  def get_track_stats(track_uri, token) do
    track_id = get_track_id(track_uri)
    url = "https://api.spotify.com/v1/audio-features/#{track_id}"
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    {data["energy"], data["danceability"], data["loudness"], data["valence"]}
  end


  # returns track id given track uri
  def get_track_id(track_uri) do
    track_uri
    |> String.split(":")
    |> Enum.at(2)
  end

  def get_artists_id(artists_uri) do
    artists_uri
    |> String.split(":")
    |> Enum.at(2)
  end


end
