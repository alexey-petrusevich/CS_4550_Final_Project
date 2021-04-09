defmodule ServerWeb.VoteController do
  use ServerWeb, :controller

  alias Server.Votes
  alias Server.Votes.Vote
  alias Server.Users

  action_fallback ServerWeb.FallbackController


  # updates (creates) a vote for the given song
  def vote(conn, data) do
    # user_id, song_id, value
    user_id = data["user_id"]
    song_id = data["song_id"]
    value = data["value"]
    # check if entry already exists
    vote = Votes.get_vote_by_song_id!(song_id)
    if (vote) do
      vote = %{vote | value: value}
      Votes.update_vote(vote)
      conn
      |> send_resp(:reset_content, Jason.encode!(%{vote: vote}))
    else
      Users.update_impact_score(user_id)
      newVote = %{
        user_id: user_id,
        song_id: song_id,
        value: value
      }
      Votes.create_vote(newVote)
      conn
      |> send_resp(:created, Jason.encode!(%{vote: vote}))
    end
  end

  # TODO this is for testing only; remove once tested
  def handle_vote(data) do
    # user_id, song_id, value
    user_id = data["user_id"]
    song_id = data["song_id"]
    value = data["value"]
    # check if entry already exists
    vote = Votes.get_vote_by_song_id(song_id)
    if (vote) do
      vote = %{vote | value: value}
      Votes.update_vote(vote)
    else
      newVote = %{
        user_id: user_id,
        song_id: song_id,
        value: value
      }
      IO.inspect("creating vote")
      Votes.create_vote(newVote)
    end
  end

end
