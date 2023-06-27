defmodule Wordsetc.WordFinderTest do
  use Wordsetc.DataCase, async: true

  alias Wordsetc.WordFinder

  describe "define" do
    test "positive path" do
      assert {:ok,
              "to attack with a weapon resembling a club (a heavy piece of wood) [v MACED, MACES, MACING]"} =
               WordFinder.define("mace")
    end

    test "word not found" do
      assert {:error, :not_found} = WordFinder.define("macee")
    end
  end

  describe "words" do
    test "positive path" do
      assert {:ok, ["ab", "ba", "cab"]} = WordFinder.words("abc")
    end

    test "no words found" do
      assert {:error, :not_found} = WordFinder.words("qqq")
    end
  end
end
