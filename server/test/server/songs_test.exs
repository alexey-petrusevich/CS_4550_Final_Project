defmodule Server.SongsTest do
  use Server.DataCase

  alias Server.Songs

  describe "songs" do
    alias Server.Songs.Song

    @valid_attrs %{artist: "some artist", genre: "some genre", title: "some title", track_uri: "some track_uri"}
    @update_attrs %{artist: "some updated artist", genre: "some updated genre", title: "some updated title", track_uri: "some updated track_uri"}
    @invalid_attrs %{artist: nil, genre: nil, title: nil, track_uri: nil}

    def song_fixture(attrs \\ %{}) do
      {:ok, song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Songs.create_song()

      song
    end

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert Songs.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Songs.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      assert {:ok, %Song{} = song} = Songs.create_song(@valid_attrs)
      assert song.artist == "some artist"
      assert song.genre == "some genre"
      assert song.title == "some title"
      assert song.track_uri == "some track_uri"
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Songs.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Songs.update_song(song, @update_attrs)
      assert song.artist == "some updated artist"
      assert song.genre == "some updated genre"
      assert song.title == "some updated title"
      assert song.track_uri == "some updated track_uri"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Songs.update_song(song, @invalid_attrs)
      assert song == Songs.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Songs.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Songs.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Songs.change_song(song)
    end
  end
end
