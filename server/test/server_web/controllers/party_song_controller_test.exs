defmodule ServerWeb.PartySongControllerTest do
  use ServerWeb.ConnCase

  alias Server.PartiesSongs

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:party_song) do
    {:ok, party_song} = PartiesSongs.create_party_song(@create_attrs)
    party_song
  end

  describe "index" do
    test "lists all partiessongs", %{conn: conn} do
      conn = get(conn, Routes.party_song_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Partiessongs"
    end
  end

  describe "new party_song" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.party_song_path(conn, :new))
      assert html_response(conn, 200) =~ "New Party song"
    end
  end

  describe "create party_song" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.party_song_path(conn, :create), party_song: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.party_song_path(conn, :show, id)

      conn = get(conn, Routes.party_song_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Party song"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.party_song_path(conn, :create), party_song: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Party song"
    end
  end

  describe "edit party_song" do
    setup [:create_party_song]

    test "renders form for editing chosen party_song", %{conn: conn, party_song: party_song} do
      conn = get(conn, Routes.party_song_path(conn, :edit, party_song))
      assert html_response(conn, 200) =~ "Edit Party song"
    end
  end

  describe "update party_song" do
    setup [:create_party_song]

    test "redirects when data is valid", %{conn: conn, party_song: party_song} do
      conn = put(conn, Routes.party_song_path(conn, :update, party_song), party_song: @update_attrs)
      assert redirected_to(conn) == Routes.party_song_path(conn, :show, party_song)

      conn = get(conn, Routes.party_song_path(conn, :show, party_song))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, party_song: party_song} do
      conn = put(conn, Routes.party_song_path(conn, :update, party_song), party_song: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Party song"
    end
  end

  describe "delete party_song" do
    setup [:create_party_song]

    test "deletes chosen party_song", %{conn: conn, party_song: party_song} do
      conn = delete(conn, Routes.party_song_path(conn, :delete, party_song))
      assert redirected_to(conn) == Routes.party_song_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.party_song_path(conn, :show, party_song))
      end
    end
  end

  defp create_party_song(_) do
    party_song = fixture(:party_song)
    %{party_song: party_song}
  end
end
