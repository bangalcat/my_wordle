defmodule MyWordle do
  @moduledoc """
  MyWordle keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias MyWordle.Runtime.GameSupervisor
  alias MyWordle.Impl.Game

  @spec new_game() :: pid()
  def new_game() do
    {:ok, pid} = GameSupervisor.start_game()
    pid
  end

  @spec make_move(pid(), guess_word :: String.t()) :: Game.tally()
  def make_move(pid, guess_word) do
    GenServer.call(pid, {:make_move, guess_word})
  end

  @spec tally(pid()) :: Game.tally()
  def tally(pid) do
    GenServer.call(pid, {:tally})
  end
end
