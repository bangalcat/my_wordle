defmodule MyWordle do
  @moduledoc """
  MyWordle keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias MyWordle.Runtime.GameSupervisor
  alias MyWordle.GameType

  @spec new_game() :: pid()
  def new_game() do
    {:ok, pid} = GameSupervisor.start_game()
    pid
  end

  @spec make_move(GenServer.server(), guess_word :: String.t()) ::
          GameType.tally() | {:error, atom()}
  def make_move(pid, guess_word) when is_pid(pid) do
    GenServer.call(pid, {:make_move, guess_word})
  end

  @spec tally(GenServer.server()) :: GameType.tally()
  def tally(pid) when is_pid(pid) do
    GenServer.call(pid, :tally)
  end
end
