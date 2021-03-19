defmodule SpotifyParty do
  @moduledoc """
  SpotifyParty keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # TODO: replace with storing this in environment or configuration files??
  def bearer_token, do: "BQAJRZelVpViAw28K4RSTL_QL0q7efRNYY7-NwNhIeNHCaeoaxlsVgny9X01cE4Ad2IuaIOdgfsBaLxZ2mGBzCqrl5ipcbFDpbseDTGQoWTTi_6a7f4TeEJRHoroz_HHY8XXXlSbjepcwhcT575A1hIqO1D9YPtPqnMGgf9F9tbiSNShCb2GA68gHcTzQ7l6Z8RPtSsys3Ch5wzPmL513Lk0Q5edfeDEpiv8EB3Y51QeWa4wywdH17TGCkAyrL3UFbkY58vn74PjTSB2ORNyIeF0YjGLBYPvGhNKhUORLN85"

  # returns song to be added to the queue
  def default_track_uri(), do: "spotify:track:48UPSzbZjgc449aqz8bxox"

  # dont' need this to add track to queue
  def default_device_id(), do: "8f7e5cd411f3f2b297953a1cfd0909ced1c86158"


  def set_bearer_token(new_token) do
    bearer_token = new_token
  end

  def get_bearer_token() do
    bearer_token
  end

  # returns the current song played
  def get_current_track() do
    endpoint = "https://api.spotify.com/v1/me/player"
    token = get_bearer_token
    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}}"}
    ]
    options = [
      params: %{
        market: "US"
      }
    ]
    resp = HTTPoison.get!(endpoint, headers, options)
    data = Jason.decode!(resp.body)
  end

  # returns device id of the player
  def get_device_id() do
    data = get_current_track()
    data["device"]["id"]
  end

  # returns names of all the artists
  def get_artist_names() do
    data = get_current_track()
    artists = data["item"]["artists"]
    Enum.map artists, fn x ->
      x["name"]
    end
  end

  # get names of tracks
  def get_track_name() do
    data = get_current_track()
    data["item"]["name"]
  end

  # returns uri of a track given data about a song
  def get_track_uri(data) do
    data["item"]["uri"]
  end

  def add_track_to_queue(track_uri \\ default_track_uri()) do
    endpoint = "https://api.spotify.com/v1/me/player/queue"
    token = get_bearer_token
    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}}"}
    ]
    options = [
      params: %{
        uri: track_uri
      }
    ]
    body = ""
    resp = HTTPoison.post!(endpoint, body, headers, options)
  end

  # skips current track and
  def next_track() do
    endpoint = "https://api.spotify.com/v1/me/player/next"
    token = get_bearer_token
    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}}"}
    ]
    body = ""
    resp = HTTPoison.post(endpoint, body, headers)
  end

  # SpotifyParty.add_track_to_queue()
  # SpotifyParty.next_track()
end
