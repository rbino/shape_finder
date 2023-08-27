defmodule TudeeFinder.TudeesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TudeeFinder.Tudees` context.
  """

  @doc """
  Generate a tudee.
  """
  def tudee_fixture(attrs \\ %{}) do
    {:ok, tudee} =
      attrs
      |> Enum.into(%{
        color: :blue,
        sides: 42,
        dimensions: :big
      })
      |> TudeeFinder.Tudees.create_tudee()

    tudee
  end
end
