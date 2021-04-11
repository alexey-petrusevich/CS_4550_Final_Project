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
#    IO.inspect(System.get_env("MIX_ENV"))
#    redirect_uri = cond do
#      System.get_env("MIX_ENV") == "prod" -> System.get_env("REACT_APP_PROD_URL")
#      true -> System.get_env("REACT_APP_DEV_SERVER_URL")
#    end
#    IO.inspect(redirect_uri)

#    client_id = System.get_env("SPOTIFY_CLIENT_ID")
#    client_secret = System.get_env("SPOTIFY_CLIENT_SECRET")
    client_id = "16d93cc5896d4cc58a6f5fa4d0a946e8"
    client_secret = "4d5f059a1eea4ef8985c0eea24afffda"
#    IO.inspect(client_id)
#    IO.inspect(client_secret)

    redirect_uri = "spotifyparty.quickjohnny.art"
    auth_payload = Base.encode64("#{client_id}:#{client_secret}")

    # Spotify API authentication endpoint requirements
    url = "https://accounts.spotify.com/api/token"
    body = "grant_type=authorization_code&code=#{code}&redirect_uri=http://#{redirect_uri}/api/v1/auth/callback"
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic #{auth_payload}"}
    ]

    # sends the post request, decodes response data, and returns the auth token
    resp = HTTPoison.post!(url, body, headers)
    data = Jason.decode!(resp.body)
    token = data["access_token"]
    IO.inspect(token)
    token
  end

  # returns public token with no scope
  def get_public_token() do
#    client_id = System.get_env("SPOTIFY_CLIENT_ID")
#    client_secret = System.get_env("SPOTIFY_CLIENT_SECRET")
    client_id = "16d93cc5896d4cc58a6f5fa4d0a946e8"
    client_secret = "4d5f059a1eea4ef8985c0eea24afffda"
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
