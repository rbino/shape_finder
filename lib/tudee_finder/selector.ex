defmodule TudeeFinder.Selector do
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.Parser

  def where(selector) do
    with {:ok, ast} <- Parser.parse(selector) do
      {:ok, Filter.where(ast)}
    end
  end
end
