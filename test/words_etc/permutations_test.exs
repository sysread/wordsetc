defmodule WordsEtc.PermutationsTest do
  use WordsEtc.DataCase, async: true

  alias WordsEtc.Permutations

  test "permutations" do
    assert [
             "a"
           ] = Permutations.all("a")

    assert [
             "a",
             "ab",
             "b",
             "ba"
           ] = Permutations.all("ab")

    assert [
             "a",
             "ab",
             "abc",
             "ac",
             "acb",
             "b",
             "ba",
             "bac",
             "bc",
             "bca",
             "c",
             "ca",
             "cab",
             "cb",
             "cba"
           ] = Permutations.all("abc")
  end

  test "casing" do
    assert [
             "a",
             "ab",
             "b",
             "ba"
           ] = Permutations.all("AB")
  end
end
