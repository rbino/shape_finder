defmodule TudeeFinder.Selector.AST.DimensionsFilter do
  defstruct [:dimensions]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(dimensions_filter) do
      dynamic([tudee], tudee.dimensions == ^dimensions_filter.dimensions)
    end

    def match?(dimensions_filter, tudee) do
      dimensions_filter.dimensions == tudee.dimensions
    end
  end
end
