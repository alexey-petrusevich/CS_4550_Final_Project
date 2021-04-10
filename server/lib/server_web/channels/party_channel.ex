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
      IO.inspect("User joined channel #{roomcode}")
      send(self(), "new_user:" <> roomcode)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info("new_user:" <> roomcode , socket) do
    broadcast!(socket, "new_user", %{body: roomcode, msg: "A new user has joined the party!"})
    {:noreply, socket}
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
    Playlists.interact(payload)
    {:reply, {:ok, 200}, socket}
  end

  # updates the active status of this party
  @impl true
  def handle_in("update_active", %{"party_id" => id, "is_active" => active, "party_code" => roomcode}, socket) do
    case Parties.update_active(id, active) do
      {:ok, party} ->
        if active do
          broadcast! socket, "party_start", %{body: roomcode}
          {:noreply, socket}
        else
          broadcast! socket, "party_end", %{body: roomcode}
          {:noreply, socket}
        end
      {:error, msg} ->
        {:reply, {:error, %{error: msg}}, socket}
    end
  end

  # updates the given song to be played -> true
  @impl true
  def handle_in("queue_song", %{"is_song" => is_song, "party_id" => party_id, "track_id" => id, "track_uri" => uri, "host_id" => host_id, "party_code" => roomcode}, socket) do
    status = PlaybackController.queue(uri, host_id, party_id)
    # update song played only if a song_id is given (otherwise it is a request)
    # also only update if it was successfully added to the queue
    if is_song do
      song = Songs.get_song!(id)
      case status do
        # success
        204 ->
          Songs.update_played(id)
          broadcast! socket, "queued_song", %{body: roomcode, title: song.title, artist: song.artist}
          {:noreply, socket}
        _ ->
          {:reply, {:error, "Unable to add " <> song.title <> " to your playback queue."}, socket}
      end
    else
      req = Requests.get_request!(id)
      case status do
        204 ->
          Requests.update_played(id)
          broadcast! socket, "queued_song", %{body: roomcode, title: req.title, artist: req.artist}
          {:noreply, socket}
        _ ->
          {:reply, {:error, "Unable to add " <> req.title <> " to your playback queue."}, socket}
      end
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
