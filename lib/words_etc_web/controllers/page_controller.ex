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

    case get_solutions(letters) do
      {:error, reason} ->
        conn
        |> assign(:error, reason)
        |> assign(:solutions, [])

      {:ok, words} ->
        conn
        |> assign(:solutions, words)
    end
    |> assign(:letters, letters)
    |> assign(:page_title, "Solutions")
    |> render(:solve, layout: false)
  end

  defp get_solutions(letters) do
    case WordFinder.words(letters) do
      {:error, reason} ->
        {:error, reason}

      {:ok, words} ->
        words =
          words
          |> Enum.map(fn word ->
            WordFinder.define(word)
            |> case do
              {:error, :not_found} -> {word, "definition not found"}
              {:ok, definition} -> {word, definition}
            end
          end)
          |> Enum.group_by(fn {word, _definition} -> String.length(word) end)
          |> Enum.sort_by(fn {count, _words} -> count end, &>=/2)

        {:ok, words}
    end
  end
end
