defmodule ServerWeb.SongView do
  use ServerWeb, :view
  alias ServerWeb.SongView
  alias ServerWeb.VoteView

  alias Server.Repo

  def render("index.json", %{songs: songs}) do
    %{data: render_many(songs, SongView, "song.json")}
  end

  def render("show.json", %{song: song}) do
    %{data: render_one(song, SongView, "song.json")}
  end

  def render("song.json", %{song: song}) do
    song = song
    |> Repo.preload(:votes)
    %{id: song.id,
      track_uri: song.track_uri,
      title: song.title,
      artist: song.artist,
      party_id: song.party_id,
      genre: song.genre,
      energy: song.energy,
      played: song.played,
      votes: render_many(song.votes, VoteView, "vote.json")}
  end
end
