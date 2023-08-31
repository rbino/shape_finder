defmodule TudeeFinder.Selector.AST.ColorFilterTest do
  use TudeeFinder.DataCase, async: true

  alias TudeeFinder.Tudees
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.AST.ColorFilter
  import TudeeFinder.TudeesFixtures

  describe "Filter.where/1" do
    test "filters by color" do
      violet_tudee = tudee_fixture(%{color: :violet})
      _red_tudee = tudee_fixture(%{color: :red})

      where =
        %ColorFilter{color: :violet}
        |> Filter.where()

      assert [violet_tudee] == Tudees.list_tudees(where: where)
    end
  end
end
