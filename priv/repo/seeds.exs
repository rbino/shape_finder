# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ShapeFinder.Repo.insert!(%ShapeFinder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ShapeFinder.Shapes
alias ShapeFinder.Shapes.Shape

Range.new(0, 20)
|> Enum.each(fn _ ->
  attrs = %{
    dimensions: Enum.random(Ecto.Enum.values(Shape, :dimensions)),
    color: Enum.random(Ecto.Enum.values(Shape, :color)),
    sides: Enum.random(3..9)
  }

  {:ok, _} = Shapes.create_shape(attrs)
end)
