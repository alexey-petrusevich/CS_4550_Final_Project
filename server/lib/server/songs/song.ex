defmodule Server.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :artist, :string
    field :artist_uri, :string
    field :title, :string
    field :genre, :string
    field :track_uri, :string
    field :energy, :float
    field :danceability, :float
    field :loudness, :float
    field :valence, :float
    field :played, :boolean
    has_many :votes, Server.Votes.Vote
    belongs_to :party, Server.Parties.Party

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:track_uri, :title, :artist, :party_id, :genre, :energy, :danceability, :loudness, :valence, :played])
    |> validate_required([:track_uri, :title, :artist, :party_id, :genre, :played])
  end
end
