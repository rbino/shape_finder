defmodule TudeeFinder.Selector.AST.DimensionFilter do
  defstruct [:dimensions]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(dimension_filter) do
      dynamic([tudee], tudee.dimensions == ^dimension_filter.dimensions)
    end

    def match?(dimension_filter, tudee) do
      dimension_filter.dimensions == tudee.dimensions
    end
  end
end
