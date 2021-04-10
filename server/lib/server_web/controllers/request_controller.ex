defmodule ServerWeb.RequestController do
  use ServerWeb, :controller

  alias Server.Requests
  alias Server.Requests.Request
  alias Server.AuthTokens
  alias Server.Users

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    requests = Requests.list_requests()
    render(conn, "index.json", requests: requests)
  end

  # search Spotify for request song and title, creates db_entry if found
  def search(conn, data) do
    IO.inspect("handling search")
    IO.inspect("data")
    IO.inspect(data)
    token = AuthTokens.get_public_token()
    IO.inspect("token")
    IO.inspect(token)
    title = data["title"]
    artist = data["artist"]
    query = String.replace(title <> " " <> artist, " ", "%20")
    IO.inspect(query)
    party_id = data["party_id"]
    user_id = data["user_id"]
    type = "track"
    market = "US"
    offset = 0
    limit = 1
    url = "https://api.spotify.com/v1/search?q=#{query}&type=#{type}&market=#{market}&limit=#{limit}&offset=#{offset}"
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}}",
    ]
    resp = HTTPoison.get!(url, headers)
    IO.inspect(resp)
    data = Jason.decode!(resp.body)
    IO.inspect("got data from search")
    IO.inspect(data)
    tracks = data["tracks"]["items"]
    IO.inspect(tracks)
    if (Enum.count(tracks) == 0) do
      IO.inspect("track not found, sending error")
      {:error, "#{title} by #{artist} not found on Spotify!"}
    else
      IO.inspect("track found, creating new request in DB")
      title = tracks
              |> Enum.at(0)
              |> Map.get("name")
      artist = tracks
               |> Enum.at(0)
               |> Map.get("artists")
               |> Enum.at(0)
               |> Map.get("name")
      track_uri = tracks
                  |> Enum.at(0)
                  |> Map.get("uri")

      if (request_exists(track_uri)) do
        {:error, "#{title} by #{artist} has already been requested by another user!"}
      else
        request = %{
          title: title,
          artist: artist,
          party_id: party_id,
          user_id: user_id,
          track_uri: track_uri,
          played: false
        }
        IO.inspect(request)
        Requests.create_request(request)
      end
    end
  end


  def request_exists(track_uri) do
    Requests.exists(track_uri)
  end


  # updates impact score of the given user
  def update_impact_score(data) do
    user_id = data["user_id"]
    Users.update_impact_score(user_id)
  end


  def create(conn, %{"request" => request_params}) do
    roomcode = request_params["party_code"]
    with {:ok, %Request{} = request} <- search(conn, request_params) do
      Users.update_impact_score(request_params["user_id"])
      success_msg = request.title <> " by " <> request.artist <> " was successfully requested."
      ServerWeb.Endpoint.broadcast!("party:" <> roomcode, "new_request", %{body: roomcode})
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:created, Jason.encode!(%{success: success_msg}))
    else
      {:error, error_msg} ->

        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:not_acceptable, Jason.encode!(%{error: error_msg}))
    end
  end

  def show(conn, %{"id" => id}) do
    request = Requests.get_request!(id)
    render(conn, "show.json", request: request)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Requests.get_request!(id)

    with {:ok, %Request{} = request} <- Requests.update_request(request, request_params) do
      render(conn, "show.json", request: request)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Requests.get_request!(id)

    with {:ok, %Request{}} <- Requests.delete_request(request) do
      send_resp(conn, :no_content, "")
    end
  end

end
