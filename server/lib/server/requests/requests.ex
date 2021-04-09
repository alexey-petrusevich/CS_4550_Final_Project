defmodule Server.Requests.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :artist, :string
    field :title, :string
    field :track_uri, :string
    field :played, :boolean

    belongs_to :party, Server.Parties.Party
    belongs_to :user, Server.Users.User

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:title, :artist, :track_uri, :played, :party_id, :user_id])
    |> validate_required([:title, :artist, :track_uri, :played, :party_id, :user_id])
  end
end
