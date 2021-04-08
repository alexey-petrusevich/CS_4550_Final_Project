defmodule ServerWeb.RequestController do
  use ServerWeb, :controller

  alias Server.Requests
  alias Server.Requests.Request
  alias Server.AuthTokens

  action_fallback ServerWeb.FallbackController

  def search(conn, data) do
    IO.inspect("handling search")
    IO.insect("data")
    IO.inspect(data)
    token = AuthTokens.get_public_token()
    IO.inspect("token")
    IO.inspect(token)
    query = data["query"]
    party_id = data["party_id"]
    user_id = data["user_id"]
    type = "track"
    market = "US"
    limit = 1
    url = "https://api.spotify.com/v1/search?q=#{query}&type=#{type}&market=#{market}&limit=#{limit}"
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    IO.inspect("got data from search")
    IO.inspect(data)
    tracks = data["items"]
    if (length(tracks) == 0) do
      IO.inspect("track not found, sending error")
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(
           :not_found,
           Jason.encode!(
             %{error: "Track not found"}
           )
         )
    else
    IO.inspect("track found, creating new request in DB")
      title = tracks[0]["name"]
      artist = tracks[0]["artists"][0]["name"]
      request = %{
        title: title,
        artist: artist,
        party_id: party_id,
        user_id: user_id
      }
      Requests.create_request(request)
      IO.inspect("created DB entry, sending request back the caller")
      IO.inspect("request")
      IO.inspect(request)
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:created, Jason.encode!(request))
    end
  end

end
