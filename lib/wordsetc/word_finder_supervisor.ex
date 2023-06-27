defmodule Wordsetc.WordFinder.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      %{id: Wordsetc.WordFinder, start: {Wordsetc.WordFinder, :start_link, []}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
