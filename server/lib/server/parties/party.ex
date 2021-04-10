defmodule Server.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parties" do
    field :name, :string
    field :description, :string
    field :roomcode, :string
    field :attendees, {:array, :integer}, default: []
    field :is_active, :boolean
    field :device_id, :string, default: ""

    belongs_to :host, Server.Users.User
    has_many :songs, Server.Songs.Song
    has_many :requests, Server.Requests.Request

    timestamps()
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:name, :roomcode, :description, :host_id, :attendees, :is_active])
    |> validate_required([:name, :roomcode, :description, :host_id])
  end
end
