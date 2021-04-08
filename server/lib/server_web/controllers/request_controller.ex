defmodule ServerWeb.RequestController do
  use ServerWeb, :controller

  alias Server.Requests
  alias Server.Requests.Request

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    requests = Requests.list_requests()
    render(conn, "index.json", requests: requests)
  end


  # returns public token with no scope
  def get_public_token() do
    # TODO: replace with getting from the environment
    #client_id = "get from env"
    #client_secret = "get from env"
    client_id = "b6c7bd84e4724169b21570019ea15078"
    client_secret = "d3acd431a7a44f739e3a4b2b184bb4fd"
    auth_payload = Base.encode64("#{client_id}:#{client_secret}")
    url = "https://accounts.spotify.com/api/token"
    body = "grant_type=client_credentials"
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic #{auth_payload}"}
    ]
    # sends the post request, decodes response data, and returns the auth token
    resp = HTTPoison.post!(url, body, headers)
    data = Jason.decode!(resp.body)
    data["access_token"] # returns public access token with no scope
  end


  # TODO: implement search for a song
  def search(conn, data) do
    IO.inspect("handling search")
    IO.insect("data")
    IO.inspect(data)
    token = get_public_token()
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


  def create(conn, %{"request" => request_params}) do
    with {:ok, %Request{} = request} <- Requests.create_request(request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.request_path(conn, :show, request))
      |> render("show.json", request: request)
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
