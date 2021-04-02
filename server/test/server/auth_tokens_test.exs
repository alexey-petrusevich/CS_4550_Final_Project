defmodule Server.AuthTokensTest do
  use Server.DataCase

  alias Server.AuthTokens

  describe "authtokens" do
    alias Server.AuthTokens.AuthToken

    @valid_attrs %{token: "some token"}
    @update_attrs %{token: "some updated token"}
    @invalid_attrs %{token: nil}

    def auth_token_fixture(attrs \\ %{}) do
      {:ok, auth_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AuthTokens.create_auth_token()

      auth_token
    end

    test "list_authtokens/0 returns all authtokens" do
      auth_token = auth_token_fixture()
      assert AuthTokens.list_authtokens() == [auth_token]
    end

    test "get_auth_token!/1 returns the auth_token with given id" do
      auth_token = auth_token_fixture()
      assert AuthTokens.get_auth_token!(auth_token.id) == auth_token
    end

    test "create_auth_token/1 with valid data creates a auth_token" do
      assert {:ok, %AuthToken{} = auth_token} = AuthTokens.create_auth_token(@valid_attrs)
      assert auth_token.token == "some token"
    end

    test "create_auth_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AuthTokens.create_auth_token(@invalid_attrs)
    end

    test "update_auth_token/2 with valid data updates the auth_token" do
      auth_token = auth_token_fixture()
      assert {:ok, %AuthToken{} = auth_token} = AuthTokens.update_auth_token(auth_token, @update_attrs)
      assert auth_token.token == "some updated token"
    end

    test "update_auth_token/2 with invalid data returns error changeset" do
      auth_token = auth_token_fixture()
      assert {:error, %Ecto.Changeset{}} = AuthTokens.update_auth_token(auth_token, @invalid_attrs)
      assert auth_token == AuthTokens.get_auth_token!(auth_token.id)
    end

    test "delete_auth_token/1 deletes the auth_token" do
      auth_token = auth_token_fixture()
      assert {:ok, %AuthToken{}} = AuthTokens.delete_auth_token(auth_token)
      assert_raise Ecto.NoResultsError, fn -> AuthTokens.get_auth_token!(auth_token.id) end
    end

    test "change_auth_token/1 returns a auth_token changeset" do
      auth_token = auth_token_fixture()
      assert %Ecto.Changeset{} = AuthTokens.change_auth_token(auth_token)
    end
  end
end
