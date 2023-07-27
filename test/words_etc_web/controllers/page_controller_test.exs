defmodule WordsEtcWeb.PageControllerTest do
  use WordsEtcWeb.ConnCase

  describe "basics" do
    test "GET /", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200)
    end
  end

  describe "input validation" do
    test "too many characters", %{conn: conn} do
      conn = post(conn, ~p"/", %{letters: "abcdefghijk"})
      assert html_response(conn, 200) =~ "Expected between 1 and 10 letters or ? for wildcards"
    end

    test "too many wildcards", %{conn: conn} do
      conn = post(conn, ~p"/", %{letters: "????"})
      assert html_response(conn, 200) =~ "Up to 2 wildcards (?) are permitted"
    end

    test "invalid characters", %{conn: conn} do
      assert post(conn, ~p"/", %{letters: "!%$"}) |> html_response(200) =~
               "Expected between 1 and 10 letters or ? for wildcards"

      assert post(conn, ~p"/", %{letters: "123"}) |> html_response(200) =~
               "Expected between 1 and 10 letters or ? for wildcards"
    end

    test "valid input", %{conn: conn} do
      assert conn |> post(~p"/", %{letters: "abc?"}) |> html_response(200)
      assert conn |> post(~p"/", %{letters: "abc?", sort: "score"}) |> html_response(200)
      assert conn |> post(~p"/", %{letters: "abc?", sort: "alpha"}) |> html_response(200)
    end
  end
end
