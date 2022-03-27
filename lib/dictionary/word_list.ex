defmodule Dictionary.WordList do
  @spec random_word(list(String.t())) :: String.t()
  def random_word([h | _] = word_list) when is_binary(h) do
    Enum.random(word_list)
  end

  def words_list do
    "../../assets/dictionary/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(" ", trim: true)
  end

  @spec in_dictionary?(String.t(), Enumerable.t()) :: boolean()
  def in_dictionary?(word, word_list) when is_binary(word) do
    word in word_list
  end
end
