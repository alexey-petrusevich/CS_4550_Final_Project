defmodule ServerWeb.SongView do
  use ServerWeb, :view
  alias ServerWeb.SongView

  def render("index.json", %{songs: songs}) do
    %{data: render_many(songs, SongView, "song.json")}
  end

  def render("show.json", %{song: song}) do
    %{data: render_one(song, SongView, "song.json")}
  end

  def render("song.json", %{song: song}) do
    %{id: song.id,
      track_uri: song.track_uri,
      title: song.title,
      artist: song.artist,
      genre: song.genre}
  end
end
