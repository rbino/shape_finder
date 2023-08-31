defmodule TudeeFinder.Selector.AST.DimensionFilter do
  defstruct [:dimensions]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(dimension_filter) do
      dynamic([tudee], tudee.dimensions == ^dimension_filter.dimensions)
    end
  end
end
