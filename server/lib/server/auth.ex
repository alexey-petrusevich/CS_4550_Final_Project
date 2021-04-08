defmodule Server.AuthTokens do
  @moduledoc """
  The AuthTokens context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo

  alias Server.AuthTokens.AuthToken

  # gets a list of all auth tokens
  def list_authtokens do
    Repo.all(AuthToken)
  end

  # gets the auth token given by the id
  def get_auth_token!(id), do: Repo.get!(AuthToken, id)

  # gets the auth token of the given host id, if it exists
  def get_auth_token_by_user_id(user_id) do
    Repo.get_by(AuthToken, user_id: user_id)
  end

  # creates a new authtoken entry or updates an existing one
  def create_auth_token(attrs \\ %{}) do
    user_id = Map.get(attrs, "user_id")
    # check if auth token already exists
    auth_token = get_auth_token_by_user_id(user_id)
    if auth_token do
      update_auth_token(auth_token, attrs)
    else
      %AuthToken{}
      |> AuthToken.changeset(attrs)
      |> Repo.insert()
    end
  end


  def update_auth_token(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> AuthToken.changeset(attrs)
    |> Repo.update()
  end


  def delete_auth_token(%AuthToken{} = auth_token) do
    Repo.delete(auth_token)
  end

  #---------------------OAUTH----------------------

  def token_for_code(code) do
    # TODO: move to env variable
    client_id = "b6c7bd84e4724169b21570019ea15078"
    client_secret = "d3acd431a7a44f739e3a4b2b184bb4fd"
    #TODO client_secret = System.get_env("SPOTIFY_CLIENT_SECRET")
    auth_payload = Base.encode64("#{client_id}:#{client_secret}")

    # Spotify API authentication endpoint requirements
    url = "https://accounts.spotify.com/api/token"
    body = "grant_type=authorization_code&code=#{code}&redirect_uri=http://localhost:4000/api/v1/auth/callback"
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic #{auth_payload}"}
    ]


    # sends the post request, decodes response data, and returns the auth token
    resp = HTTPoison.post!(url, body, headers)
    data = Jason.decode!(resp.body)
    data["access_token"]
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


end
