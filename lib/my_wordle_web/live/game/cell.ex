defmodule MyWordleWeb.GameLive.Game.Cell do
  use MyWordleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class={ cell_class(@state) }>
    <%= @char %>
    </div>
    """
  end

  defp cell_class(:empty), do: default_class() <> " text-black dark:text-black"

  defp cell_class(:input), do: default_class() <> " text-black dark:text-black"

  defp cell_class(:miss),
    do:
      default_class() <>
        "bg-slate-500 text-white dark:text-white border-slate-400 dark:border-slate-700"

  defp cell_class(:half),
    do: default_class() <> "text-white dark:text-white bg-yellow-500 border-yellow-500"

  defp cell_class(:match),
    do: default_class() <> "text-white dark:text-white bg-green-500 border-green-500"

  defp default_class() do
    "w-14 h-14 border-solid border-2 flex items-center justify-center mx-0.5 text-lg font-bold rounded border-slate-200 shadowed "
  end
end
