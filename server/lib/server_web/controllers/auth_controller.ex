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

    redirect_uri = cond do
      System.get_env("MIX_ENV") == "prod" -> System.get_env("REACT_APP_PROD_URL")
      true -> System.get_env("REACT_APP_DEV_CLIENT_URL")
    end
    IO.inspect(redirect_uri)

    # redirect back to the front-end to complete the flo
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> redirect(external: "http://" <> redirect_uri <> "/?code=hidden")
  end

  # error: Access Denied
  def callback(conn, %{"error" => error}) do
    redirect_uri = cond do
      System.get_env("MIX_ENV") == "prod" -> System.get_env("REACT_APP_PROD_URL")
      true -> System.get_env("REACT_APP_DEV_CLIENT_URL")
    end
    IO.inspect(redirect_uri)

    # redirect back to the front-end to complete the flow
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> redirect(external: "http://" <> redirect_uri <> "/?error=#{error}")
  end

end
