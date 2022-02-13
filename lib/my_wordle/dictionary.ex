defmodule MyWordle.Dictionary do
  @callback random_word() :: String.t()
  @callback in_dictionary?(String.t()) :: boolean()

  def random_word(), do: impl().random_word()
  def in_dictionary?(word), do: impl().in_dictionary?(word)

  def impl, do: Application.get_env(:my_wordle, :dictionary_client, Dictionary)
end
