defmodule WordsEtc.WordFinderTest do
  use WordsEtc.DataCase, async: true

  alias WordsEtc.WordFinder

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
