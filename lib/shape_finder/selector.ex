defmodule ShapeFinder.Selector do
  alias ShapeFinder.Shapes.Shape
  alias ShapeFinder.Selector.Filter
  alias ShapeFinder.Selector.Parser

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

  def match?(%Shape{} = shape, ast_root) when is_struct(ast_root) do
    Filter.match?(ast_root, shape)
  end
end
