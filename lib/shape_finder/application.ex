defmodule ShapeFinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ShapeFinderWeb.Telemetry,
      # Start the Ecto repository
      ShapeFinder.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ShapeFinder.PubSub},
      # Start Finch
      {Finch, name: ShapeFinder.Finch},
      # Start the Endpoint (http/https)
      ShapeFinderWeb.Endpoint
      # Start a worker by calling: ShapeFinder.Worker.start_link(arg)
      # {ShapeFinder.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShapeFinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShapeFinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
