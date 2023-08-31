defmodule TudeeFinder.Selector.AST.ColorFilter do
  defstruct [:color]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(color_filter) do
      dynamic([tudee], tudee.color == ^color_filter.color)
    end
  end
end
