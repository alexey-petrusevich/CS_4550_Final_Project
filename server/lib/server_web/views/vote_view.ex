defmodule ServerWeb.VoteView do
  use ServerWeb, :view
  alias ServerWeb.VoteView

  def render("index.json", %{votes: votes}) do
    %{data: render_many(votes, VoteView, "vote.json")}
  end

  def render("show.json", %{vote: vote}) do
    %{data: render_one(vote, VoteView, "vote.json")}
  end

  def render("vote.json", %{vote: vote}) do
    %{id: vote.id,
      value: vote.value,
      user_id: vote.user_id,
      song_id: vote.song_id}
  end
end
