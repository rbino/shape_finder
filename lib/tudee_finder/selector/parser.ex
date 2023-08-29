defmodule TudeeFinder.Selector.Parser do
  import NimbleParsec

  alias TudeeFinder.Selector.AST.DimensionsFilter
  alias TudeeFinder.Selector.Parser.Error

  blankspace = ignore(ascii_string([?\s, ?\n, ?\r, ?\t], min: 1))

  smol =
    string("smol")
    |> replace(%DimensionsFilter{dimensions: :small})

  chonky =
    string("chonky")
    |> replace(%DimensionsFilter{dimensions: :big})

  dimensions =
    choice([
      smol,
      chonky
    ])

  dimensions_filter =
    optional(blankspace)
    |> concat(dimensions)
    |> optional(blankspace)
    |> label("dimensions filter")

  tudee_selector =
    dimensions_filter
    |> eos()

  defparsec(:parse_selector, tudee_selector)

  def parse(selector) do
    case parse_selector(selector) do
      {:ok, [ast_root], _rest, _context, _line, _column} ->
        {:ok, ast_root}

      {:error, reason, _rest, _context, {line, _}, column} ->
        {:error, %Error{message: reason, line: line, column: column}}
    end
  end
end
