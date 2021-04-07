defmodule Server.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo

  alias Server.Users.User

  # authentication for User
  def authenticate(username, pass) do
    user = Repo.get_by(User, username: username)
    if user do
      case Argon2.check_pass(user, pass) do
        {:ok, user} -> user
        _ -> nil
      end
    else
      nil
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Map.merge(get_user_data(id))
  end

  def get_user_data(id) do
    id_int = String.to_integer(id)

    artists = Ecto.Adapters.SQL.query(Repo, "SELECT artist from songs where id in (SELECT song_id from partiessongs where party_id in (SELECT id from parties where host_id=$1::integer or attendees @> $2))", [id_int, [id_int]])
    |> elem(1)
    |> Map.fetch(:rows)
    |> elem(1)
    |> List.flatten
    |> Enum.frequencies
    |> Map.to_list
    |> Enum.sort(fn ({_k1, val1}, {_k2, val2}) -> val1 >= val2 end)
    |> Enum.map(fn x -> elem(x, 0) end)

    genres = Ecto.Adapters.SQL.query(Repo, "SELECT genre from songs where id in (SELECT song_id from partiessongs where party_id in (SELECT id from parties where host_id=$1::integer or attendees @> $2))", [id_int, [id_int]])
    |> elem(1)
    |> Map.fetch(:rows)
    |> elem(1)
    |> List.flatten
    |> Enum.frequencies
    |> Map.to_list
    |> Enum.sort(fn ({_k1, val1}, {_k2, val2}) -> val1 >= val2 end)
    |> Enum.map(fn x -> elem(x, 0) end)

    energy_vals = Ecto.Adapters.SQL.query(Repo, "SELECT energy from songs where id in (SELECT song_id from partiessongs where party_id in (SELECT id from parties where host_id=$1::integer or attendees @> $2))", [id_int, [id_int]])
    |> elem(1)
    |> Map.fetch(:rows)
    |> elem(1)
    |> List.flatten

    IO.puts(Enum.sum(energy_vals))
    IO.puts(Enum.count(energy_vals))
    
    energy_avg = 0
    
    if Enum.count(energy_vals) != 0 do
      energy_avg = (Enum.sum(energy_vals) * 1.0) / Enum.count(energy_vals)
    end

    %{top_arists: artists,
      top_genres: genres,
      energy: energy_avg}
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
