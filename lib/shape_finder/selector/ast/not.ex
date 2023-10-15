defmodule ShapeFinder.Selector.AST.Not do
  defstruct [:expression]

  import Ecto.Query

  alias ShapeFinder.Selector.Filter

  defimpl Filter do
    def where(not_filter) do
      where = Filter.where(not_filter.expression)

      dynamic(not (^where))
    end

    def match?(not_filter, shape) do
      not Filter.match?(not_filter.expression, shape)
    end
  end
end
