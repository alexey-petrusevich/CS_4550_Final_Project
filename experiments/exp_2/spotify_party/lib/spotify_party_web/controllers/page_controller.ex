defmodule SpotifyPartyWeb.PageController do
  use SpotifyPartyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
