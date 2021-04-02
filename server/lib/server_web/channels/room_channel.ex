defmodule ServerWeb.RoomChannel do
  use ServerWeb, :channel

  """
  TODO:
  alias Multibulls.Game -> lib/multibulls/multibulls.ex
  alias Multibulls.GameServer -> lib/multibulls/multibulls_server.ex
  """

  alias Server.Game       # lib/server/server.ex
  alias Server.GameServer # lib/server/server_gameserver.ex

  @impl true
  def join("room:" <> lobbyname, payload, socket) do
    GameServer.start(lobbyname)
    socket = assign(socket, :roomname, lobbyname)
    room = GameServer.peek(lobbyname)
    {:ok, Game.view(game, ""), socket}
  end

  @impl true
  def handle_in("login", %{"name" => username}, socket) do
    socket = assign(socket, :username, username)
    currgame = GameServer.peek(socket.assigns[:roomname])
    {:reply, {:ok, Game.view(currgame, username)}, socket}
  end

  # TODO: Receive commands from socket.js
end
