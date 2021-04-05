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
    game = Parties.create_party()
    GenServer.start_link(
      __MODULE__,
      game,
      name: reg(name)
    )
  end

  """
  TODO: Contains more functionality e.g.
  def guess(gamename, username, guessarray) do
    GenServer.call(reg(gamename), {:guess, gamename, username, guessarray})
  end
  """

  # implementation

  def init(game) do
    {:ok, game}
  end

  """
  TODO: Contains more implementation e.g.
  def handle_call({:pass, gamename, username}, _from, game) do
    game = Game.pass(game, username)
    BackupAgent.put(gamename, game)
    {:reply, game, game}
  end
  """
end
