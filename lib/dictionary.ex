defmodule Dictionary do
  defdelegate random_word, to: Dictionary.Server

  defdelegate in_dictionary?(word), to: Dictionary.Server
end
