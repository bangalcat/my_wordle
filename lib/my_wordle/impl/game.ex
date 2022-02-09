defmodule MyWordle.Impl.Game do
  @moduledoc """
  Game Management
  """

  @type t :: %__MODULE__{
          turns_left: integer(),
          game_status: game_status(),
          used_charset: %{char() => char_status()},
          history_words: list(charlist())
        }

  defstruct turns_left: 6,
            game_status: :start,
            answer: [],
            # used: %{match: [], mis_pos: [], miss: []},
            used_charset: %{},
            history_words: []

  @type game_status :: :start | :guess | :already_used | :won | :lost
  @type char_status :: :unused | :missed | :match | :only_pos

  @doc """

  ## Example

  iex> Game.new_game("abcde")
  %Game{turns_left: 6, game_status: :start, answer: 'abcde', used_charset: %{}, history_words: []}

  iex > Game.new_game("aa")
  {:error, :invalid_length}

  """
  def new_game do
    new_game("words")
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    case validate_word(word) do
      {:ok, word} ->
        word
        |> String.to_charlist()
        |> then(&%__MODULE__{answer: &1})

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp validate_word(word) do
    case String.length(word) do
      5 -> {:ok, word}
      _ -> {:error, :invalid_length}
    end
  end

  @doc """
  compare answer with guess word
  return new game state
  """
  @spec make_move(t, String.t()) :: {t, map()}
  def make_move(game, guess_word) do
    guess = String.to_charlist(guess_word)

    # used? impossible case

    # guess result
    guess_result(guess, game.answer)
    |> score_guess(%{game | history_words: [guess | game.history_words]})
    |> return_with_tally()
  end

  defp score_guess({:matched, used_charset}, game) do
    %{
      game
      | game_status: :won,
        turns_left: game.turns_left - 1,
        used_charset: merge_used_charset(game.used_charset, used_charset)
    }
  end

  defp score_guess({:missed, used_charset}, %{turns_left: 1} = game) do
    %{
      game
      | game_status: :lost,
        turns_left: game.turns_left - 1,
        used_charset: merge_used_charset(game.used_charset, used_charset)
    }
  end

  defp score_guess({:missed, used_charset}, game) do
    %{
      game
      | game_status: :guess,
        turns_left: game.turns_left - 1,
        used_charset: merge_used_charset(game.used_charset, used_charset)
    }
  end

  defp merge_used_charset(prev_charset, charset) do
    Map.merge(prev_charset, charset, fn
      c, :half, :half ->
        {c, :half}

      c, _, _ ->
        {c, :match}
    end)
  end

  @doc """

  ## Example

  iex> Game.guess_result('train', 'think')
  {:missed, %{?t => :match, ?r => :miss, ?a => :miss, ?i => :half, ?n => :half}}

  iex> Game.guess_result('guess', 'brain')
  {:missed, %{?g => :miss, ?u => :miss, ?e => :miss, ?s => :miss}}

  iex> Game.guess_result('think', 'think')
  {:matched, %{?t => :match, ?h => :match, ?i => :match, ?n => :match, ?k => :match}}
  """
  def guess_result(answer, answer), do: {:matched, Map.new(answer, &{&1, :match})}

  def guess_result(guess, answer) do
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
    |> then(&{:missed, &1})
  end

  ############################################## 3

  def tally(game) do
    %{
      turns_left: game.turns_left,
      history_words: words_with_match_result(game),
      used_charset: game.used_charset
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp words_with_match_result(%__MODULE__{history_words: words, answer: answer}) do
    words
    |> Enum.map(fn word ->
      Enum.zip(word, answer)
      |> Enum.map(fn
        {c, c} ->
          {c, :match}

        {c, _a} ->
          if c in answer do
            {c, :half}
          else
            {c, :miss}
          end
      end)
      |> Enum.unzip()
    end)
    |> Enum.reverse()
  end
end
