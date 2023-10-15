defmodule ShapeFinderWeb.ShapeLive.ShapeComponent do
  use Phoenix.Component

  def shape_svg(assigns) do
    ~H"""
    <svg class={[fill(@shape.color)]} viewBox="0 0 220 220">
      <polygon points={polygon_points(110, 110, @shape.sides, radius(@shape.dimensions))} />
    </svg>
    """
  end

  defp polygon_points(cx, cy, sides, radius) do
    angle = 360 / sides
    offset = (90 - (180 - angle) / 2) |> to_radians()

    # Do this to center both even and odd side polygons at the same height
    adjusted_cy =
      if rem(sides, 2) == 1 do
        cy + radius * (1 - :math.cos(:math.pi() / sides)) / 2
      else
        cy
      end

    Range.new(0, sides)
    |> Enum.map(fn side_idx ->
      theta = offset + to_radians(angle * side_idx)
      x = cx + radius * :math.cos(theta + :math.pi() * 0.5)
      y = adjusted_cy + radius * :math.sin(theta + :math.pi() * 0.5)

      "#{x},#{y}"
    end)
    |> Enum.join(" ")
  end

  defp to_radians(degrees), do: :math.pi() * degrees / 180

  # Why not just "fill-#{color}-500"? Because otherwise TailWind doesn't detect the classes
  # as being used and tree-shakes them away.
  # See https://tailwindcss.com/docs/content-configuration#dynamic-class-names
  defp fill(:blue), do: "fill-blue-800"
  defp fill(:red), do: "fill-red-600"
  defp fill(:green), do: "fill-green-600"
  defp fill(:yellow), do: "fill-yellow-400"
  defp fill(:violet), do: "fill-violet-400"
  defp fill(:pink), do: "fill-pink-400"
  defp fill(:orange), do: "fill-orange-500"

  defp radius(:small), do: 50
  defp radius(:big), do: 100
end
