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
        |> handle_response(conn, :ok, "Success", "Failed to play")
      "pause" ->
        make_put("https://api.spotify.com/v1/me/player/pause", token)
        |> handle_response(conn, :ok, "Success", "Failed to pause")
      "skip" ->
        make_post("https://api.spotify.com/v1/me/player/next", token)
        |> handle_response(conn, :ok, "Success", "Failed to skip")
      "queue" ->
        track_uri = data["track_uri"];
        make_post("https://api.spotify.com/v1/me/player/queue?uri=" <> track_uri, token)
        |> handle_response(conn, :created, "Success", "Failed to enqueue track")
    end
  end

  def handle_response(response, conn, ok_code, success_msg, error_msg) do
    code = elem(response, 0)
    data = elem(response, 1) # error msg if code is error
    case code do
      :ok ->
        handle_ok(conn, data, ok_code, success_msg)
      :error ->
        handle_error(conn, data, error_msg)
    end
  end


  def handle_ok(conn, data, ok_code, msg) do
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(ok_code, Jason.encode!(%{success: msg}))
  end


  def handle_error(conn, data, msg) do
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(
         :error,
         Jason.encode!(
           %{error: msg}
         )
       )
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
