defmodule TudeeFinder.Selector.AST.NotTest do
  use TudeeFinder.DataCase, async: true

  alias TudeeFinder.Tudees
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.AST.Not
  alias TudeeFinder.Selector.AST.ColorFilter
  alias TudeeFinder.Selector.AST.DimensionFilter
  import TudeeFinder.TudeesFixtures

  describe "Filter.where/1" do
    test "negates the where clause created by the innermost expression" do
      big_tudee = tudee_fixture(%{dimensions: :big})
      _small_tudee = tudee_fixture(%{dimensions: :small})

      where =
        %Not{expression: %DimensionFilter{dimensions: :small}}
        |> Filter.where()

      assert [big_tudee] == Tudees.list_tudees(where: where)
    end
  end

  describe "Filter.match?/1" do
    test "returns true if the inner expression returns false" do
      tudee = tudee_fixture(%{color: :green})

      assert %Not{expression: %ColorFilter{color: :red}} |> Filter.match?(tudee)
    end

    test "returns false if the inner expression returns true" do
      tudee = tudee_fixture(%{color: :yellow})

      refute %Not{expression: %ColorFilter{color: :yellow}} |> Filter.match?(tudee)
    end
  end
end
