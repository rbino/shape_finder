defmodule TudeeFinder.Selector.AST.DimensionsFilterTest do
  use TudeeFinder.DataCase, async: true

  alias TudeeFinder.Tudees
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.AST.DimensionsFilter
  import TudeeFinder.TudeesFixtures

  describe "Filter.where/1" do
    test "filters by dimensions" do
      small_tudee = tudee_fixture(%{dimensions: :small})
      _big_tudee = tudee_fixture(%{dimensions: :big})

      where =
        %DimensionsFilter{dimensions: :small}
        |> Filter.where()

      assert [small_tudee] == Tudees.list_tudees(where: where)
    end
  end
end
