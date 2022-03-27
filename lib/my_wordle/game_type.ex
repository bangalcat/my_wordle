defmodule MyWordle.GameType do
  @type tally :: %{
          turns_left: integer(),
          game_status: game_status(),
          alphabet_map: map(),
          history_words: list({charlist(), char_status()})
        }

  @type game_status :: :start | :guess | :already_used | :won | :lost
  @type char_status :: :none | :missed | :match | :half
end
