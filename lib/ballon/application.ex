defmodule Ballon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ballon.Repo,
      # Start the Telemetry supervisor
      BallonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ballon.PubSub},
      # Start the Endpoint (http/https)
      BallonWeb.Endpoint
      # Start a worker by calling: Ballon.Worker.start_link(arg)
      # {Ballon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ballon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BallonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
