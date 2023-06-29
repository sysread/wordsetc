defmodule WordsEtc.Permutations do
  alias WordsEtc.TaskPool

  @type letters :: [String.grapheme()]
  @type permutations :: [letters()]

  @alphabet String.split("abcdefghijklmnopqrstuvwxyz", "", trim: true)

  @spec all(String.t()) :: [String.t()]
  def all(str) do
    str
    |> String.upcase()
    |> expand_wildcards()
    |> TaskPool.flat_map(&all_subsets/1)
    |> TaskPool.map(&upcase_sort/1)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.uniq_by(&String.upcase/1)
    |> Enum.sort(&upcase_lte/2)
  end

  # ----------------------------------------------------------------------------
  # Sorts a list of variously cased strings in a case-insensitive manner.
  # ----------------------------------------------------------------------------
  defp upcase_sort(list), do: Enum.sort(list, &upcase_lte/2)
  defp upcase_lte(a, b), do: String.upcase(a) <= String.upcase(b)

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
  @spec expand_wildcards(String.t()) :: permutations()
  defp expand_wildcards(str) do
    if String.contains?(str, "?") do
      # For each alphabet letter, create a copy of the input string with the
      # first ? replaced by that letter.
      @alphabet
      |> TaskPool.map(&String.replace(str, "?", &1, global: false))
      |> TaskPool.flat_map(&expand_wildcards/1)
    else
      [str |> String.graphemes()]
    end
  end

  # ----------------------------------------------------------------------------
  # For a list of lists of characters, produce a list of all possible subsets
  # of those character lists.
  # ----------------------------------------------------------------------------
  @spec all_subsets(permutations()) :: permutations()
  defp all_subsets(list) do
    list
    |> Enum.reduce([[]], fn element, acc ->
      acc ++
        for subset <- acc do
          [element | subset]
        end
    end)
    |> Enum.reject(&Enum.empty?/1)
  end
end
