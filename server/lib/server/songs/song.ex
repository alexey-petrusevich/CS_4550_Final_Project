defmodule Server.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :artist, :string
    field :genre, :string
    field :title, :string
    field :track_uri, :string

    has_many :votes, Server.Votes.Vote
    many_to_many(:parties, Server.Parties.Party, join_through: Server.PartiesSongs)

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:track_uri, :title, :artist, :genre])
    |> validate_required([:track_uri, :title, :artist, :genre])
  end
end
