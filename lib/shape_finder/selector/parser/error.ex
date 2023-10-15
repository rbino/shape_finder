defmodule ShapeFinder.Selector.Parser.Error do
  defexception [:message, :line, :column]
end
