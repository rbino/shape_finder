defmodule ShapeFinder.Selector.AST.NotTest do
  use ShapeFinder.DataCase, async: true

  alias ShapeFinder.Shapes
  alias ShapeFinder.Selector.Filter
  alias ShapeFinder.Selector.AST.Not
  alias ShapeFinder.Selector.AST.ColorFilter
  alias ShapeFinder.Selector.AST.DimensionFilter
  import ShapeFinder.ShapesFixtures

  describe "Filter.where/1" do
    test "negates the where clause created by the innermost expression" do
      big_shape = shape_fixture(%{dimensions: :big})
      _small_shape = shape_fixture(%{dimensions: :small})

      where =
        %Not{expression: %DimensionFilter{dimensions: :small}}
        |> Filter.where()

      assert [big_shape] == Shapes.list_shapes(where: where)
    end
  end

  describe "Filter.match?/1" do
    test "returns true if the inner expression returns false" do
      shape = shape_fixture(%{color: :green})

      assert %Not{expression: %ColorFilter{color: :red}} |> Filter.match?(shape)
    end

    test "returns false if the inner expression returns true" do
      shape = shape_fixture(%{color: :yellow})

      refute %Not{expression: %ColorFilter{color: :yellow}} |> Filter.match?(shape)
    end
  end
end
