defmodule TextSharing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    TextSharing.DataStore.start_link()

    children = [
      # Starts a worker by calling: TextSharing.Worker.start_link(arg)
      # {TextSharing.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: TextSharing.Router, options: [port: 4001]}
    ]

    Logger.info("Application Started!")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TextSharing.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
