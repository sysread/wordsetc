defmodule WordsEtc.Permutations do
  def all(str) do
    str
    |> String.upcase()
    |> String.graphemes()
    |> all_subsets()
    |> Enum.map(fn subset -> permutations(subset) end)
    |> List.flatten()
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.sort()
  end

  defp all_subsets(list) do
    list
    |> Enum.reduce([[]], fn element, acc ->
      acc ++ Enum.map(acc, &[element | &1])
    end)
  end

  defp permutations([]), do: [""]

  defp permutations(list) do
    list
    |> Enum.flat_map(fn x ->
      permutations(List.delete(list, x))
      |> Enum.map(fn perm -> "#{x}#{perm}" end)
    end)
  end
end
