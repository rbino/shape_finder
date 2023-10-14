defmodule TudeeFinder.Selector.AST.BinaryOp do
  defstruct [:lhs, :rhs, :operator]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(binary_op) do
      lhs = Filter.where(binary_op.lhs)
      rhs = Filter.where(binary_op.rhs)

      case binary_op.operator do
        :and -> dynamic(^lhs and ^rhs)
        :or -> dynamic(^lhs or ^rhs)
      end
    end

    def match?(binary_op, tudee) do
      case binary_op.operator do
        :and ->
          Filter.match?(binary_op.lhs, tudee) and Filter.match?(binary_op.rhs, tudee)

        :or ->
          Filter.match?(binary_op.lhs, tudee) or Filter.match?(binary_op.rhs, tudee)
      end
    end
  end
end
