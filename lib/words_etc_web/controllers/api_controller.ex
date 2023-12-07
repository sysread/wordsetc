defmodule WordsEtcWeb.ApiController do
  use WordsEtcWeb, :controller
  alias ExRated, as: RateLimiter
  alias WordsEtc.SolveService

  @bucket_name "api-solve"

  # Number of allowed requests
  @rate_limit 10

  # Time period in seconds
  @period 60

  def solve(conn, params) do
    # Rate limit the requests
    case RateLimiter.check_rate(@bucket_name, @rate_limit, @period) do
      {:error, _} ->
        conn
        |> put_status(:too_many_requests)
        |> json(%{error: "Rate limit exceeded"})

      {:ok, _} ->
        process_solve_request(conn, params)
    end
  end

  defp process_solve_request(conn, params) do
    case SolveService.solve(params) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> json(%{solutions: format_result(result)})

      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(error)
    end
  end

  defp format_result(%{solutions: solutions}) do
    solutions
    |> Enum.map(fn {number, words} ->
      {number, Enum.map(words, &format_solution/1)}
    end)
    |> Enum.into(%{})
  end

  defp format_solution({word, score, definition}) do
    %{word: word, score: score, definition: definition}
  end
end
