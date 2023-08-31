defmodule TudeeFinder.Tudees.Tudee do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          color: color(),
          sides: non_neg_integer(),
          dimensions: dimensions()
        }
  @type color :: :blue | :red | :green | :yellow | :violet | :pink | :orange
  @type dimensions :: :big | :small

  schema "tudees" do
    field :color, Ecto.Enum, values: [:blue, :red, :green, :yellow, :violet, :pink, :orange]
    field :sides, :integer
    field :dimensions, Ecto.Enum, values: [:big, :small]

    timestamps()
  end

  @doc false
  def changeset(tudee, attrs) do
    tudee
    |> cast(attrs, [:color, :sides, :dimensions])
    |> validate_required([:color, :sides, :dimensions])
    |> validate_number(:sides, greater_than: 2, less_than: 10)
  end
end
