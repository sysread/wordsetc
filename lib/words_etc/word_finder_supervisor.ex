defmodule WordsEtc.WordFinder.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      %{id: WordsEtc.WordFinder, start: {WordsEtc.WordFinder, :start_link, []}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
