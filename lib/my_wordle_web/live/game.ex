defmodule MyWordleWeb.GameLive.Game do
  use MyWordleWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    game_id = MyWordle.new_game()
    tally = MyWordle.tally(game_id)
    socket = socket |> assign(%{game: game_id, tally: tally, input: []})
    # Logger.debug(inspect(tally))
    {:ok, socket}
  end

  def game_status(:won), do: "Congratulation! You Won!"
  def game_status(:lost), do: "Sorry, You Lose!"
  def game_status(:start), do: "Game Start"
  def game_status(:guess), do: "you guess"

  @impl true
  def handle_event("make_move", _, %{assigns: %{tally: %{game_status: status}}} = socket)
      when status in [:won, :lost] do
    {:noreply, socket}
  end

  def handle_event("make_move", %{"key" => "Backspace"}, %{assigns: %{input: input}} = socket) do
    {:noreply, assign(socket, :input, backspace(input)) |> clear_flash()}
  end

  def handle_event("make_move", %{"key" => "Enter"}, %{assigns: %{input: input}} = socket) do
    if :erlang.iolist_size(input) == 5 do
      case MyWordle.make_move(socket.assigns.game, :erlang.iolist_to_binary(input)) do
        {:error, :not_found} ->
          Process.send_after(self(), "clear_flash", 5000)
          {:noreply, socket |> put_flash(:error, "Not found Word!")}

        tally ->
          # Logger.debug(tally)
          {:noreply, assign(socket, :tally, tally) |> clear_flash() |> assign(:input, [])}
      end
    else
      Process.send_after(self(), "clear_flash", 5000)
      {:noreply, socket |> put_flash(:error, "must be 5 characters")}
    end
  end

  def handle_event("make_move", %{"key" => key}, socket) do
    # Logger.debug("key: #{key}")
    input = normalize(socket.assigns.input, String.upcase(key))
    {:noreply, assign(socket, :input, input) |> clear_flash()}
  end

  def handle_event("make_move" = event, params, socket) do
    case params["value"] do
      "ENTER" ->
        handle_event(event, %{"key" => "Enter"}, socket)

      "DEL" ->
        handle_event(event, %{"key" => "Backspace"}, socket)

      alphabet when not is_nil(alphabet) ->
        handle_event(event, %{"key" => alphabet}, socket)
    end
  end

  def handle_info("clear_flash", socket) do
    {:noreply, socket |> clear_flash()}
  end

  #
  # Helpers
  #

  defp normalize(input, key) do
    if :erlang.iolist_size(input) >= 5 or not alphabet?(key) do
      input
    else
      [input, key]
    end
  end

  defp backspace([]), do: []
  defp backspace([p, _]), do: p

  defp alphabet?(<<char>>) do
    char in ?A..?Z or char in ?a..?z
  end

  defp alphabet?(_), do: false
end
