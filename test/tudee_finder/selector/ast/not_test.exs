defmodule TudeeFinder.Selector.AST.NotTest do
  use TudeeFinder.DataCase, async: true

  alias TudeeFinder.Tudees
  alias TudeeFinder.Selector.Filter
  alias TudeeFinder.Selector.AST.Not
  alias TudeeFinder.Selector.AST.DimensionsFilter
  import TudeeFinder.TudeesFixtures

  describe "Filter.where/1" do
    test "negates the where clause created by the innermost expression" do
      big_tudee = tudee_fixture(%{dimensions: :big})
      _small_tudee = tudee_fixture(%{dimensions: :small})

      where =
        %Not{expression: %DimensionsFilter{dimensions: :small}}
        |> Filter.where()

      assert [big_tudee] == Tudees.list_tudees(where: where)
    end
  end
end
