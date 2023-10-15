defmodule ShapeFinder.Selector.AST.BinaryOpTest do
  use ShapeFinder.DataCase, async: true

  alias ShapeFinder.Shapes
  alias ShapeFinder.Selector.Filter
  alias ShapeFinder.Selector.AST.BinaryOp
  alias ShapeFinder.Selector.AST.ColorFilter
  alias ShapeFinder.Selector.AST.DimensionFilter
  import ShapeFinder.ShapesFixtures

  describe "Filter.where/1" do
    setup do
      big_and_red = shape_fixture(%{dimensions: :big, color: :red})
      small_and_red = shape_fixture(%{dimensions: :small, color: :red})
      big_and_green = shape_fixture(%{dimensions: :big, color: :green})
      small_and_green = shape_fixture(%{dimensions: :small, color: :green})

      context = %{
        big_and_red: big_and_red,
        small_and_red: small_and_red,
        big_and_green: big_and_green,
        small_and_green: small_and_green
      }

      {:ok, context}
    end

    test "combines the filters with AND", ctx do
      %{
        small_and_green: small_and_green
      } = ctx

      where =
        %BinaryOp{
          operator: :and,
          lhs: %DimensionFilter{dimensions: :small},
          rhs: %ColorFilter{color: :green}
        }
        |> Filter.where()

      assert [small_and_green] == Shapes.list_shapes(where: where)
    end

    test "combines the filters with OR", ctx do
      %{
        big_and_red: big_and_red,
        small_and_red: small_and_red,
        big_and_green: big_and_green,
        small_and_green: small_and_green
      } = ctx

      where =
        %BinaryOp{
          operator: :or,
          lhs: %DimensionFilter{dimensions: :big},
          rhs: %ColorFilter{color: :red}
        }
        |> Filter.where()

      result = Shapes.list_shapes(where: where)

      assert length(result) == 3
      assert big_and_red in result
      assert small_and_red in result
      assert big_and_green in result
      assert small_and_green not in result
    end
  end

  describe "Filter.match?/1" do
    test "returns true if both filters return true with AND" do
      shape = shape_fixture(%{dimensions: :big, color: :red})

      assert %BinaryOp{
               operator: :and,
               lhs: %DimensionFilter{dimensions: :big},
               rhs: %ColorFilter{color: :red}
             }
             |> Filter.match?(shape)
    end

    test "returns false if one of the filters return false with AND" do
      shape = shape_fixture(%{dimensions: :big, color: :red})

      refute %BinaryOp{
               operator: :and,
               lhs: %DimensionFilter{dimensions: :big},
               rhs: %ColorFilter{color: :green}
             }
             |> Filter.match?(shape)
    end

    test "returns true if one of the filter returns true with OR" do
      shape = shape_fixture(%{dimensions: :big, color: :red})

      assert %BinaryOp{
               operator: :or,
               lhs: %DimensionFilter{dimensions: :small},
               rhs: %ColorFilter{color: :red}
             }
             |> Filter.match?(shape)
    end

    test "returns false if both the filters return false with OR" do
      shape = shape_fixture(%{dimensions: :big, color: :red})

      refute %BinaryOp{
               operator: :or,
               lhs: %DimensionFilter{dimensions: :small},
               rhs: %ColorFilter{color: :yellow}
             }
             |> Filter.match?(shape)
    end
  end
end
