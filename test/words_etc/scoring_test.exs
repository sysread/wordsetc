defmodule WordsEtc.ScoringTest do
  use ExUnit.Case

  alias WordsEtc.Scoring

  describe "calculate/1" do
    test "calculates the Scrabble score of a word" do
      assert Scoring.calculate("hello") == 8
      assert Scoring.calculate("world") == 9
      assert Scoring.calculate("elixir") == 13
      assert Scoring.calculate("Phoenix") == 19
      assert Scoring.calculate("scrabble") == 14
    end

    test "handles uppercase letters" do
      assert Scoring.calculate("HELLO") == 8
      assert Scoring.calculate("WORLD") == 9
      assert Scoring.calculate("ELIXIR") == 13
      assert Scoring.calculate("PHOENIX") == 19
      assert Scoring.calculate("SCRABBLE") == 14
    end

    test "returns 0 for an empty string" do
      assert Scoring.calculate("") == 0
    end
  end
end
