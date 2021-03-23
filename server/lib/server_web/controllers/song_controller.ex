defmodule ServerWeb.SongController do
  use ServerWeb, :controller

  alias Server.Songs
  alias Server.Songs.Song

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    songs = Songs.list_songs()
    render(conn, "index.json", songs: songs)
  end

  def create(conn, %{"song" => song_params}) do
    with {:ok, %Song{} = song} <- Songs.create_song(song_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.song_path(conn, :show, song))
      |> render("show.json", song: song)
    end
  end

  def show(conn, %{"id" => id}) do
    song = Songs.get_song!(id)
    render(conn, "show.json", song: song)
  end

  def update(conn, %{"id" => id, "song" => song_params}) do
    song = Songs.get_song!(id)

    with {:ok, %Song{} = song} <- Songs.update_song(song, song_params) do
      render(conn, "show.json", song: song)
    end
  end

  def delete(conn, %{"id" => id}) do
    song = Songs.get_song!(id)

    with {:ok, %Song{}} <- Songs.delete_song(song) do
      send_resp(conn, :no_content, "")
    end
  end
end
