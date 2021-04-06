defmodule ServerWeb.PlaybackController do
  use ServerWeb, :controller
  alias Server.AuthTokens


  def interact(conn, %{"user_id" => user_id, "action" => action}) do
    token = AuthTokens.get_auth_token_by_user_id(user_id)
    track_uri = options.track_uri
    case action do
      "play" ->
        make_put("https://api.spotify.com/v1/me/player/play", token)
      "pause" ->
        make_put("https://api.spotify.com/v1/me/player/pause", token)
      "skip" ->
        make_post("https://api.spotify.com/v1/me/player/next", "", token)
    end
  end


  def interact(conn, %{"user_id" => user_id, "action" => action, "track_uri" => track_uri}) do
    token = Server.AuthTokens.get_auth_token_by_user_id(user_id)
    make_post("https://api.spotify.com/v1/me/player/queue", Jason.encode!(%{"uri": track_uri}), token)
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


  def make_post(url, body, token) do
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.post!(url, body, headers)
  end


end
