defmodule MyWordle.Impl.GameTest do
  use ExUnit.Case
  use ExUnitProperties
  alias MyWordle.Impl.Game

  doctest Game

  describe "new game" do
    property "make new game with 5 length word" do
      check all word <- string(?A..?Z, length: 5) do
        charlist = String.to_charlist(word)

        assert %Game{
                 answer: ^charlist,
                 turns_left: 6,
                 history_words: [],
                 game_status: :start,
                 used_charset: %{}
               } = Game.new_game(word)
      end
    end
  end

  describe "make_move/2" do
    property "try 6 wrong guess, lose game" do
      check all word <- string(?A..?Z, length: 5),
                guesses <- uniq_list_of(string(?A..?Z, length: 5), length: 6),
                word not in guesses do
        game = Game.new_game(word)

        game =
          guesses
          |> Enum.reduce(game, fn guess_word, game ->
            {game, _tally} = Game.make_move(game, guess_word)
            game
          end)

        assert %Game{turns_left: 0, game_status: :lost} = game
      end
    end

    test "guess wrong word" do
      game = Game.new_game("words")
      {game, tally} = Game.make_move(game, "wrong")

      set = match_set('WORDS', 'WRONG')

      assert %Game{
               turns_left: 5,
               history_words: ['WRONG'],
               game_status: :guess,
               used_charset: ^set
             } = game

      assert %{
               turns_left: 5,
               history_words: [
                 {'WRONG', [:match, :half, :half, :miss, :miss]}
               ],
               alphabet_map: alphabet_map
             } = tally

      for {c, expect} <- Enum.zip('WRONG', [:match, :half, :half, :miss, :miss]) do
        assert alphabet_map[c] == expect
      end

      for c <- ?A..?Z, c not in 'WRONG' do
        assert alphabet_map[c] == :none
      end
    end

    test "won game" do
      game = Game.new_game("words")
      {game, tally} = Game.make_move(game, "words")

      set = match_set('WORDS', 'WORDS')
      assert %Game{game_status: :won, used_charset: ^set} = game

      assert %{
               turns_left: 5,
               history_words: [
                 {'WORDS', [:match, :match, :match, :match, :match]}
               ],
               alphabet_map: alphabet_map
             } = tally
    end
  end

  defp match_set(answer, guess) do
    for {c, i} <- Enum.with_index(guess), reduce: %{} do
      acc ->
        cond do
          Enum.at(answer, i) == c ->
            Map.put(acc, c, :match)

          c in answer ->
            Map.put_new(acc, c, :half)

          true ->
            Map.put(acc, c, :miss)
        end
    end
  end
end
