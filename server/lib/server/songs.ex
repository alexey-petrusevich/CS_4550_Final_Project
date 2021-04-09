defmodule Server.Songs do
  @moduledoc """
  The Songs context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo
  alias Server.AuthTokens

  alias Server.Songs.Song
  alias Server.Requests
  alias Server.Users

  @doc """
  Returns the list of songs.

  ## Examples

      iex> list_songs()
      [%Song{}, ...]

  """
  def list_songs do
    Repo.all(Song)
    |> Repo.preload(:party)
  end

  @doc """
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id) do
    Repo.get!(Song, id)
    |> Repo.preload(:party)
  end

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a song.

  ## Examples

      iex> delete_song(song)
      {:ok, %Song{}}

      iex> delete_song(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{data: %Song{}}

  """
  def change_song(%Song{} = song, attrs \\ %{}) do
    Song.changeset(song, attrs)
  end


  # updates a song with status of played
  def update_played(song_id) do
    song = get_song!(song_id)
    IO.inspect(song)
    artist_uri = get_artist_uri(song.track_uri)
    IO.inspect(artist_uri)
    genre = get_track_genre(artist_uri)
    IO.inspect(genre)
    {energy, danceability, loudness, valence} = get_track_stats(song.track_uri)
    # update impact scores for everyone who votes for this song
    update_impact_scores(song_id) # for whoever requested the same song
    #update_impact_scores_for_votes(song_id) # for whoever voted for the song

    song
    |> Ecto.Changeset.change(played: true)
    |> Ecto.Changeset.change(genre: genre)
    |> Ecto.Changeset.change(energy: energy)
    |> Ecto.Changeset.change(danceability: danceability)
    |> Ecto.Changeset.change(loudness: loudness)
    |> Ecto.Changeset.change(valence: valence)
    |> Repo.update()

  end

  def update_impact_scores_for_votes(song_id) do
    user_ids = Votes.request_all_user_ids_by_track_uri(song_id)
    Enum.map(
      user_ids,
      fn user_id ->
        Users.update_impact_score(to_string(user_id))
      end
    )
  end


  # updates impact score for each user who made a requests with the given song_id
  def update_impact_scores(song_id) do
    song = get_song!(song_id)
    track_uri = song.track_uri
    # this returns the list of user ids
    user_ids = Requests.request_all_user_ids_by_track_uri(track_uri)
    Enum.map(
      user_ids,
      fn user_id ->
        Users.update_impact_score(to_string(user_id))
      end
    )
  end


  # return track genre given artist_uri and spotify access token
  # in case there are more than one genres, return the first return by API
  # if no genres returned by API call, returns "none" for genre
  def get_track_genre(artist_uri) do
    token = AuthTokens.get_public_token()
    track_artist = get_artists_id(artist_uri)
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


  # returns a map containing the following data given track_uri and access token:
  # {energy, danceability, loudness, valence}
  def get_track_stats(track_uri) do
    token = AuthTokens.get_public_token()
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

  # returns artist URI given track URI
  def get_artist_uri(track_uri) do
    token = AuthTokens.get_public_token()
    track_id = get_track_id(track_uri)
    market = "US"
    url = "https://api.spotify.com/v1/tracks/#{track_id}?market=#{market}"
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    artist = data["artists"]
             |> Enum.at(0)
    artist_uri = artist["uri"]
    artist_uri
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
