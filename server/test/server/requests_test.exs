defmodule Server.RequestsTest do
  use Server.DataCase

  alias Server.Requests

  describe "requests" do
    alias Server.Requests.Request

    @valid_attrs %{artist: "some artist", title: "some title"}
    @update_attrs %{artist: "some updated artist", title: "some updated title"}
    @invalid_attrs %{artist: nil, title: nil}

    def request_fixture(attrs \\ %{}) do
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Requests.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Requests.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Requests.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = Requests.create_request(@valid_attrs)
      assert request.artist == "some artist"
      assert request.title == "some title"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Requests.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, %Request{} = request} = Requests.update_request(request, @update_attrs)
      assert request.artist == "some updated artist"
      assert request.title == "some updated title"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Requests.update_request(request, @invalid_attrs)
      assert request == Requests.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Requests.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Requests.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Requests.change_request(request)
    end
  end
end
