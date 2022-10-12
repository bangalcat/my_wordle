defmodule MyWordle.Runtime.Server do
  use GenServer, restart: :temporary

  alias MyWordle.Impl.Game

  ### client process

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  ### server process

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {updated_game, tally_or_error} =
      case Game.make_move(game, guess) do
        {:error, reason} ->
          {game, {:error, reason}}

        success_result ->
          success_result
      end

    {:reply, tally_or_error, updated_game}
  end

  def handle_call(:tally, _from, game) do
    {:reply, Game.tally(game), game}
  end
end
