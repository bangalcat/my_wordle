defmodule MyWordleWeb.GameLive.Game.Row do
  use MyWordleWeb, :live_component

  alias MyWordleWeb.GameLive.Game.Cell
  require Logger

  def render(%{states: []} = assigns) do
    Logger.debug(inspect(assigns.word))

    ~H"""
    <div class="flex justify-center mb-1">
    <%= for c <- @word do %>
    <%= live_component Cell, char: [c], state: :empty %>
    <% end %>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center mb-1">
    <%= for {char, state} <- Enum.zip(@word, @states) do %>
    <%= live_component Cell, char: [char], state: state %>
    <% end %>
    </div>
    """
  end
end
