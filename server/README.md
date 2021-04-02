# Auth Flow
- new DB table ```authtokens``` for storing access tokens
   - ```:token``` and ```:user_id``` field

- ```Link with Spotify``` button on the party host view
- Opens a new window with the Spotify Auth page; user can approve scope
    - request is sent with the requesting user's id (host id) as state
- On return, callback is [server_domain]/ap1/v1/auth/callback
    - server receives the auth code and the user id
    - exchanges auth code for an access token
    - creates or updates DD table ```authtokens``` with new access_token for user_id

# Server

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
