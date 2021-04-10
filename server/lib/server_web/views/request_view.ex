defmodule ServerWeb.RequestView do
  use ServerWeb, :view
  alias ServerWeb.RequestView
  alias ServerWeb.UserView

  alias Server.Repo

  def render("index.json", %{requests: requests}) do
    %{data: render_many(requests, RequestView, "request.json")}
  end

  def render("show.json", %{request: request}) do
    %{data: render_one(request, RequestView, "request.json")}
  end

  def render("request.json", %{request: request}) do
    request = request
    |> Repo.preload(:user)
    
    %{id: request.id,
      title: request.title,
      artist: request.artist,
      track_uri: request.track_uri,
      played: request.played,
      user: render_one(request.user, UserView, "simpleUser.json")}
  end
end
