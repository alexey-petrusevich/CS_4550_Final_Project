defmodule Server.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password_hash, :string
    field :username, :string
    field :impact_score, :integer

    has_many :parties, Server.Parties.Party
    has_many :requests, Server.Requests.Request
    has_many :votes, Server.Votes.Vote


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password_hash, :impact_score])
    |> validate_required([:username, :password_hash])
  end
end
