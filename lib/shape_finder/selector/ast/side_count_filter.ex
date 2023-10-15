defmodule ShapeFinder.Selector.AST.SideCountFilter do
  defstruct [:operator, :value]

  import Ecto.Query

  alias __MODULE__
  alias ShapeFinder.Selector.Filter

  defimpl Filter do
    def where(side_count_filter) do
      %SideCountFilter{
        operator: operator,
        value: value
      } = side_count_filter

      sides_compare_query(operator, value)
    end

    # TODO: could be probably more compact with some macro magic, but not today
    defp sides_compare_query(:==, value), do: dynamic([shape], shape.sides == ^value)
    defp sides_compare_query(:!=, value), do: dynamic([shape], shape.sides != ^value)
    defp sides_compare_query(:>=, value), do: dynamic([shape], shape.sides >= ^value)
    defp sides_compare_query(:>, value), do: dynamic([shape], shape.sides > ^value)
    defp sides_compare_query(:<=, value), do: dynamic([shape], shape.sides <= ^value)
    defp sides_compare_query(:<, value), do: dynamic([shape], shape.sides < ^value)

    def match?(side_count_filter, shape) do
      sides_compare(side_count_filter.operator, shape.sides, side_count_filter.value)
    end

    # TODO: see above
    defp sides_compare(:==, lhs, rhs), do: lhs == rhs
    defp sides_compare(:!=, lhs, rhs), do: lhs != rhs
    defp sides_compare(:>=, lhs, rhs), do: lhs >= rhs
    defp sides_compare(:>, lhs, rhs), do: lhs > rhs
    defp sides_compare(:<=, lhs, rhs), do: lhs <= rhs
    defp sides_compare(:<, lhs, rhs), do: lhs < rhs
  end
end
