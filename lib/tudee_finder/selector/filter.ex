defprotocol TudeeFinder.Selector.Filter do
  @spec where(t) :: Ecto.Query.dynamic_expr()
  def where(value)
end
