defmodule Server.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :value, :integer, default: 0
    belongs_to :song, Server.Songs.Song
    belongs_to :user, Server.Users.User

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:value, :song_id, :user_id])
    |> validate_required([:value, :song_id, :user_id])
  end
end
