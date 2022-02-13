defmodule MyWordleWeb.GameLive.Game.Keyboard do
  use MyWordleWeb, :live_component

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    	<div class="flex justify-center mb-1">
    		<%= for k <- 'QWERTYUIOP' do %>
    		<.key value={[k]} type={@alphabet_map[k]} parent={@myself}/>
    		<% end %>
    	</div>

    	<div class="flex justify-center mb-1">
    		<%= for k <- 'ASDFGHJKL' do %>
    		<.key value={[k]} type={@alphabet_map[k]} parent={@myself}/>
    		<% end %>
    	</div>

    	<div class="flex justify-center mb-1">
    		<.key value={'ENTER'} parent={@myself}/>
    		<%= for k <- 'ZXCVBNM' do %>
    		<.key value={[k]} type={@alphabet_map[k]} parent={@myself}/>
    		<% end %>
    		<.key value={'DEL'} parent={@myself}/>
    	</div>
    </div>
    """
  end

  def key(assigns) do
    assigns = assign_new(assigns, :type, fn -> :none end)

    ~H"""
    <button class={ key_class(@type) } phx-click="make_move" phx-target="#game-holder" value={@value}>
    	<%= @value %>
    </button>
    """
  end

  defp key_class(:match), do: key_class(:default) <> "bg-green-500 border-green-300"
  defp key_class(:half), do: key_class(:default) <> "bg-yellow-500 border-yellow-300"
  defp key_class(:miss), do: key_class(:default) <> "bg-slate-600 dark:bg-slate-600"

  defp key_class(:none),
    do:
      key_class(:default) <>
        "bg-slate-200 dark:bg-slate-400 hover:bg-slate-300 active:bg-slate-500"

  defp key_class(:default),
    do:
      "flex items-center justify-center rounded mx-0.5 px-1.5 text-xs font-bold cursor-pointer select-none dark:text-white h-6 "
end
