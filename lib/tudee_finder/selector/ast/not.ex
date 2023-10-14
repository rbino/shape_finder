defmodule TudeeFinder.Selector.AST.Not do
  defstruct [:expression]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(not_filter) do
      where = Filter.where(not_filter.expression)

      dynamic(not (^where))
    end

    def match?(not_filter, tudee) do
      not Filter.match?(not_filter.expression, tudee)
    end
  end
end
