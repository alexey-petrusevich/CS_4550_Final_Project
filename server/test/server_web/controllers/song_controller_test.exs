defmodule ServerWeb.SongControllerTest do
  use ServerWeb.ConnCase

  alias Server.Songs
  alias Server.Songs.Song

  @create_attrs %{
    artist: "some artist",
    genre: "some genre",
    title: "some title",
    track_uri: "some track_uri"
  }
  @update_attrs %{
    artist: "some updated artist",
    genre: "some updated genre",
    title: "some updated title",
    track_uri: "some updated track_uri"
  }
  @invalid_attrs %{artist: nil, genre: nil, title: nil, track_uri: nil}

  def fixture(:song) do
    {:ok, song} = Songs.create_song(@create_attrs)
    song
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all songs", %{conn: conn} do
      conn = get(conn, Routes.song_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create song" do
    test "renders song when data is valid", %{conn: conn} do
      conn = post(conn, Routes.song_path(conn, :create), song: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.song_path(conn, :show, id))

      assert %{
               "id" => id,
               "artist" => "some artist",
               "genre" => "some genre",
               "title" => "some title",
               "track_uri" => "some track_uri"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.song_path(conn, :create), song: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update song" do
    setup [:create_song]

    test "renders song when data is valid", %{conn: conn, song: %Song{id: id} = song} do
      conn = put(conn, Routes.song_path(conn, :update, song), song: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.song_path(conn, :show, id))

      assert %{
               "id" => id,
               "artist" => "some updated artist",
               "genre" => "some updated genre",
               "title" => "some updated title",
               "track_uri" => "some updated track_uri"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, song: song} do
      conn = put(conn, Routes.song_path(conn, :update, song), song: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete song" do
    setup [:create_song]

    test "deletes chosen song", %{conn: conn, song: song} do
      conn = delete(conn, Routes.song_path(conn, :delete, song))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.song_path(conn, :show, song))
      end
    end
  end

  defp create_song(_) do
    song = fixture(:song)
    %{song: song}
  end
end
