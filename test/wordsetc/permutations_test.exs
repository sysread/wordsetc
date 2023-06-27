defmodule Wordsetc.PermutationsTest do
  use Wordsetc.DataCase, async: true

  alias Wordsetc.Permutations

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
end
