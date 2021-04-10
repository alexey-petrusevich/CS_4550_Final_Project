defmodule Server.Requests do
  @moduledoc """
  The Requests context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo
  alias Server.Users

  alias Server.Requests.Request

  @doc """
  Returns the list of requests.

  ## Examples

      iex> list_requests()
      [%Request{}, ...]

  """
  def list_requests do
    Repo.all(Request)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single request.

  Raises `Ecto.NoResultsError` if the Request does not exist.

  ## Examples

      iex> get_request!(123)
      %Request{}

      iex> get_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_request!(id) do
    Repo.get!(Request, id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs \\ %{}) do
    %Request{}
    |> Repo.preload(:user)
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a request.

  ## Examples

      iex> update_request(request, %{field: new_value})
      {:ok, %Request{}}

      iex> update_request(request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a request.

  ## Examples

      iex> delete_request(request)
      {:ok, %Request{}}

      iex> delete_request(request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  def exists(track_uri) do
    query = from r in "requests",
                 where: r.track_uri == ^track_uri
    Repo.exists?(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request changes.

  ## Examples

      iex> change_request(request)
      %Ecto.Changeset{data: %Request{}}

  """
  def change_request(%Request{} = request, attrs \\ %{}) do
    Request.changeset(request, attrs)
  end

  # returns collection of user_ids of all the requests in the DB
  def request_all_user_ids_by_track_uri(track_uri) do
    query = from r in "requests",
                 where: r.track_uri == ^track_uri,
                 distinct: r.user_id,
                 select: r.user_id
    Repo.all(query)
  end

  # updates a request with status of played
  def update_played(request_id) do
    request = get_request!(request_id)
    IO.inspect("Updating request to be played")
    IO.inspect(request)
    Users.update_impact_score(request.user_id)
    request
    |> Ecto.Changeset.change(played: true)
    |> Repo.update()
  end

end
