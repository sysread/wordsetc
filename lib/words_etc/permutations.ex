defmodule WordsEtc.Permutations do
  @type letters :: [String.grapheme()]
  @type permutations :: [letters()]

  @alphabet String.split("abcdefghijklmnopqrstuvwxyz", "", trim: true)

  def all(str) do
    str
    |> String.upcase()
    |> expand_wildcards()
    |> Enum.flat_map(&all_subsets/1)
    |> Enum.map(fn permutation ->
      Enum.sort(permutation, fn a, b ->
        String.upcase(a) <= String.upcase(b)
      end)
    end)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.uniq_by(&String.upcase/1)
    |> Enum.sort(&(String.upcase(&1) <= String.upcase(&2)))
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
  @spec expand_wildcards(String.t()) :: permutations()
  defp expand_wildcards(str) do
    if String.contains?(str, "?") do
      # For each alphabet letter, create a copy of the input string with the
      # first ? replaced by that letter.
      @alphabet
      |> Enum.map(&String.replace(str, "?", &1, global: false))
      |> Enum.flat_map(&expand_wildcards/1)
    else
      [
        str
        |> String.graphemes()
        |> Enum.sort(&(String.upcase(&1) <= String.upcase(&2)))
      ]
    end
  end

  # ----------------------------------------------------------------------------
  # For a list of characters, produce a list of all possible subsets of those
  # characters.
  # ----------------------------------------------------------------------------
  @spec all_subsets(permutations()) :: permutations()
  defp all_subsets(list) do
    list
    |> Enum.reduce([[]], fn element, acc ->
      acc ++ Enum.map(acc, &[element | &1])
    end)
    |> Enum.reject(fn x -> x == [] end)
  end
end
