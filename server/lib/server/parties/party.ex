defmodule Server.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parties" do
    field :description, :string
    field :roomname, :string

    belongs_to :host, Server.Users.User
    has_many :attendees, Server.Users.User
    has_many :songs, Server.Songs.Song
    has_many :requests, Server.Requests.Request

    timestamps()
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:roomname, :description, :host_id])
    |> validate_required([:roomname, :host_id])
  end
end
