defmodule WordsEtc.CombinationsTest do
  use WordsEtc.DataCase, async: true

  alias WordsEtc.Combinations

  test "permutations" do
    assert [
             "A"
           ] = Combinations.all("A")

    assert [
             "A",
             "AB",
             "B"
           ] = Combinations.all("AB") |> Enum.sort()

    assert [
             "A",
             "AB",
             "ABC",
             "AC",
             "B",
             "BC",
             "C"
           ] = Combinations.all("ABC") |> Enum.sort()
  end

  test "ordering" do
    # Characters in result strings are ordered alphabetically despite the order
    # of their input.
    assert [
             "A",
             "AB",
             "ABC",
             "AC",
             "B",
             "BC",
             "C"
           ] = Combinations.all("CBA") |> Enum.sort()
  end

  test "casing" do
    assert [
             "A",
             "AB",
             "B"
           ] = Combinations.all("AB") |> Enum.sort()
  end

  test "wildcards" do
    # 1 for each letter in a-z
    assert length(Combinations.all("?")) == 26

    # 1 for each letter in a-z, and all unique combinations of 2 letters
    assert length(Combinations.all("??")) == Enum.sum(1..26) + 26

    # Ax for x in a-z
    assert length(Combinations.all("A?")) == 2 * 26

    # AxC for x in a-z, -1 for the duplicated subset of AcC (Ac, AC)
    assert length(Combinations.all("A?C")) == 2 * 2 * 26 - 1

    # (Ax for x in a-z) + (x for y in {a-z, a-z})
    assert length(Combinations.all("A??")) == 2 * 26 + 26 * 26
  end

  test "prevents duplicates" do
    assert ["A", "AA"] = Combinations.all("AA")
  end
end
