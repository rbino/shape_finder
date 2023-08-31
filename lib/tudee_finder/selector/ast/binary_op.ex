defmodule TudeeFinder.Selector.AST.BinaryOp do
  defstruct [:lhs, :rhs, :operator]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(binary_op) do
      lhs = Filter.where(binary_op.lhs)
      rhs = Filter.where(binary_op.rhs)

      combine(binary_op.operator, lhs, rhs)
    end

    defp combine(:and, lhs, rhs), do: dynamic([tudee], ^lhs and ^rhs)
    defp combine(:or, lhs, rhs), do: dynamic([tudee], ^lhs or ^rhs)
  end
end
