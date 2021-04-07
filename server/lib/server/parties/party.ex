defmodule Server.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parties" do
    field :name, :string
    field :description, :string
    field :roomcode, :string
    field :attendees, {:array, :integer}, default: []
    field :is_active, :boolean 
    # field :songs, {:array, :integer}, default: []

    belongs_to :host, Server.Users.User
    has_many :requests, Server.Requests.Request
    many_to_many(:songs, Server.Songs.Song, join_through: Server.PartiesSongs)

    timestamps()
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:name, :roomcode, :description, :host_id, :attendees, :requests, :songs])
    |> validate_required([:name, :roomcode, :description, :host_id])
  end
end
