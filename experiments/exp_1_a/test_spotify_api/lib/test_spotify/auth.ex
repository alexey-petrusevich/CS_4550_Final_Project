defmodule TestSpotify.Auth do
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  # endpoints for spotify's user authorization and access_tokens
  @config [
    strategy: __MODULE__,
    site: "https://api.spotify.com/v1",
    authorize_url: "https://accounts.spotify.com/authorize",
    token_url: "https://accounts.spotify.com/api/token",
  ]

  def new do
    Application.get_env(:test_spotify, __MODULE__)
    |> Keyword.merge(@config)
    |> OAuth2.Client.new()
  end

  def new(token) do
    %{new() | token: OAuth2.AccessToken.new(token) }
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(new(), params, headers)
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(new(), params)
  end
end
