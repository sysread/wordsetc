defmodule WordsEtc.TaskPool do
  def map(enum, fun) do
    Task.Supervisor.async_stream(WordsEtc.TaskSupervisor, enum, fun)
    |> Enum.to_list()
    |> Enum.map(fn {:ok, result} -> result end)
  end

  def flat_map(enum, fun) do
    Task.Supervisor.async_stream(WordsEtc.TaskSupervisor, enum, fun)
    |> Enum.to_list()
    |> Enum.flat_map(fn {:ok, result} -> result end)
  end
end
