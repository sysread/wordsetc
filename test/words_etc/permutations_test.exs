defmodule WordsEtc.PermutationsTest do
  use WordsEtc.DataCase, async: true

  alias WordsEtc.Permutations

  test "permutations" do
    assert [
             "A"
           ] = Permutations.all("A")

    assert [
             "A",
             "AB",
             "B"
           ] = Permutations.all("AB")

    assert [
             "A",
             "AB",
             "ABC",
             "AC",
             "B",
             "BC",
             "C"
           ] = Permutations.all("ABC")
  end

  test "casing" do
    assert [
             "A",
             "AB",
             "B"
           ] = Permutations.all("AB")
  end

  test "wildcards" do
    # Ax for x in a-z
    assert length(Permutations.all("A?")) == 2 * 26

    # AxC for x in a-z, -1 for the duplicated subset of AcC (Ac, AC)
    assert length(Permutations.all("A?C")) == 2 * 2 * 26 - 1

    # (Ax for x in a-z) + (x for y in {a-z, a-z})
    assert length(Permutations.all("A??")) == 2 * 26 + 26 * 26
  end
end
