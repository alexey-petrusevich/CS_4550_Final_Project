defmodule Server.Parties do
  @moduledoc """
  The Parties context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo

  alias Server.Parties.Party
  alias Server.Users.User

  import Ecto.Changeset

  @doc """
  Returns the list of parties.

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def list_parties do
    Repo.all(Party)
    |> Repo.preload(:host)
    |> Repo.preload(:songs)
  end

  @doc """
  Gets a single party.

  Raises `Ecto.NoResultsError` if the Party does not exist.

  ## Examples

      iex> get_party!(123)
      %Party{}

      iex> get_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party!(id) do
    Repo.get!(Party, id)
    |> Repo.preload(:host)
    |> Repo.preload(:songs)
  end

  @doc """
  Creates a party.

  ## Examples

      iex> create_party(%{field: value})
      {:ok, %Party{}}

      iex> create_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party(attrs \\ %{}) do
    attrs = attrs
    |> Map.put("roomcode", gen_room_code())

    %Party{}
    |> Repo.preload(:host)
    |> Party.changeset(attrs)
    |> Repo.insert()
  end

  def gen_room_code() do
    ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    |> Enum.take_random(4)
    |> Enum.join("")
  end

  @doc """
  Updates a party.

  ## Examples

      iex> update_party(party, %{field: new_value})
      {:ok, %Party{}}

      iex> update_party(party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party(%Party{} = party, attrs) do
    party
    |> Party.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a party.

  ## Examples

      iex> delete_party(party)
      {:ok, %Party{}}

      iex> delete_party(party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party(%Party{} = party) do
    Repo.delete(party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking party changes.

  ## Examples

      iex> change_party(party)
      %Ecto.Changeset{data: %Party{}}

  """
  def change_party(%Party{} = party, attrs \\ %{}) do
    Party.changeset(party, attrs)
  end

  # updates the list of attendees of the party
  def update_attendees(%Party{} = party, user_id) do
    party
    |> Ecto.Changeset.change(attendees: [user_id | party.attendees])
    |> Repo.update()
  end

  def update_active(party_id, status) do
    party = get_party!(party_id)
    |> Ecto.Changeset.change(is_active: status)
    |> Repo.update()

    IO.inspect(party)
  end
end
