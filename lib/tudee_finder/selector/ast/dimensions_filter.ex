defmodule TudeeFinder.Selector.AST.DimensionsFilter do
  defstruct [:dimensions]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter, for: __MODULE__ do
    def where(dimensions_filter) do
      dynamic([tudee], tudee.dimensions == ^dimensions_filter.dimensions)
    end
  end
end
