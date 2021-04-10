defmodule ServerWeb.AuthController do
  use ServerWeb, :controller

  alias Server.AuthTokens
  alias Server.AuthTokens.AuthToken

  # our app's endpoint for the spotify authorization callback response
  # code --> the auth flow code given by Spotify
  # user_id --> the id of the user who is getting auth'd
  def callback(conn, %{"code" => code, "state" => user_id}) do

    # exchanges the auth code for a access_token
    token = AuthTokens.token_for_code(code)

    auth_params = %{}
    |> Map.put("token", token)
    |> Map.put("user_id", user_id |> String.to_integer())
    AuthTokens.create_auth_token(auth_params)

    # redirect back to the front-end to complete the flow
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> redirect(external: "http://localhost:3000/?code=hidden")
  end

  # error: Access Denied
  def callback(conn, %{"error" => error}) do
    # redirect back to the front-end to complete the flow
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> redirect(external: "http://localhost:3000/?error=#{error}")
  end

end
