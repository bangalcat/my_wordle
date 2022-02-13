defmodule Dictionary.WordList do
  @spec random_word(list(String.t())) :: String.t()
  def random_word(word_list) do
    Enum.random(word_list)
  end

  def words_list do
    "../../assets/dictionary/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(" ", trim: true)
  end

  def in_dictionary?(word, word_list) do
    word in word_list
  end
end
