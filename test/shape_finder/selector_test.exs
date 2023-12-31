defmodule ShapeFinder.SelectorTest do
  use ExUnit.Case

  alias ShapeFinder.Selector

  alias ShapeFinder.Selector.AST.{
    BinaryOp,
    ColorFilter,
    DimensionFilter,
    Not,
    SideCountFilter
  }

  alias ShapeFinder.Selector.Parser.Error

  describe "parse/1" do
    test "parses color filters" do
      Ecto.Enum.values(ShapeFinder.Shapes.Shape, :color)
      |> Enum.each(fn color ->
        assert {:ok, %ColorFilter{color: color}} == color |> to_string() |> Selector.parse()
      end)
    end

    test "parses dimensions filters" do
      assert {:ok, %DimensionFilter{dimensions: :big}} == Selector.parse("big")
      assert {:ok, %DimensionFilter{dimensions: :small}} == Selector.parse("small")
    end

    test "parses side count filters" do
      [:==, :!=, :>, :>=, :<, :<=]
      |> Enum.each(fn operator ->
        assert {:ok, %SideCountFilter{value: 42, operator: operator}} ==
                 Selector.parse("sides #{operator} 42")
      end)
    end

    test "parses negation" do
      Enum.each(["not", "NOT"], fn not_ ->
        assert {:ok, %Not{expression: %ColorFilter{color: :green}}} ==
                 Selector.parse("#{not_} green")
      end)
    end

    test "parses and" do
      Enum.each(["and", "AND"], fn and_ ->
        assert {:ok,
                %BinaryOp{
                  lhs: %ColorFilter{color: :red},
                  rhs: %DimensionFilter{dimensions: :small},
                  operator: :and
                }} == Selector.parse("red #{and_} small")
      end)
    end

    test "parses or" do
      Enum.each(["or", "OR"], fn or_ ->
        assert {:ok,
                %BinaryOp{
                  lhs: %SideCountFilter{value: 4, operator: :>},
                  rhs: %ColorFilter{color: :violet},
                  operator: :or
                }} == Selector.parse("sides > 4 #{or_} violet")
      end)
    end

    test "gives correct precedence without parentheses" do
      assert {:ok,
              %BinaryOp{
                operator: :or,
                lhs: %BinaryOp{
                  operator: :and,
                  lhs: %Not{
                    expression: %ColorFilter{color: :green}
                  },
                  rhs: %DimensionFilter{dimensions: :small}
                },
                rhs: %SideCountFilter{value: 4, operator: :<}
              }} == Selector.parse("not green and small or sides < 4")
    end

    test "handles parentheses correctly" do
      assert {:ok,
              %Not{
                expression: %BinaryOp{
                  operator: :and,
                  lhs: %ColorFilter{color: :green},
                  rhs: %BinaryOp{
                    operator: :or,
                    lhs: %DimensionFilter{dimensions: :small},
                    rhs: %SideCountFilter{value: 4, operator: :<}
                  }
                }
              }} == Selector.parse("not (green and (small or sides < 4))")
    end

    test "ignores extra whitespace" do
      assert {:ok,
              %Not{
                expression: %BinaryOp{
                  operator: :and,
                  lhs: %ColorFilter{color: :green},
                  rhs: %BinaryOp{
                    operator: :or,
                    lhs: %DimensionFilter{dimensions: :small},
                    rhs: %SideCountFilter{value: 4, operator: :<}
                  }
                }
              }} == Selector.parse("  NOT     (    green\n and \n\r(  small\t or sides<4)   )   ")
    end

    test "fails with incomplete expression" do
      assert {:error, %Error{}} = Selector.parse("green and")
    end

    test "fails with invalid factor" do
      assert {:error, %Error{}} = Selector.parse("foobar")
    end

    test "fails with invalid integer for sides" do
      assert {:error, %Error{}} = Selector.parse("sides > 3.5")
    end

    test "fails with invalid color" do
      assert {:error, %Error{}} = Selector.parse("beige")
    end
  end
end
