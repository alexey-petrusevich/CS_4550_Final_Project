defmodule ServerWeb.AuthTokenControllerTest do
  use ServerWeb.ConnCase

  alias Server.AuthTokens
  alias Server.AuthTokens.AuthToken

  @create_attrs %{
    token: "some token"
  }
  @update_attrs %{
    token: "some updated token"
  }
  @invalid_attrs %{token: nil}

  def fixture(:auth_token) do
    {:ok, auth_token} = AuthTokens.create_auth_token(@create_attrs)
    auth_token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all authtokens", %{conn: conn} do
      conn = get(conn, Routes.auth_token_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create auth_token" do
    test "renders auth_token when data is valid", %{conn: conn} do
      conn = post(conn, Routes.auth_token_path(conn, :create), auth_token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.auth_token_path(conn, :show, id))

      assert %{
               "id" => id,
               "token" => "some token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.auth_token_path(conn, :create), auth_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update auth_token" do
    setup [:create_auth_token]

    test "renders auth_token when data is valid", %{conn: conn, auth_token: %AuthToken{id: id} = auth_token} do
      conn = put(conn, Routes.auth_token_path(conn, :update, auth_token), auth_token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.auth_token_path(conn, :show, id))

      assert %{
               "id" => id,
               "token" => "some updated token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, auth_token: auth_token} do
      conn = put(conn, Routes.auth_token_path(conn, :update, auth_token), auth_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete auth_token" do
    setup [:create_auth_token]

    test "deletes chosen auth_token", %{conn: conn, auth_token: auth_token} do
      conn = delete(conn, Routes.auth_token_path(conn, :delete, auth_token))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.auth_token_path(conn, :show, auth_token))
      end
    end
  end

  defp create_auth_token(_) do
    auth_token = fixture(:auth_token)
    %{auth_token: auth_token}
  end
end
