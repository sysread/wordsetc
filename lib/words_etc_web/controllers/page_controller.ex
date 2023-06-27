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

    case WordFinder.solve(letters) do
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
end
