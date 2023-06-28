defmodule WordsEtc.Permutations do
  @alphabet String.split("abcdefghijklmnopqrstuvwxyz", "", trim: true)

  def all(str) do
    str
    |> String.upcase()
    |> expand_wildcards()
    |> Enum.flat_map(&all_subsets/1)
    |> Enum.flat_map(fn subset -> permutations(subset) end)
    |> Enum.uniq_by(&String.upcase/1)
    |> Enum.sort()
  end

  # ----------------------------------------------------------------------------
  # For a given list of characters, return a list of lists, where each
  # occurrence of "?" in the original list results in new lists where "?" has
  # been replaced in each by each of the characters in the alphabet.
  #
  # Replaced letters can be identified by using their lowercse equivalent.
  #
  # For example, "AB?" would result in:
  #   [["A", "B", "a"], ["A", "B", "b"], ["A", "B", "c"], ...]
  # ----------------------------------------------------------------------------
  defp expand_wildcards(str) do
    if String.contains?(str, "?") do
      @alphabet
      |> Enum.map(fn char -> String.replace(str, "?", char) end)
      |> Enum.flat_map(&expand_wildcards/1)
    else
      [str |> String.graphemes() |> Enum.sort()]
    end
  end

  # ----------------------------------------------------------------------------
  # For a list of characters, produce a list of all possible subsets of those
  # characters.
  # ----------------------------------------------------------------------------
  defp all_subsets(list) do
    list
    |> Enum.reduce([[]], fn element, acc ->
      acc ++ Enum.map(acc, &[element | &1])
    end)
    |> Enum.reject(fn x -> x == [] end)
  end

  # ----------------------------------------------------------------------------
  # For each subset of characters from the original input, produce a list of all
  # possible combinations of those characters.
  # ----------------------------------------------------------------------------
  defp permutations([]), do: [""]

  defp permutations(list), do: do_permutations(list, [])

  defp do_permutations([], _acc), do: []

  defp do_permutations([head | tail], acc) do
    rest = acc ++ tail
    perms = rest |> permutations()
    new_perms = Enum.reduce(perms, [], fn p, acc -> [head <> p | acc] end)
    new_perms ++ do_permutations(tail, [head | acc])
  end
end
