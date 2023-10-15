defmodule ShapeFinder.Selector.AST.ColorFilterTest do
  use ShapeFinder.DataCase, async: true

  alias ShapeFinder.Shapes
  alias ShapeFinder.Selector.Filter
  alias ShapeFinder.Selector.AST.ColorFilter
  import ShapeFinder.ShapesFixtures

  describe "Filter.where/1" do
    test "filters by color" do
      violet_shape = shape_fixture(%{color: :violet})
      _red_shape = shape_fixture(%{color: :red})

      where =
        %ColorFilter{color: :violet}
        |> Filter.where()

      assert [violet_shape] == Shapes.list_shapes(where: where)
    end
  end

  describe "Filter.match?/1" do
    test "returns true for the same color" do
      shape = shape_fixture(%{color: :green})

      assert %ColorFilter{color: :green} |> Filter.match?(shape)
    end

    test "returns true for a different color" do
      shape = shape_fixture(%{color: :red})

      refute %ColorFilter{color: :yellow} |> Filter.match?(shape)
    end
  end
end
