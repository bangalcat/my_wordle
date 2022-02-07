defmodule MyWordle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # MyWordle.Repo,
      # Start the Telemetry supervisor
      MyWordleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MyWordle.PubSub},
      # Start the Endpoint (http/https)
      MyWordleWeb.Endpoint
      # Start a worker by calling: MyWordle.Worker.start_link(arg)
      # {MyWordle.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyWordle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyWordleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
