defmodule WordsEtcWeb.ApiControllerTest do
  use WordsEtcWeb.ConnCase

  alias ExRated
  alias WordsEtcWeb.ApiController

  @bucket_name "api-solve"

  describe "solve/2 action" do
    setup do
      ExRated.delete_bucket(@bucket_name)
      :ok
    end

    test "returns solutions when valid parameters are provided", %{conn: conn} do
      # Set up the test params
      valid_params = %{"letters" => "test"}
      # Perform the action on ApiController directly with valid params
      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> ApiController.solve(valid_params)

      assert json_response(conn, 200)
    end

    test "returns bad request when invalid parameters are provided", %{conn: conn} do
      # Set up test params that would trigger error validation from SolveService
      invalid_params = %{"letters" => "***"}
      # Perform the action on ApiController directly with invalid params
      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> ApiController.solve(invalid_params)

      assert json_response(conn, 400)
    end

    test "output matches expected structure", %{conn: conn} do
      assert %{
               "solutions" => %{
                 "2" => [
                   %{"definition" => "yadda yadda yadda", "score" => 4, "word" => "BA"},
                   %{"definition" => "fnord fnord fnord", "score" => 4, "word" => "CA"},
                   %{"definition" => "like AA but with Bs", "score" => 3, "word" => "Bb"},
                   %{"definition" => "like BB but with Cs", "score" => 3, "word" => "Cc"},
                   %{"definition" => "blah blah blah", "score" => 1, "word" => "Aa"}
                 ],
                 "3" => [
                   %{
                     "definition" => "short for a lounge singer",
                     "score" => 7,
                     "word" => "BAC"
                   },
                   %{"definition" => "a taxi i guess", "score" => 7, "word" => "CAB"}
                 ],
                 "4" => [
                   %{
                     "definition" => "matches both letters and pattern (for matching abc + 2d1)",
                     "score" => 7,
                     "word" => "ABdC"
                   },
                   %{
                     "definition" => "matches both letters and pattern (for matching abc + 2d1)",
                     "score" => 7,
                     "word" => "ACdB"
                   }
                 ]
               }
             } =
               post(conn, ~p"/api/v1/solve", %{letters: "abc?"})
               |> json_response(200)
    end
  end
end
