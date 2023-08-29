defmodule TudeeFinder.Selector.Parser do
  import NimbleParsec

  alias TudeeFinder.Selector.AST.DimensionFilter
  alias TudeeFinder.Selector.Parser.Error

  blankspace = ignore(ascii_string([?\s, ?\n, ?\r, ?\t], min: 1))

  small =
    string("small")
    |> replace(%DimensionFilter{dimensions: :small})

  big =
    string("big")
    |> replace(%DimensionFilter{dimensions: :big})

  dimension_filter =
    choice([small, big])
    |> label("dimension filter")

  tudee_selector =
    optional(blankspace)
    |> concat(dimension_filter)
    |> optional(blankspace)
    |> eos()

  defparsec :parse_selector, tudee_selector

  def parse(selector) do
    case parse_selector(selector) do
      {:ok, [ast_root], _rest, _context, _line, _column} ->
        {:ok, ast_root}

      {:error, reason, _rest, _context, {line, _}, column} ->
        {:error, %Error{message: reason, line: line, column: column}}
    end
  end
end
