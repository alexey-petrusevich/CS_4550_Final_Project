defmodule ServerWeb.PlaybackController do
  use ServerWeb, :controller
  alias Server.AuthTokens
  alias Server.Parties

  def interact(conn, data) do
    user_id = data["host_id"];
    party_id = data["party_id"];
    action = data["action"];
    token = AuthTokens.get_auth_token_by_user_id(user_id).token
    device_id = Parties.get_device_id!(party_id)
    case action do
      "play" ->
        make_put("https://api.spotify.com/v1/me/player/play?device_id=#{device_id}", token)
        |> handle_response(conn, "Successfully played your active song.", "Failed to start playback. Playback may already be active.")
      "pause" ->
        make_put("https://api.spotify.com/v1/me/player/pause?device_id=#{device_id}", token)
        |> handle_response(conn, "Successfully paused your active song.", "Failed to pause playback. Playback may already be paused.")
      "skip" ->
        make_post("https://api.spotify.com/v1/me/player/next?device_id=#{device_id}", token)
        |> handle_response(conn, "Successfully skipped playback to the next song.", "Failed to skip your active song.")
    end
  end

  # had to move this out of an API call and rather a channel call
  def queue(uri, host_id, party_id) do
      token = AuthTokens.get_auth_token_by_user_id(host_id).token
      device_id = Parties.get_device_id!(party_id)
      resp = make_post("https://api.spotify.com/v1/me/player/queue?uri=" <> uri <> "&device_id=" <> device_id, token)
      resp.status_code
  end

  def handle_response(response, conn, success_msg, failure_msg) do
    status_code = response.status_code
    message = if response.body !== "" do
      Map.get(Jason.decode!(response.body), "error") |> Map.get("message")
    end  # error msg if code is error
    case status_code do
      # success
      204 ->
        handle_ok(conn, success_msg)
      # no device found
      404 ->
        handle_error(conn, message)
      # other failure
      _ ->
        handle_error(conn, failure_msg)
    end
  end


  def handle_ok(conn, msg) do
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(:ok, Jason.encode!(%{success: msg}))
  end


  def handle_error(conn, msg) do
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(:bad_request, Jason.encode!(%{error: msg}))
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
