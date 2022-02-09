defmodule MyWordle.Impl.GameTest do
  use ExUnit.Case
  alias MyWordle.Impl.Game

  doctest Game

  describe "make_move/2" do
    test "guess wrong word" do
      game = Game.new_game("words")
      {game, tally} = Game.make_move(game, "wrong")

      set = match_set('words', 'wrong')

      assert %Game{
               turns_left: 5,
               history_words: ['wrong'],
               game_status: :guess,
               used_charset: ^set
             } = game

      assert %{
               turns_left: 5,
               history_words: [
                 {'wrong', [:match, :half, :half, :miss, :miss]}
               ],
               used_charset: ^set
             } = tally
    end

    test "won game" do
      game = Game.new_game("words")
      {game, tally} = Game.make_move(game, "words")

      set = match_set('words', 'words')
      assert %Game{game_status: :won, used_charset: ^set} = game

      assert %{
               turns_left: 5,
               history_words: [
                 {'words', [:match, :match, :match, :match, :match]}
               ],
               used_charset: ^set
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
