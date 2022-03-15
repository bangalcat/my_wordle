defmodule MyWordle.Impl.Game do
  @moduledoc """
  Game Management
  """

  alias MyWordle.Dictionary

  @type t :: %__MODULE__{
          turns_left: integer(),
          game_status: game_status(),
          used_charset: %{char() => char_status()},
          history_words: list(charlist())
        }

  @type tally :: %{
          turns_left: integer(),
          game_status: game_status(),
          alphabet_map: map(),
          history_words: list({list(), char_status()})
        }

  defstruct turns_left: 6,
            game_status: :start,
            answer: [],
            # used: %{match: [], mis_pos: [], miss: []},
            used_charset: %{},
            history_words: []

  @type game_status :: :start | :guess | :already_used | :won | :lost
  @type char_status :: :none | :missed | :match | :half

  @doc """

  ## Example

      iex> Game.new_game("abcde")
      %Game{turns_left: 6, game_status: :start, answer: 'ABCDE', used_charset: %{}, history_words: []}

      iex > Game.new_game("aa")
      {:error, :invalid_length}

  """
  def new_game do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    case validate_word(word) do
      {:ok, word} ->
        word
        |> String.upcase()
        |> String.to_charlist()
        |> then(&%__MODULE__{answer: &1})

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp validate_word(word) do
    with {:ok, word} <- validate_length(word),
         {:ok, word} <- validate_correct(word) do
      {:ok, word}
    end
  end

  defp validate_correct(word) do
    case Dictionary.in_dictionary?(word) do
      true ->
        {:ok, word}

      false ->
        {:error, :not_found}
    end
  end

  defp validate_length(word) do
    case String.length(word) do
      5 -> {:ok, word}
      _ -> {:error, :invalid_length}
    end
  end

  @doc """
  compare answer with guess word
  return new game state
  """
  @spec make_move(t, String.t()) :: {t, map()} | {:error, :invalid_length} | {:error, :not_found}
  def make_move(game, guess_word) do
    guess = guess_word |> String.upcase() |> String.to_charlist()

    # used? impossible case

    with {:ok, _word} <- validate_word(guess_word) do
      # guess result
      guess_result(guess, game.answer)
      |> score_guess(%{game | history_words: [guess | game.history_words]})
      |> return_with_tally()
    end
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
      _c, :half, :half ->
        :half

      _c, :miss, :miss ->
        :miss

      _c, _, _ ->
        :match
    end)
  end

  @doc """

  ## Example

      iex> Game.guess_result('TRAIN', 'THINK')
      {:missed, %{?T => :match, ?R => :miss, ?A => :miss, ?I => :half, ?N => :half}}

      iex> Game.guess_result('GUESS', 'BRAIN')
      {:missed, %{?G => :miss, ?U => :miss, ?E => :miss, ?S => :miss}}

      iex> Game.guess_result('THINK', 'THINK')
      {:matched, %{?T => :match, ?H => :match, ?I => :match, ?N => :match, ?K => :match}}
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

  @doc """

  ## Example

      iex> Game.new_game() |> Game.tally()
      %{game_status: :start, turns_left: 6, history_words: [], alphabet_map: ?A..?Z |> Map.new(&{&1, :none})}
  """
  def tally(game) do
    %{
      game_status: game.game_status,
      turns_left: game.turns_left,
      history_words: words_with_match_result(game),
      alphabet_map: result_alphabet_map(game.used_charset)
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp result_alphabet_map(used_charset) do
    ?A..?Z
    |> Map.new(&{&1, Map.get(used_charset, &1, :none)})
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
