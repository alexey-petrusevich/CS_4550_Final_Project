defmodule Server.AuthTokens.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authtokens" do
    field :token, :string
    belongs_to :user, Server.Users.User

    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
  end
end
