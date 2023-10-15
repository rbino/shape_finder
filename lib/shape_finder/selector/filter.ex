defprotocol ShapeFinder.Selector.Filter do
  @spec where(t) :: Ecto.Query.dynamic_expr()
  def where(value)

  @spec match?(t, ShapeFinder.Shapes.Shape.t()) :: boolean()
  def match?(filter, shape)
end
