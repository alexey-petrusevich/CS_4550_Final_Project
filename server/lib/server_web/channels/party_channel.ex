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

  def handle_info(:after_join, socket) do
    broadcast!(socket, "new_user", %{body: "A new user has joined the party!"})
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
  def handle_in("update_active", %{"party_id" => id, "is_active" => active}, socket) do
    case Parties.update_active(id, active) do
      {:ok, party} ->
        if active do
          IO.inspect("Sending party start message")
          broadcast! socket, "party_start", %{body: id}
          {:noreply, socket}
        else
          IO.inspect("Sending party end message")
          broadcast! socket, "party_end", %{body: id}
          {:noreply, socket}
        end
      {:error, cset} ->
        {:reply, {:error, %{error: "Error starting this party. Plese try again."}}, socket}
    end
  end

  # updates the given song to be played -> true
  @impl true
  def handle_in("queue_song", %{"is_song" => song, "track_id" => id, "track_uri" => uri, "host_id" => host_id}, socket) do
    song = Songs.get_song!(id)
    status = PlaybackController.queue(uri, host_id)
    # update song played only if a song_id is given (otherwise it is a request)
    # also only update if it was successfully added to the queue
    IO.inspect(status)
    case status do
      # success
      204 ->
        if song do
          Songs.update_played(id)
        else # request
          Requests.update_played(id)
        end
        broadcast! socket, "queued_song", %{body: id}
        {:noreply, socket}
      _ ->
        {:reply, {:error, "Unable to add " <> song.title <> " to your playback queue."}, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
