defmodule Dictionary.WordListTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Dictionary.WordList

  describe "random_word/1" do
    property "random word in given word list" do
      check all word_list <- list_of(string(?A..?Z, length: 5), min_length: 1) do
        word = WordList.random_word(word_list)
        assert word in word_list
      end
    end
  end
end
