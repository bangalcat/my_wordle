defmodule MyWordle.Runtime.GameSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @spec start_game() :: DynamicSupervisor.on_start_child()
  def start_game do
    DynamicSupervisor.start_child(__MODULE__, MyWordle.Runtime.Server)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
