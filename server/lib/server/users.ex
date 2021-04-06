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
    %{top_arists: ["Faye Webster", "Gene Kim", "Lilan"],
      top_genres: ["RnB", "Classical", "Jazz"],
      audio_features: %{
        "danceability": 0.696,
        "energy": 0.905,
        "key": 2,
        "loudness": -2.743,
        "mode": 1,
        "speechiness": 0.103,
        "acousticness": 0.011,
        "instrumentalness": 0.000905,
        "liveness": 0.302,
        "valence": 0.625,
        "tempo": 114.944}
      }
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
