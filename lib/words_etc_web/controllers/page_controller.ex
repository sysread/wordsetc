defmodule WordsEtcWeb.PageController do
  use WordsEtcWeb, :controller
  alias WordsEtc.SolveService

  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
  end

  def solve(conn, params) do
    case SolveService.solve(params) do
      {:ok, %{letters: letters, filter: filter, sort: sort, solutions: solutions}} ->
        conn
        |> assign(:letters, letters)
        |> assign(:filter, filter)
        |> assign(:sort, sort)
        |> assign(:solutions, solutions)
        |> assign(:error, nil)
        |> assign(:page_title, "Solutions")
        |> render(:solve, layout: false)

      {:error, %{error: error}} ->
        conn
        |> assign(:error, error)
        |> assign(:letters, Map.get(params, "letters"))
        |> assign(:filter, Map.get(params, "filter"))
        |> assign(:sort, Map.get(params, "sort"))
        |> assign(:solutions, [])
        |> assign(:page_title, "Solutions")
        |> render(:solve, layout: false)
    end
  end
end
