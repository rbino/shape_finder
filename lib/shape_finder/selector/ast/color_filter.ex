defmodule ShapeFinder.Selector.AST.ColorFilter do
  defstruct [:color]

  import Ecto.Query

  alias ShapeFinder.Selector.Filter

  defimpl Filter do
    def where(color_filter) do
      dynamic([shape], shape.color == ^color_filter.color)
    end

    def match?(color_filter, shape) do
      color_filter.color == shape.color
    end
  end
end
