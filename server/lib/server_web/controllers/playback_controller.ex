defmodule ServerWeb.PlaybackController do
  use ServerWeb, :controller
  alias Server.AuthTokens


  #def interact(conn, %{"user_id" => user_id, "action" => action}) do
  def interact(conn, data) do
    IO.inspect(data)
    user_id = data["host_id"];
    action = data["action"];
    IO.inspect(user_id)
    IO.inspect(action)
    token = AuthTokens.get_auth_token_by_user_id(user_id).token
    IO.inspect(token)
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


  # def interact(conn, %{"user_id" => user_id, "track_uri" => track_uri}) do
  #   token = Server.AuthTokens.get_auth_token_by_user_id(user_id)
  #   make_post("https://api.spotify.com/v1/me/player/queue", Jason.encode!(%{"uri": track_uri}), token)
  # end


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
