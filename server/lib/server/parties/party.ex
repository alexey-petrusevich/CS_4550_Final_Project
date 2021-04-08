defmodule Server.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parties" do
    field :name, :string
    field :description, :string
    field :roomcode, :string
    field :attendees, {:array, :integer}, default: []
    field :is_active, :boolean

    belongs_to :host, Server.Users.User
    has_many :requests, Server.Requests.Request
    has_many :songs, Server.Songs.Song

    timestamps()
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:name, :roomcode, :description, :host_id, :attendees, :requests, :songs, :is_active])
    |> validate_required([:name, :roomcode, :description, :host_id, :is_active])
  end
end
