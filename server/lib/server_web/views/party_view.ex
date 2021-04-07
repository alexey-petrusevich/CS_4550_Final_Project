defmodule ServerWeb.PartyView do
  use ServerWeb, :view
  alias ServerWeb.PartyView
  alias ServerWeb.SongView
  alias ServerWeb.UserView
  alias ServerWeb.SongView

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
      description: party.description,
      attendees: party.attendees,
      songs: render_many(party.songs, PartySongView, "song.json"),
      host: render_one(party.host, UserView, "user.json")}
  end
end
