defmodule ServerWeb.RoomChannel do
  use ServerWeb, :channel

  alias Server.Game       # lib/server/server.ex
  alias Server.GameServer # lib/server/server_gameserver.ex
  alias ServerWeb         # lib/server_web.ex

  # TODO: FIGURE OUT WHAT VIEW TO USE

  @impl true
  def join("room:" <> lobbyname, payload, socket) do
    GameServer.start(lobbyname)
    socket = assign(socket, :roomname, lobbyname)
    room = GameServer.peek(lobbyname)
    {:ok, Game.view(room, ""), socket} # <- TODO Do we need to return the view here?
  end

  """
  @impl true
  def handle_in("login", %{"name" => username}, socket) do
    socket = assign(socket, :username, username)
    currgame = GameServer.peek(socket.assigns[:roomname])
    {:reply, {:ok, ServerWeb.view}, socket}
  end
  """
end
