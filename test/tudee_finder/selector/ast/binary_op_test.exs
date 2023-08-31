defmodule TudeeFinder.Selector.AST.BinaryOpTest do
  use TudeeFinder.DataCase, async: true

  alias TudeeFinder.Tudees
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.AST.BinaryOp
  alias TudeeFinder.Selector.AST.ColorFilter
  alias TudeeFinder.Selector.AST.DimensionsFilter
  import TudeeFinder.TudeesFixtures

  describe "Filter.where/1" do
    setup do
      big_and_red = tudee_fixture(%{dimensions: :big, color: :red})
      small_and_red = tudee_fixture(%{dimensions: :small, color: :red})
      big_and_green = tudee_fixture(%{dimensions: :big, color: :green})
      small_and_green = tudee_fixture(%{dimensions: :small, color: :green})

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
          lhs: %DimensionsFilter{dimensions: :small},
          rhs: %ColorFilter{color: :green}
        }
        |> Filter.where()

      assert [small_and_green] == Tudees.list_tudees(where: where)
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
          lhs: %DimensionsFilter{dimensions: :big},
          rhs: %ColorFilter{color: :red}
        }
        |> Filter.where()

      result = Tudees.list_tudees(where: where)

      assert length(result) == 3
      assert big_and_red in result
      assert small_and_red in result
      assert big_and_green in result
      assert small_and_green not in result
    end
  end

  describe "Filter.match?/1" do
    test "returns true if both filters return true with AND" do
      tudee = tudee_fixture(%{dimensions: :big, color: :red})

      assert %BinaryOp{
               operator: :and,
               lhs: %DimensionsFilter{dimensions: :big},
               rhs: %ColorFilter{color: :red}
             }
             |> Filter.match?(tudee)
    end

    test "returns false if one of the filters return false with AND" do
      tudee = tudee_fixture(%{dimensions: :big, color: :red})

      refute %BinaryOp{
               operator: :and,
               lhs: %DimensionsFilter{dimensions: :big},
               rhs: %ColorFilter{color: :green}
             }
             |> Filter.match?(tudee)
    end

    test "returns true if one of the filter returns true with OR" do
      tudee = tudee_fixture(%{dimensions: :big, color: :red})

      assert %BinaryOp{
               operator: :or,
               lhs: %DimensionsFilter{dimensions: :small},
               rhs: %ColorFilter{color: :red}
             }
             |> Filter.match?(tudee)
    end

    test "returns false if both the filters return false with OR" do
      tudee = tudee_fixture(%{dimensions: :big, color: :red})

      refute %BinaryOp{
               operator: :or,
               lhs: %DimensionsFilter{dimensions: :small},
               rhs: %ColorFilter{color: :yellow}
             }
             |> Filter.match?(tudee)
    end
  end
end
