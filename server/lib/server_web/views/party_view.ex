defmodule ServerWeb.PartyView do
  use ServerWeb, :view
  alias ServerWeb.PartyView

  def render("index.json", %{parties: parties}) do
    %{data: render_many(parties, PartyView, "party.json")}
  end

  def render("show.json", %{party: party}) do
    %{data: render_one(party, PartyView, "party.json")}
  end

  def render("party.json", %{party: party}) do
    #TODO preload host
    %{id: party.id,
      name: party.name,
      roomcode: party.roomcode,
      description: party.description}
  end
end
