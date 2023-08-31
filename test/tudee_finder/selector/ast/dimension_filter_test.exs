defmodule TudeeFinder.Selector.AST.DimensionFilterTest do
  use TudeeFinder.DataCase, async: true

  alias TudeeFinder.Tudees
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.AST.DimensionFilter
  import TudeeFinder.TudeesFixtures

  describe "Filter.where/1" do
    test "filters by dimensions" do
      small_tudee = tudee_fixture(%{dimensions: :small})
      _big_tudee = tudee_fixture(%{dimensions: :big})

      where =
        %DimensionFilter{dimensions: :small}
        |> Filter.where()

      assert [small_tudee] == Tudees.list_tudees(where: where)
    end
  end

  describe "Filter.match?/1" do
    test "returns true for the same dimensions" do
      tudee = tudee_fixture(%{dimensions: :big})

      assert %DimensionFilter{dimensions: :big} |> Filter.match?(tudee)
    end

    test "returns true for different dimensions" do
      tudee = tudee_fixture(%{dimensions: :small})

      refute %DimensionFilter{dimensions: :big} |> Filter.match?(tudee)
    end
  end
end
