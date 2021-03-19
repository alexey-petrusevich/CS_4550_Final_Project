defmodule SpotifyAPITest do

  def get_oauth_token do
    "BQB4QLYhKD-_v3Aj_jZ2gtdLggeBhQiIioQm0YnuaXPMxfZDKd8DeLEbNwhZvz9Nsg_NC96O2_QhJoBXeqmx4ZUzeNIMcZUG1r3u1tn49-NuBeQfvEr5MFKcUgMChtVTMRru0COMZiw-hWyZI9NAy7v6mxO6avwWkirfgaWelLnWdkoY"
  end

  # authenticates the registered app user and receives a token for making requests
  # to public information on Spotify
  def authenticate do
    # generated through Spotify for Developers
    client_id = System.get_env("SPOTIFY_CLIENT_ID")
    client_secret = System.get_env("SPOTIFY_CLIENT_SECRET")
    auth_payload = Base.encode64("#{client_id}:#{client_secret}")

    # Spotify API authentication endpoint requirements
    url = "https://accounts.spotify.com/api/token"
    body = "grant_type=client_credentials"
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic #{auth_payload}"}
    ]

    # sends the post request, decodes response data, and returns the auth token
    resp = HTTPoison.post!(url, body, headers)
    data = Jason.decode!(resp.body)
    data["access_token"]
  end

  # gets the top genres of music in the US via their API, uses the general auth token
  # from the above authenticate function to access public spotify data
  def get_genres(token) do

    # Spotify API US music genre endpoint
    url = "https://api.spotify.com/v1/browse/categories?local=sv_US"
    headers = [
      {"Authorization", "Bearer #{token}"}
    ]

    # sends the get request, decodes response data, and returns a list of popular music genres in the US
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    data["categories"]["items"] |> Enum.map(fn g -> g["name"] end)
  end

  def get_user_playlists do
    # Spotify API authentication endpoint docs
    url = "https://api.spotify.com/v1/me/playlists?limit=10"
    headers = [
      {"Authorization", "Bearer #{get_oauth_token()}"}
    ]

    # sends the get request, decodes response data, and returns a list of the most recent user playlists
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    data["items"] |> Enum.map(fn pl -> %{name: pl["name"], id: pl["id"]} end)
  end

  def get_playlist_songs(playlist_hash) do
    # Spotify API authentication endpoint docs
    url = "https://api.spotify.com/v1/playlists/#{playlist_hash}/tracks"
    headers = [
      {"Authorization", "Bearer #{get_oauth_token()}"}
    ]

    # sends the get request, decodes response data, and returns a list of songs on the given playlist
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    data["items"] |> Enum.map(fn tr -> %{title: tr["track"]["name"], id: tr["track"]["id"]} end)
  end

  def get_user_name do
    # Spotify API authentication endpoint docs
    url = "https://api.spotify.com/v1/me"
    headers = [
      {"Authorization", "Bearer #{get_oauth_token()}"}
    ]

    # sends the get request, decodes response data, and returns the user's name
    resp = HTTPoison.get!(url, headers)
    data = Jason.decode!(resp.body)
    data["display_name"]
  end
end
