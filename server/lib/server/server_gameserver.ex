defmodule Server.GameServer do # Change module name?
  use GenServer

  alias Server.Game
  alias Server.Parties
  alias Server.Parties.Party

  # public interface

  def reg(name) do
    {:via, Registry, {Server.GameReg, name}} # TODO: fix what this points to?
  end

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker
    }
    Server.GameSup.start_child(spec)
  end

  def start_link(name) do
    # game = Game.new # TODO: Probably change, replace with game instance
    party = Parties.create_party() # Create new instance <- Is this necessary
    GenServer.start_link(
      __MODULE__,
      party,
      name: reg(name)
    )
  end


  # implementation

  def init(game) do
    {:ok, game}
  end
end
