defmodule TudeeFinder.Selector.AST.SideCountFilterTest do
  use TudeeFinder.DataCase, async: true

  alias TudeeFinder.Tudees
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.AST.SideCountFilter
  import TudeeFinder.TudeesFixtures

  describe "Filter.where/1" do
    test "filters by side count" do
      square = tudee_fixture(%{sides: 4})
      pentagon = tudee_fixture(%{sides: 5})
      hexagon = tudee_fixture(%{sides: 6})

      where =
        %SideCountFilter{value: 5, operator: :<=}
        |> Filter.where()

      result = Tudees.list_tudees(where: where)

      assert length(result) == 2
      assert square in result
      assert pentagon in result
      assert hexagon not in result
    end
  end
end
