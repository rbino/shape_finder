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
end
