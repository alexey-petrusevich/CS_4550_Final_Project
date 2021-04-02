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

    # server uri: http://localhost:4000/api/v1/auth/callback
    get "/auth/callback", AuthController, :callback

  end
end
