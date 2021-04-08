defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ServerWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/parties", PartyController, except: [:new, :edit]
    resources "/songs", SongController, except: [:new, :edit]
    resources "/votes", VoteController, except: [:new, :edit]
    resources "/requests", RequestController, except: [:new, :edit]
    resources "/session", SessionController, only: [:create]

    # for joining parties (eventually in channel)?
    post "/parties/join", PartyController, :join

    # server uri: http://localhost:4000/api/v1/auth/callback
    get "/auth/callback", AuthController, :callback

    # this endpoint expects post params: user_id, party_id, playlist_uri
    post "/playlist", PlaylistController, :interact

    # this endpoint has overloaded methods:
    # - user_id, action
    # - user_id, action, track_id
    post "/playback", PlaybackController, :interact


    # make API calls for requests
    # party id, user_id, songs title, artist
    # put it in requests contorller
    # update - title and the artists with the result of the call
    # write track uri
    post "/search", RequestController, :search

    # takes in user_id, song_id, value
    post "/vote", VoteController, :vote

  end
end
