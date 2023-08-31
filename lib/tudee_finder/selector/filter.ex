defprotocol TudeeFinder.Selector.Filter do
  @spec where(t) :: Ecto.Query.dynamic_expr()
  def where(value)

  @spec match?(t, TudeeFinder.Tudees.Tudee.t()) :: boolean()
  def match?(filter, tudee)
end
