defmodule WordsEtc.WordFinderTest do
  use WordsEtc.DataCase, async: true

  alias WordsEtc.WordFinder

  describe "define" do
    test "positive path" do
      assert {:ok,
              "to attack with a weapon resembling a club (a heavy piece of wood) [v MACED, MACES, MACING]"} =
               WordFinder.define("mace")
    end

    test "word not found" do
      assert {:error, :not_found} = WordFinder.define("macee")
    end

    test "called with empty string" do
      assert {:error, :not_found} = WordFinder.define("")
    end
  end

  describe "words" do
    test "positive path" do
      assert {:ok, ["ab", "ba", "cab"]} = WordFinder.words("abc")
    end

    test "no words found" do
      assert {:error, :not_found} = WordFinder.words("qqq")
    end

    test "called with emtpy string" do
      assert {:error, :not_found} = WordFinder.words("")
    end
  end

  describe "solve" do
    test "positive path" do
      assert {:ok,
              [
                {3,
                 [
                   {"cab", 7, "to take or drive a taxicab [v CABBED, CABBING, CABS]"}
                 ]},
                {2,
                 [
                   {"ab", 4, "an abdominal muscle [n ABS]"},
                   {"ba", 4, "the eternal soul, in Egyptian mythology [n BAS]"}
                 ]}
              ]} = WordFinder.solve("abc")
    end
  end
end
