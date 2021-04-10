defmodule ServerWeb.VoteController do
  use ServerWeb, :controller

  alias Server.Votes
  alias Server.Votes.Vote
  alias Server.Users

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    votes = Votes.list_votes()
    render(conn, "index.json", votes: votes)
  end


  # updates (creates) a vote for the given song
  def vote(conn, %{"vote" => vote}) do
    # user_id, song_id, value
    user_id = vote["user_id"]
    song_id = vote["song_id"]
    value = vote["value"]
    # check if entry already exists
    vote = Votes.get_vote_by_song_and_user(song_id, user_id)
    if (vote) do
      vote = Votes.update_vote(vote.id, value)
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(200, Jason.encode!(%{}))
    else
      Users.update_impact_score(user_id)
      newVote = %{
        user_id: user_id,
        song_id: song_id,
        value: value
      }
      Votes.create_vote(newVote)
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(200, Jason.encode!(%{}))
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
