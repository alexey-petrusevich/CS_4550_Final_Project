defmodule ServerWeb.PartyChannel do
  use ServerWeb, :channel

  alias Server.Playlists
  alias Server.Parties
  alias Server.Songs
  alias Server.Requests

  alias ServerWeb.PlaybackController

  @impl true
  def join("party:" <> roomcode, payload, socket) do
    if authorized?(payload) do
      IO.inspect("Joined channel #{roomcode}")
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("get_playlists", %{"user_id" => host_id}, socket) do
    playlists = Playlists.get_playlist_uris(host_id)
    {:reply, {:ok, %{playlists: playlists}}, socket}
  end

  # sets the songs of a given party to be from the given playlist
  @impl true
  def handle_in("set_songs", payload, socket) do
    IO.inspect(payload)
    Playlists.interact(payload)
    {:reply, {:ok, 200}, socket}
  end

  # updates the active status of this party
  @impl true
  def handle_in("update_active", %{"party_id" => id, "is_active" => active}, socket) do
    IO.inspect(id)
    IO.inspect(active)
    Parties.update_active(id, active)
    {:reply, {:ok, 200}, socket}
  end

  # updates the given song to be played -> true
  @impl true
  def handle_in("queue_song", %{"is_song" => song, "track_id" => id, "track_uri" => uri, "host_id" => host_id}, socket) do
    IO.inspect(id)
    PlaybackController.queue(uri, host_id)
    # update song played only if a song_id is given (otherwise it is a request)
    if song do
      IO.inspect("It's a song!!!")
      Songs.update_played(id)
    else
      IO.inspect("It's a request!!!")
      Requests.update_played(id)
    end

    {:reply, {:ok, "Successfully added track to your playback queue."}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
