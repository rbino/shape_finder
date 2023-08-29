# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TudeeFinder.Repo.insert!(%TudeeFinder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TudeeFinder.Tudees
alias TudeeFinder.Tudees.Tudee

Range.new(0, 20)
|> Enum.each(fn _ ->
  attrs = %{
    dimensions: Enum.random(Ecto.Enum.values(Tudee, :dimensions)),
    color: Enum.random(Ecto.Enum.values(Tudee, :color)),
    sides: Enum.random(3..9)
  }

  {:ok, _} = Tudees.create_tudee(attrs)
end)
