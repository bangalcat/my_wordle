defmodule Dictionary.WordList do
  @spec random_word(list(String.t())) :: String.t()
  def random_word([h | _] = word_list) when is_binary(h) do
    Enum.random(word_list)
  end

  def words_list do
    words_path()
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(" ", trim: true)
  end

  @spec in_dictionary?(String.t(), Enumerable.t()) :: boolean()
  def in_dictionary?(word, word_list) when is_binary(word) do
    word in word_list
  end

  defp words_path do
    Application.get_env(:my_wordle, :words_path)
    |> then(&Application.app_dir(:my_wordle, &1))
  end
end
