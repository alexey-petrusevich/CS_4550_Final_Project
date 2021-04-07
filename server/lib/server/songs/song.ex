defmodule Server.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :artist, :string
    field :title, :string
    field :track_uri, :string
    field :energy, :float
    has_many :votes, Server.Votes.Vote
    belongs_to :party, Server.Parties.Party
    many_to_many(:parties, Server.Parties.Party, join_through: Server.PartiesSongs)

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:track_uri, :title, :artist, :party_id, :genre, :energy])
    |> validate_required([:track_uri, :title, :artist, :party_id, :genre])
  end
end
