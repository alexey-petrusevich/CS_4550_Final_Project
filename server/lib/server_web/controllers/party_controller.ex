defmodule ServerWeb.PartyController do
  use ServerWeb, :controller

  alias Server.Parties
  alias Server.Parties.Party


  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    parties = Parties.list_parties()
    render(conn, "index.json", parties: parties)
  end

  def create(conn, %{"party" => party_params}) do
    IO.inspect(party_params)
    with {:ok, %Party{} = party} <- Parties.create_party(party_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.party_path(conn, :show, party))
      |> render("show.json", party: party)
    end
  end

  def show(conn, %{"id" => id}) do
    party = Parties.get_party!(id)
    render(conn, "show.json", party: party)
  end

  def update(conn, %{"id" => id, "party" => party_params}) do
    party = Parties.get_party!(id)

    with {:ok, %Party{} = party} <- Parties.update_party(party, party_params) do
      render(conn, "show.json", party: party)
    end
  end

  def delete(conn, %{"id" => id}) do
    party = Parties.get_party!(id)

    with {:ok, %Party{}} <- Parties.delete_party(party) do
      send_resp(conn, :no_content, "")
    end
  end

  def join(conn, %{"party_id" => p_id, "user_id" => u_id}) do
    if Parties.exists(p_id) do
      party = Parties.get_party!(p_id)
      Parties.update_attendees(party, u_id)
      conn
      |> send_resp(200, Jason.encode!(%{}))
    else
      conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:bad_request, Jason.encode!(%{error: "Party does not exist."}))
    end
  end
end
