defmodule ServerWeb.PlaybackController do
  use ServerWeb, :controller


  def play(conn, %{"user_id" => user_id, "token" => token}) do
    url = "https://api.spotify.com/v1/me/player/play"
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.put!(url, body, headers)
  end


  def pause(conn, %{"user_id" => user_id, "token" => token}) do
    url = "https://api.spotify.com/v1/me/player/pause"
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.put!(url, body, headers)
  end


  def skip(conn, %{"user_id" => user_id, "token" => token}) do
    url = "https://api.spotify.com/v1/me/player/next"
    body = ""
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.post!(url, body, headers)
  end


  def add_to_queue(conn, %{"user_id" => user_id, "token" => token, "track_uri" => track_uri}) do
    url = "https://api.spotify.com/v1/me/player/queue"
    body = Jason.encode!(%{"uri": track_uri})
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}"
    ]
    HTTPoison.post!(url, body, headers)
  end


end
