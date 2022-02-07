defmodule MyWordle.Repo do
  use Ecto.Repo,
    otp_app: :my_wordle,
    adapter: Ecto.Adapters.Postgres
end
