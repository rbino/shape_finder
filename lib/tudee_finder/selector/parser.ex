defmodule TudeeFinder.Selector.Parser do
  import NimbleParsec

  alias TudeeFinder.Tudees.Tudee

  alias TudeeFinder.Selector.AST.ColorFilter
  alias TudeeFinder.Selector.AST.DimensionsFilter
  alias TudeeFinder.Selector.AST.SideCountFilter
  alias TudeeFinder.Selector.Parser.Error

  blankspace = ignore(ascii_string([?\s, ?\n, ?\r, ?\t], min: 1))

  smol =
    string("smol")
    |> replace(%DimensionsFilter{dimensions: :small})

  chonky =
    string("chonky")
    |> replace(%DimensionsFilter{dimensions: :big})

  # Order is important here: if we put > before >=, the second will never match
  numeric_comparison_operator =
    choice([
      string("=="),
      string("!="),
      string(">="),
      string(">"),
      string("<="),
      string("<")
    ])
    |> map({String, :to_existing_atom, []})

  dimensions =
    choice([
      smol,
      chonky
    ])

  colors =
    Ecto.Enum.values(Tudee, :color)
    |> Enum.map(fn color ->
      color
      |> Atom.to_string()
      |> string()
      |> replace(%ColorFilter{color: color})
    end)
    |> choice()

  side_count_filter =
    ignore(string("sides"))
    |> optional(blankspace)
    |> concat(numeric_comparison_operator)
    |> optional(blankspace)
    |> integer(min: 1)
    |> label("side count filter")
    |> post_traverse(:build_side_count_filter)

  color_filter =
    colors
    |> label("color filter")

  dimensions_filter =
    dimensions
    |> label("dimensions filter")

  tudee_selector =
    optional(blankspace)
    |> choice([
      dimensions_filter,
      color_filter,
      side_count_filter
    ])
    |> optional(blankspace)
    |> eos()

  defparsec(:parse_selector, tudee_selector)

  defp build_side_count_filter(rest, [value, operator], context, _line, _offset) do
    {rest, [%SideCountFilter{operator: operator, value: value}], context}
  end

  def parse(selector) do
    case parse_selector(selector) do
      {:ok, [ast_root], _rest, _context, _line, _column} ->
        {:ok, ast_root}

      {:error, reason, _rest, _context, {line, _}, column} ->
        {:error, %Error{message: reason, line: line, column: column}}
    end
  end
end
