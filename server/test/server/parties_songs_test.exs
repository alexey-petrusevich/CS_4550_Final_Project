defmodule Server.PartiesSongsTest do
  use Server.DataCase

  alias Server.PartiesSongs

  describe "partiessongs" do
    alias Server.PartiesSongs.PartySong

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def party_song_fixture(attrs \\ %{}) do
      {:ok, party_song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PartiesSongs.create_party_song()

      party_song
    end

    test "list_partiessongs/0 returns all partiessongs" do
      party_song = party_song_fixture()
      assert PartiesSongs.list_partiessongs() == [party_song]
    end

    test "get_party_song!/1 returns the party_song with given id" do
      party_song = party_song_fixture()
      assert PartiesSongs.get_party_song!(party_song.id) == party_song
    end

    test "create_party_song/1 with valid data creates a party_song" do
      assert {:ok, %PartySong{} = party_song} = PartiesSongs.create_party_song(@valid_attrs)
    end

    test "create_party_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PartiesSongs.create_party_song(@invalid_attrs)
    end

    test "update_party_song/2 with valid data updates the party_song" do
      party_song = party_song_fixture()
      assert {:ok, %PartySong{} = party_song} = PartiesSongs.update_party_song(party_song, @update_attrs)
    end

    test "update_party_song/2 with invalid data returns error changeset" do
      party_song = party_song_fixture()
      assert {:error, %Ecto.Changeset{}} = PartiesSongs.update_party_song(party_song, @invalid_attrs)
      assert party_song == PartiesSongs.get_party_song!(party_song.id)
    end

    test "delete_party_song/1 deletes the party_song" do
      party_song = party_song_fixture()
      assert {:ok, %PartySong{}} = PartiesSongs.delete_party_song(party_song)
      assert_raise Ecto.NoResultsError, fn -> PartiesSongs.get_party_song!(party_song.id) end
    end

    test "change_party_song/1 returns a party_song changeset" do
      party_song = party_song_fixture()
      assert %Ecto.Changeset{} = PartiesSongs.change_party_song(party_song)
    end
  end
end
