import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :my_wordle, MyWordleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "PmU8++cTB9Hu3LQTZ8C/i0E8DzI9BeEuYXl+ni2xg4WsKsgfZTvCmjyuhJNrv39d",
  server: false

config :my_wordle, :dictionary_client, MyWordle.Dictionary.Mock

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
