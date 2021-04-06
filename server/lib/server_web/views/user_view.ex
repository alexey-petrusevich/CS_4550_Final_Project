defmodule ServerWeb.UserView do
  use ServerWeb, :view
  alias ServerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "simpleUser.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      password_hash: user.password_hash,
      impact_score: user.impact_score,
      top_arists: user.top_arists,
      top_genres: user.top_genres,
      energy: user.energy}
  end

  def render("simpleUser.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      password_hash: user.password_hash,
      impact_score: user.impact_score}
  end

end
