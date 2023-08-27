defmodule TudeeFinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TudeeFinderWeb.Telemetry,
      # Start the Ecto repository
      TudeeFinder.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TudeeFinder.PubSub},
      # Start Finch
      {Finch, name: TudeeFinder.Finch},
      # Start the Endpoint (http/https)
      TudeeFinderWeb.Endpoint
      # Start a worker by calling: TudeeFinder.Worker.start_link(arg)
      # {TudeeFinder.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TudeeFinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TudeeFinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
