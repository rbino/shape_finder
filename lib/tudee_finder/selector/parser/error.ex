defmodule TudeeFinder.Selector.Parser.Error do
  defexception [:message, :line, :column]
end
