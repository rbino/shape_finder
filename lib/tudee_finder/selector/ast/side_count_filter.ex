defmodule TudeeFinder.Selector.AST.SideCountFilter do
  defstruct [:operator, :value]

  import Ecto.Query

  alias __MODULE__
  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(side_count_filter) do
      %SideCountFilter{
        operator: operator,
        value: value
      } = side_count_filter

      sides_compare(operator, value)
    end

    # TODO: could be probably more compact with some macro magic, but not today
    defp sides_compare(:==, value), do: dynamic([tudee], tudee.sides == ^value)
    defp sides_compare(:!=, value), do: dynamic([tudee], tudee.sides != ^value)
    defp sides_compare(:>=, value), do: dynamic([tudee], tudee.sides >= ^value)
    defp sides_compare(:>, value), do: dynamic([tudee], tudee.sides > ^value)
    defp sides_compare(:<=, value), do: dynamic([tudee], tudee.sides <= ^value)
    defp sides_compare(:<, value), do: dynamic([tudee], tudee.sides < ^value)
  end
end
