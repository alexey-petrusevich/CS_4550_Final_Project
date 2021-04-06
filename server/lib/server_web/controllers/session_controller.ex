defmodule ServerWeb.SessionController do
  use ServerWeb, :controller

  alias Server.Users

  def create(conn, %{"username" => username, "password" => pass}) do
    # authenticates the user
    user = Users.authenticate(username, pass)

    if user do
      # password is valid; form a session Object with a csrf token
      session = %{
        user_id: user.id, username: user.username,
        token: Phoenix.Token.sign(conn, "user_id", user.id)
      }
      # send the session object to the user
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:created, Jason.encode!(%{session: session}))
    else
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(
        %{error: "Login failed: Incorrect username or password"}))
    end
  end
end
