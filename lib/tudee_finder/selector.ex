defmodule TudeeFinder.Selector do
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.Parser

  def parse(selector) do
    Parser.parse(selector)
  end

  def where(selector) when is_binary(selector) do
    with {:ok, ast_root} <- parse(selector) do
      where(ast_root)
    end
  end

  def where(ast_root) when is_struct(ast_root) do
    {:ok, Filter.where(ast_root)}
  end
end
