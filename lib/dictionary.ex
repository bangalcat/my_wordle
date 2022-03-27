defmodule Dictionary do
  @spec random_word() :: String.t()
  defdelegate random_word, to: Dictionary.Server

  defdelegate in_dictionary?(word), to: Dictionary.Server
end
