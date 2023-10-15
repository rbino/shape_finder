defmodule ShapeFinder.Selector.AST.BinaryOp do
  defstruct [:lhs, :rhs, :operator]

  import Ecto.Query

  alias ShapeFinder.Selector.Filter

  defimpl Filter do
    def where(binary_op) do
      lhs = Filter.where(binary_op.lhs)
      rhs = Filter.where(binary_op.rhs)

      case binary_op.operator do
        :and -> dynamic(^lhs and ^rhs)
        :or -> dynamic(^lhs or ^rhs)
      end
    end

    def match?(binary_op, shape) do
      case binary_op.operator do
        :and ->
          Filter.match?(binary_op.lhs, shape) and Filter.match?(binary_op.rhs, shape)

        :or ->
          Filter.match?(binary_op.lhs, shape) or Filter.match?(binary_op.rhs, shape)
      end
    end
  end
end
