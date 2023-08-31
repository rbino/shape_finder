defmodule TudeeFinder.Selector.AST.Not do
  defstruct [:expression]

  import Ecto.Query

  alias TudeeFinder.Selector.Filter

  defimpl Filter do
    def where(not_filter) do
      where = Filter.where(not_filter.expression)

      dynamic([tudee], not (^where))
    end
  end
end
