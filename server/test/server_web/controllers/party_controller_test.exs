defmodule ServerWeb.PartyControllerTest do
  use ServerWeb.ConnCase

  alias Server.Parties
  alias Server.Parties.Party

  @create_attrs %{
    description: "some description",
    roomname: "some roomname"
  }
  @update_attrs %{
    description: "some updated description",
    roomname: "some updated roomname"
  }
  @invalid_attrs %{description: nil, roomname: nil}

  def fixture(:party) do
    {:ok, party} = Parties.create_party(@create_attrs)
    party
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all parties", %{conn: conn} do
      conn = get(conn, Routes.party_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create party" do
    test "renders party when data is valid", %{conn: conn} do
      conn = post(conn, Routes.party_path(conn, :create), party: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.party_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "roomname" => "some roomname"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.party_path(conn, :create), party: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update party" do
    setup [:create_party]

    test "renders party when data is valid", %{conn: conn, party: %Party{id: id} = party} do
      conn = put(conn, Routes.party_path(conn, :update, party), party: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.party_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "roomname" => "some updated roomname"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, party: party} do
      conn = put(conn, Routes.party_path(conn, :update, party), party: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete party" do
    setup [:create_party]

    test "deletes chosen party", %{conn: conn, party: party} do
      conn = delete(conn, Routes.party_path(conn, :delete, party))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.party_path(conn, :show, party))
      end
    end
  end

  defp create_party(_) do
    party = fixture(:party)
    %{party: party}
  end
end
