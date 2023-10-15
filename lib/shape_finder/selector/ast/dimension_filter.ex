defmodule ShapeFinder.Selector.AST.DimensionFilter do
  defstruct [:dimensions]

  import Ecto.Query

  alias ShapeFinder.Selector.Filter

  defimpl Filter do
    def where(dimension_filter) do
      dynamic([shape], shape.dimensions == ^dimension_filter.dimensions)
    end

    def match?(dimension_filter, shape) do
      dimension_filter.dimensions == shape.dimensions
    end
  end
end
