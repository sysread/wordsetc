defmodule WordsEtc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WordsEtcWeb.Telemetry,
      # Start the Ecto repository
      WordsEtc.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WordsEtc.PubSub},
      # Start the Endpoint (http/https)
      WordsEtcWeb.Endpoint,
      # Start a worker by calling: WordsEtc.Worker.start_link(arg)
      # {WordsEtc.Worker, arg}
      WordsEtc.WordFinderSupervisor,
      {Task.Supervisor, name: WordsEtc.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WordsEtc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordsEtcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
