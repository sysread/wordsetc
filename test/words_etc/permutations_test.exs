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
             "B",
             "BA"
           ] = Permutations.all("AB")

    assert [
             "A",
             "AB",
             "ABC",
             "AC",
             "ACB",
             "B",
             "BA",
             "BAC",
             "BC",
             "BCA",
             "C",
             "CA",
             "CAB",
             "CB",
             "CBA"
           ] = Permutations.all("ABC")
  end

  test "casing" do
    assert [
             "A",
             "AB",
             "B",
             "BA"
           ] = Permutations.all("AB")
  end
end
