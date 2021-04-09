defmodule Server.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password_hash, :string
    field :username, :string
    field :name, :string
    field :email, :string
    field :impact_score, :integer

    has_many :parties, Server.Parties.Party
    has_many :requests, Server.Requests.Request
    has_many :votes, Server.Votes.Vote

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :email, :impact_score])
    |> add_password_hash(attrs["password"])
    |> validate_required([:username, :password_hash, :name, :email])
  end

  # from Nat Tuck's lecture on password hashes
  def add_password_hash(cset, nil) do
    cset
  end

  def add_password_hash(cset, password) do
    change(cset, Argon2.add_hash(password))
  end
end
