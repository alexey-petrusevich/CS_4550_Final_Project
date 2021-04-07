defmodule Server.PartiesSongs do
  @moduledoc """
  The PartiesSongs context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo

  alias Server.PartiesSongs.PartySong

  @doc """
  Returns the list of partiessongs.

  ## Examples

      iex> list_partiessongs()
      [%PartySong{}, ...]

  """
  def list_partiessongs do
    Repo.all(PartySong)
    |> Repo.preload(:song)
    |> Repo.preload(:party)
  end

  @doc """
  Gets a single party_song.

  Raises `Ecto.NoResultsError` if the Party song does not exist.

  ## Examples

      iex> get_party_song!(123)
      %PartySong{}

      iex> get_party_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party_song!(id) do
    Repo.get!(PartySong, id)
    |> Repo.preload(:song)
    |> Repo.preload(:party)
  end

  @doc """
  Creates a party_song.

  ## Examples

      iex> create_party_song(%{field: value})
      {:ok, %PartySong{}}

      iex> create_party_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party_song(attrs \\ %{}) do
    %PartySong{}
    |> PartySong.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a party_song.

  ## Examples

      iex> update_party_song(party_song, %{field: new_value})
      {:ok, %PartySong{}}

      iex> update_party_song(party_song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party_song(%PartySong{} = party_song, attrs) do
    party_song
    |> PartySong.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a party_song.

  ## Examples

      iex> delete_party_song(party_song)
      {:ok, %PartySong{}}

      iex> delete_party_song(party_song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party_song(%PartySong{} = party_song) do
    Repo.delete(party_song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking party_song changes.

  ## Examples

      iex> change_party_song(party_song)
      %Ecto.Changeset{data: %PartySong{}}

  """
  def change_party_song(%PartySong{} = party_song, attrs \\ %{}) do
    PartySong.changeset(party_song, attrs)
  end
end
