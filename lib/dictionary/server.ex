defmodule Dictionary.Server do
  use Agent

  def start_link(_) do
    Agent.start_link(&Dictionary.WordList.words_list/0, name: __MODULE__)
  end

  def random_word() do
    Agent.get(__MODULE__, &Dictionary.WordList.random_word/1)
  end

  def in_dictionary?(word) do
    Agent.get(__MODULE__, &Dictionary.WordList.in_dictionary?(word, &1))
  end
end
