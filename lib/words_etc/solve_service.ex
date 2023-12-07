defmodule WordsEtc.SolveService do
  alias WordsEtc.WordFinder

  @spec solve(params :: map) :: {:ok, map} | {:error, map}
  def solve(params) do
    letters = Map.get(params, "letters", "")
    filter = Map.get(params, "filter", "")
    sort = get_sort(params)

    with {:ok, input} <- validate_letters(letters),
         {:ok, filter} <- validate_filter(filter),
         {:ok, words} <- WordFinder.solve(input, filter, sort) do
      {:ok,
       %{
         letters: letters,
         filter: filter,
         sort: sort,
         solutions: words
       }}
    else
      {:invalid_input, reason} ->
        {:error, %{error: reason, solutions: []}}

      {:error, reason} ->
        {:error, %{error: reason, solutions: []}}
    end
  end

  defp validate_letters(input) do
    cond do
      input |> String.graphemes() |> Enum.count(&(&1 == "?")) > 2 ->
        {:invalid_input, "Up to 2 wildcards (?) are permitted"}

      input =~ ~r/^[a-zA-Z?]{1,10}$/i ->
        {:ok, String.upcase(input)}

      true ->
        {:invalid_input, "Expected between 1 and 10 letters or ? for wildcards"}
    end
  end

  defp validate_filter(input) do
    if input =~ ~r/^[a-zA-Z0-9]{0,5}$/ do
      {:ok, String.upcase(input)}
    else
      {:invalid_input, "Expected up to 5 letters or numbers"}
    end
  end

  defp get_sort(params) do
    case Map.get(params, "sort", "") do
      "score" -> :score
      "alpha" -> :alpha
      _ -> :score
    end
  end
end
