defmodule ShapeFinder.ShapesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShapeFinder.Shapes` context.
  """

  @doc """
  Generate a shape.
  """
  def shape_fixture(attrs \\ %{}) do
    {:ok, shape} =
      attrs
      |> Enum.into(%{
        color: :blue,
        sides: 7,
        dimensions: :big
      })
      |> ShapeFinder.Shapes.create_shape()

    shape
  end
end
