defmodule Server.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :downvotes, :integer, default: 0
    field :upvotes, :integer, default: 0
    belongs_to :song, Server.Songs.Song
    belongs_to :user, Server.Users.User

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:upvotes, :downvotes, :song_id, :user_id])
    |> validate_required([:upvotes, :downvotes, :song_id, :user_id])
  end
end
