defmodule Dictionary.WordList do
  def words_list do
    words_path()
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(" ", trim: true)
  end

  @spec random_word(list(String.t())) :: String.t()
  def random_word([h | _] = word_list) when is_binary(h) do
    Enum.random(word_list)
  end

  @spec in_dictionary?(String.t(), Enumerable.t()) :: boolean()
  def in_dictionary?(word, word_list) when is_binary(word) do
    word in word_list
  end

  defp words_path do
    app = Application.get_env(:my_wordle, :current_app, :my_wordle)

    Application.get_env(:my_wordle, :words_path)
    |> then(&Application.app_dir(app, &1))
  end
end
