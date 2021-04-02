defmodule ServerWeb.AuthView do
  use ServerWeb, :view
  alias ServerWeb.AuthView

  def render("index.json", %{authtokens: authtokens}) do
    %{data: render_many(authtokens, AuthView, "auth_token.json")}
  end

  def render("show.json", %{auth_token: auth_token}) do
    %{data: render_one(auth_token, AuthView, "auth_token.json")}
  end

  def render("auth_token.json", %{auth_token: auth_token}) do
    %{id: auth_token.id,
      token: auth_token.token}
  end
end
