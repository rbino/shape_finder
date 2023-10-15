defmodule ShapeFinder.Selector.AST.DimensionFilterTest do
  use ShapeFinder.DataCase, async: true

  alias ShapeFinder.Shapes
  alias ShapeFinder.Selector.Filter
  alias ShapeFinder.Selector.AST.DimensionFilter
  import ShapeFinder.ShapesFixtures

  describe "Filter.where/1" do
    test "filters by dimensions" do
      small_shape = shape_fixture(%{dimensions: :small})
      _big_shape = shape_fixture(%{dimensions: :big})

      where =
        %DimensionFilter{dimensions: :small}
        |> Filter.where()

      assert [small_shape] == Shapes.list_shapes(where: where)
    end
  end

  describe "Filter.match?/1" do
    test "returns true for the same dimensions" do
      shape = shape_fixture(%{dimensions: :big})

      assert %DimensionFilter{dimensions: :big} |> Filter.match?(shape)
    end

    test "returns true for different dimensions" do
      shape = shape_fixture(%{dimensions: :small})

      refute %DimensionFilter{dimensions: :big} |> Filter.match?(shape)
    end
  end
end
