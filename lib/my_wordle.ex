defmodule MyWordle do
  @moduledoc """
  MyWordle keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias MyWordle.Runtime.GameSupervisor

  def new_game() do
    {:ok, pid} = GameSupervisor.start_game()
    pid
  end

  def make_move(pid, guess_word) do
    GenServer.call(pid, {:make_move, guess_word})
  end

  def tally(pid) do
    GenServer.call(pid, {:tally})
  end
end
