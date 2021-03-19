defmodule TestSpotifyWeb.AuthController do
  use TestSpotifyWeb, :controller

  alias TestSpotify.Auth

  def authenticate(conn, _params) do
    # redirects to the spotify authorization endpoint
    #
    # https://accounts.spotify.com/authorize?
    # client_id=b6c7bd84e4724169b21570019ea15078
    # scope=user-modify-playback-state playlist-read-private
    # redirect_uri=http://localhost:4000
    # response_type=code
    redirect conn, external: Auth.authorize_url!([scope: "user-modify-playback-state playlist-read-private", response_type: "code"])
  end

  # our app's endpoint for the spotify authorization callback response
  def callback(conn, %{"code" => code}) do
    # receives an authorization code from the spotify server
    IO.inspect(code)

    # sends the code back to spotify in exchange for a user token
    token = Auth.get_token!(code: code).token |> Map.drop([:__struct__, :__meta__])
    IO.inspect(token)

    # return to the homepage
    conn
    |> redirect(to: "/")

    # conn
    # |> put_session(:user_id, user.id)
    # |> redirect(to: "/welcome")
  end

end
