defmodule Dictionary.Server do
  use Agent

  def start_link(_) do
    Agent.start_link(&Dictionary.WordList.words_list/0, name: __MODULE__)
  end

  @spec random_word() :: String.t()
  def random_word() do
    Agent.get(__MODULE__, &Dictionary.WordList.random_word/1)
  end

  @spec in_dictionary?(String.t()) :: boolean()
  def in_dictionary?(word) do
    Agent.get(__MODULE__, &Dictionary.WordList.in_dictionary?(word, &1))
  end
end
