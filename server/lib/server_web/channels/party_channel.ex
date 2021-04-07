defmodule ServerWeb.PartyChannel do
  use ServerWeb, :channel

  alias Server.Playlists

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

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
