defmodule ShapeFinder.Selector.AST.SideCountFilterTest do
  use ShapeFinder.DataCase, async: true

  alias ShapeFinder.Shapes
  alias ShapeFinder.Selector.Filter
  alias ShapeFinder.Selector.AST.SideCountFilter
  import ShapeFinder.ShapesFixtures

  describe "Filter.where/1" do
    test "filters by side count" do
      square = shape_fixture(%{sides: 4})
      pentagon = shape_fixture(%{sides: 5})
      hexagon = shape_fixture(%{sides: 6})

      where =
        %SideCountFilter{value: 5, operator: :<=}
        |> Filter.where()

      result = Shapes.list_shapes(where: where)

      assert length(result) == 2
      assert square in result
      assert pentagon in result
      assert hexagon not in result
    end
  end

  describe "Filter.match?/1" do
    test "returns true if the comparison evaluates to true" do
      shape = shape_fixture(%{sides: 7})

      assert %SideCountFilter{operator: :==, value: 7} |> Filter.match?(shape)
    end

    test "returns false if the comparison evaluates to false" do
      shape = shape_fixture(%{sides: 4})

      refute %SideCountFilter{operator: :>, value: 8} |> Filter.match?(shape)
    end
  end
end
