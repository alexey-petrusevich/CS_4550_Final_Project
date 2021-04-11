defmodule Server.Parties do
  @moduledoc """
  The Parties context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo

  alias Server.Parties.Party
  alias Server.Users

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

  def exists(party_id) do
    IO.inspect(party_id)
    query = from p in "parties",
                 where: p.id == ^party_id
    Repo.exists?(query)
  end

  def get_device_id!(party_id) do
    party = get_party!(party_id)
    party.device_id
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
    {resp, msg} = get_device_id(party_id, status)
    if (resp == :ok) do

      # reward host of the party with extra impact score
      if (status), do: Users.update_host_score(party.host_id)
      party
      |> Ecto.Changeset.change(is_active: status)
      |> Ecto.Changeset.change(device_id: msg)
      |> Repo.update()
    else
      {:error, msg}
    end
  end

  def get_user_id_by_party_id(party_id) do
    result = get_party!(party_id)
    result.host_id
  end

  # required scope: user-read-playback-state
  def get_device_id(party_id, party_active) do
    if (party_active) do
      # party is active)
      user_id = get_user_id_by_party_id(party_id)
      token = Server.AuthTokens.get_auth_token_by_user_id(user_id)
      url = "https://api.spotify.com/v1/me/player/devices"
      headers = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer #{token.token}}",
      ]
      resp = HTTPoison.get!(url, headers)
      data = Jason.decode!(resp.body)
      devices = data
                |> Map.get("devices")
      if (length(devices) > 0) do
        id = devices
             |> Enum.at(0)
             |> Map.get("id")
        {:ok, id}
      else
        {:error, "Please open the Spotify app on your intended playback device."}
      end
    else
      # status is false
      {:ok, ""}
    end
  end
end
