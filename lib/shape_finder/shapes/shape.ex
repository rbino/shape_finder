defmodule ShapeFinder.Shapes.Shape do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          color: color(),
          sides: non_neg_integer(),
          dimensions: dimensions()
        }
  @type color :: :blue | :red | :green | :yellow | :violet | :pink | :orange
  @type dimensions :: :big | :small

  schema "shapes" do
    field :color, Ecto.Enum, values: [:blue, :red, :green, :yellow, :violet, :pink, :orange]
    field :sides, :integer
    field :dimensions, Ecto.Enum, values: [:big, :small]

    timestamps()
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:color, :sides, :dimensions])
    |> validate_required([:color, :sides, :dimensions])
    |> validate_number(:sides, greater_than: 2, less_than: 10)
  end
end
