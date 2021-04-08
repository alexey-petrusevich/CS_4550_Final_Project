defmodule ServerWeb.PlaybackController do
  use ServerWeb, :controller
  alias Server.AuthTokens

  def interact(conn, data) do
    user_id = data["host_id"];
    action = data["action"];
    token = AuthTokens.get_auth_token_by_user_id(user_id).token
    case action do
      "play" ->
        make_put("https://api.spotify.com/v1/me/player/play", token)
      "pause" ->
        make_put("https://api.spotify.com/v1/me/player/pause", token)
      "skip" ->
        make_post("https://api.spotify.com/v1/me/player/next", token)
      "queue" ->
        track_uri = data["track_uri"];
        make_post("https://api.spotify.com/v1/me/player/queue?uri=" <> track_uri, token)
    end
    # TODO: fix response
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(:created, Jason.encode!(%{}))
  end

  def make_put(url, token) do
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.put!(url, body, headers)
  end

  def make_post(url, token) do
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.post!(url, body, headers)
  end

end
