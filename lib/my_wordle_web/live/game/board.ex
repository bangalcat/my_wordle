defmodule MyWordleWeb.GameLive.Game.Board do
  use MyWordleWeb, :live_component

  alias MyWordleWeb.GameLive.Game.Row

  def render(assigns) do
    ~H"""
    <div class="pb-6">
    <%= for {word, states} <- @tally.history_words do %>
    <%= live_component Row, word: word, states: states %>
    <% end %>
    <%= if @tally.turns_left > 0 do %>
    <%= live_component Row, word: fill_input(@input), states: empty_states() %>
    <% end %>
    <%= for _i <- 1..(@tally.turns_left-1)//1 do %>
    <%= live_component Row, word: '     ', states: empty_states() %>
    <% end %>
    </div>
    """
  end

  defp empty_states do
    List.duplicate(:empty, 5)
  end

  defp fill_input(input) do
    List.to_charlist(input)
    |> Kernel.++('     ')
    |> Enum.take(5)
  end
end
