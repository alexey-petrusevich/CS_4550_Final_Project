defmodule TestSpotifyWeb.PageController do
  use TestSpotifyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
