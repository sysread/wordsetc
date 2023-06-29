defmodule WordsEtc.WordFinderTest do
  use WordsEtc.DataCase, async: true

  alias WordsEtc.WordFinder

  describe "solve" do
    test "positive path" do
      assert {:ok,
              [
                {3,
                 [
                   {"BAC", 7, "short for a lounge singer"},
                   {"CAB", 7, "a taxi i guess"}
                 ]},
                {2,
                 [
                   {"BA", 4, "yadda yadda yadda"},
                   {"CA", 4, "fnord fnord fnord"}
                 ]}
              ]} =
               WordFinder.solve("abc")
    end

    test "wildcards" do
      assert {:ok,
              [
                {3,
                 [
                   {"CAb", 4, "a taxi i guess"},
                   {"bAC", 4, "short for a lounge singer"}
                 ]},
                {2,
                 [
                   {"CA", 4, "fnord fnord fnord"},
                   {"Cc", 3, "like BB but with Cs"},
                   {"Aa", 1, "blah blah blah"},
                   {"bA", 1, "yadda yadda yadda"}
                 ]}
              ]} =
               WordFinder.solve("a?c")
    end
  end
end
