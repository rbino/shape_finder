defmodule ShapeFinder.Selector.Parser do
  import NimbleParsec

  alias ShapeFinder.Shapes.Shape
  alias ShapeFinder.Selector.AST.BinaryOp
  alias ShapeFinder.Selector.AST.ColorFilter
  alias ShapeFinder.Selector.AST.DimensionFilter
  alias ShapeFinder.Selector.AST.Not
  alias ShapeFinder.Selector.AST.SideCountFilter
  alias ShapeFinder.Selector.Parser.Error

  blankspace = ignore(ascii_string([?\s, ?\n, ?\r, ?\t], min: 1))

  small =
    string("small")
    |> replace(%DimensionFilter{dimensions: :small})

  big =
    string("big")
    |> replace(%DimensionFilter{dimensions: :big})

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

  and_operator =
    choice([
      string("and"),
      string("AND")
    ])
    |> label("AND")
    |> replace(:and)

  or_operator =
    choice([
      string("or"),
      string("OR")
    ])
    |> label("OR")
    |> replace(:or)

  not_operator =
    choice([
      string("not"),
      string("NOT")
    ])
    |> label("NOT")
    |> replace(:not)

  dimension_filter =
    choice([small, big])
    |> label("dimension filter")

  color_filter =
    Ecto.Enum.values(Shape, :color)
    |> Enum.map(fn color ->
      color
      |> Atom.to_string()
      |> string()
      |> replace(%ColorFilter{color: color})
    end)
    |> choice()
    |> label("color filter")

  side_count_filter =
    ignore(string("sides"))
    |> optional(blankspace)
    |> concat(numeric_comparison_operator)
    |> optional(blankspace)
    |> integer(min: 1)
    |> label("side count filter")
    |> post_traverse(:build_side_count_filter)

  filter =
    choice([
      dimension_filter,
      color_filter,
      side_count_filter
    ])
    |> label("filter")

  parenthesized_expression =
    ignore(ascii_char([?(]))
    |> optional(blankspace)
    |> concat(parsec(:expression))
    |> optional(blankspace)
    |> ignore(ascii_char([?)]))

  negation =
    ignore(not_operator)
    |> concat(blankspace)
    |> parsec(:factor)
    |> post_traverse(:build_not)

  defcombinatorp :factor,
                 choice([negation, parenthesized_expression, filter])
                 |> label("factor")

  and_operation =
    parsec(:factor)
    |> concat(blankspace)
    |> ignore(and_operator)
    |> concat(blankspace)
    |> parsec(:term)
    |> post_traverse(:build_and)

  or_operation =
    parsec(:term)
    |> concat(blankspace)
    |> ignore(or_operator)
    |> concat(blankspace)
    |> parsec(:expression)
    |> post_traverse(:build_or)

  defcombinatorp :term,
                 choice([and_operation, parsec(:factor)])
                 |> label("term")

  defcombinatorp :expression,
                 choice([or_operation, parsec(:term)])
                 |> label("expression")

  shape_selector =
    optional(blankspace)
    |> parsec(:expression)
    |> optional(blankspace)
    |> eos()

  defparsec :parse_selector, shape_selector

  defp build_side_count_filter(rest, [value, operator], context, _line, _offset) do
    {rest, [%SideCountFilter{operator: operator, value: value}], context}
  end

  defp build_or(rest, [rhs, lhs], context, _line, _offset) do
    {rest, [%BinaryOp{lhs: lhs, rhs: rhs, operator: :or}], context}
  end

  defp build_and(rest, [rhs, lhs], context, _line, _offset) do
    {rest, [%BinaryOp{lhs: lhs, rhs: rhs, operator: :and}], context}
  end

  defp build_not(rest, [expression], context, _line, _offset) do
    {rest, [%Not{expression: expression}], context}
  end

  def parse(selector) do
    case parse_selector(selector) do
      {:ok, [ast_root], _rest, _context, _line, _column} ->
        {:ok, ast_root}

      {:error, reason, _rest, _context, {line, offset_to_start_of_line}, byte_offset} ->
        column = byte_offset - offset_to_start_of_line
        {:error, %Error{message: reason, line: line, column: column}}
    end
  end
end
