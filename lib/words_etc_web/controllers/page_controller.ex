defmodule WordsEtcWeb.PageController do
  use WordsEtcWeb, :controller

  alias WordsEtc.WordFinder

  def home(conn, _params) do
    conn
    |> assign(:page_title, "Welcome")
    |> render(:home, layout: false)
  end

  def solve(conn, params) do
    letters = Map.get(params, "letters", "")
    filter = Map.get(params, "filter", "")
    sort = get_sort(params)

    with {:ok, input} <- validate_letters(letters),
         {:ok, _filter} <- validate_filter(filter),
         {:ok, words} <- WordFinder.solve(input, sort) do
      conn
      |> assign(:error, nil)
      |> assign(:solutions, words)
    else
      {:invalid_input, reason} ->
        conn
        |> assign(:error, reason)
        |> assign(:solutions, [])

      {:error, reason} ->
        conn
        |> assign(:error, reason)
        |> assign(:solutions, [])
    end
    |> assign(:letters, letters)
    |> assign(:filter, filter)
    |> assign(:sort, sort)
    |> assign(:page_title, "Solutions")
    |> render(:solve, layout: false)
  end

  def validate_letters(input) do
    cond do
      input |> String.graphemes() |> Enum.count(&(&1 == "?")) > 2 ->
        {:invalid_input, "Up to 2 wildcards (?) are permitted"}

      input =~ ~r/^[a-zA-Z?]{1,10}$/i ->
        {:ok, String.upcase(input)}

      true ->
        {:invalid_input, "Expected between 1 and 10 letters or ? for wildcards"}
    end
  end

  def validate_filter(input) do
    if input =~ ~r/^[A-Z0-9]{0,5}$/ do
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
