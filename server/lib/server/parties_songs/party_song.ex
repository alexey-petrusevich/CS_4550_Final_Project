defmodule Server.PartiesSongs.PartySong do
  use Ecto.Schema
  import Ecto.Changeset

  #@primary_key false
  schema "partiessongs" do
    belongs_to :song, Server.Songs.Song
    belongs_to :party, Server.Parties.Party
  end

  @doc false
  def changeset(party_song, attrs) do
    party_song
    |> cast(attrs, [:song_id, :party_id])
    |> validate_required([:song_id, :party_id])
  end
end
