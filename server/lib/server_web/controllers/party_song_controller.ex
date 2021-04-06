defmodule ServerWeb.PartySongController do
  use ServerWeb, :controller

  alias Server.PartiesSongs
  alias Server.PartiesSongs.PartySong

  def index(conn, _params) do
    partiessongs = PartiesSongs.list_partiessongs()
    render(conn, "index.html", partiessongs: partiessongs)
  end

  def new(conn, _params) do
    changeset = PartiesSongs.change_party_song(%PartySong{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"party_song" => party_song_params}) do
    case PartiesSongs.create_party_song(party_song_params) do
      {:ok, party_song} ->
        conn
        |> put_flash(:info, "Party song created successfully.")
        |> redirect(to: Routes.party_song_path(conn, :show, party_song))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    party_song = PartiesSongs.get_party_song!(id)
    render(conn, "show.html", party_song: party_song)
  end

  def edit(conn, %{"id" => id}) do
    party_song = PartiesSongs.get_party_song!(id)
    changeset = PartiesSongs.change_party_song(party_song)
    render(conn, "edit.html", party_song: party_song, changeset: changeset)
  end

  def update(conn, %{"id" => id, "party_song" => party_song_params}) do
    party_song = PartiesSongs.get_party_song!(id)

    case PartiesSongs.update_party_song(party_song, party_song_params) do
      {:ok, party_song} ->
        conn
        |> put_flash(:info, "Party song updated successfully.")
        |> redirect(to: Routes.party_song_path(conn, :show, party_song))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", party_song: party_song, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    party_song = PartiesSongs.get_party_song!(id)
    {:ok, _party_song} = PartiesSongs.delete_party_song(party_song)

    conn
    |> put_flash(:info, "Party song deleted successfully.")
    |> redirect(to: Routes.party_song_path(conn, :index))
  end
end
