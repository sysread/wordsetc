defmodule Wordsetc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WordsetcWeb.Telemetry,
      # Start the Ecto repository
      Wordsetc.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Wordsetc.PubSub},
      # Start Finch
      {Finch, name: Wordsetc.Finch},
      # Start the Endpoint (http/https)
      WordsetcWeb.Endpoint,
      # Start a worker by calling: Wordsetc.Worker.start_link(arg)
      # {Wordsetc.Worker, arg}
      Wordsetc.WordFinder.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wordsetc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordsetcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
