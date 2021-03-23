defmodule Server.PartiesTest do
  use Server.DataCase

  alias Server.Parties

  describe "parties" do
    alias Server.Parties.Party

    @valid_attrs %{description: "some description", roomname: "some roomname"}
    @update_attrs %{description: "some updated description", roomname: "some updated roomname"}
    @invalid_attrs %{description: nil, roomname: nil}

    def party_fixture(attrs \\ %{}) do
      {:ok, party} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Parties.create_party()

      party
    end

    test "list_parties/0 returns all parties" do
      party = party_fixture()
      assert Parties.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = party_fixture()
      assert Parties.get_party!(party.id) == party
    end

    test "create_party/1 with valid data creates a party" do
      assert {:ok, %Party{} = party} = Parties.create_party(@valid_attrs)
      assert party.description == "some description"
      assert party.roomname == "some roomname"
    end

    test "create_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_party(@invalid_attrs)
    end

    test "update_party/2 with valid data updates the party" do
      party = party_fixture()
      assert {:ok, %Party{} = party} = Parties.update_party(party, @update_attrs)
      assert party.description == "some updated description"
      assert party.roomname == "some updated roomname"
    end

    test "update_party/2 with invalid data returns error changeset" do
      party = party_fixture()
      assert {:error, %Ecto.Changeset{}} = Parties.update_party(party, @invalid_attrs)
      assert party == Parties.get_party!(party.id)
    end

    test "delete_party/1 deletes the party" do
      party = party_fixture()
      assert {:ok, %Party{}} = Parties.delete_party(party)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_party!(party.id) end
    end

    test "change_party/1 returns a party changeset" do
      party = party_fixture()
      assert %Ecto.Changeset{} = Parties.change_party(party)
    end
  end
end
