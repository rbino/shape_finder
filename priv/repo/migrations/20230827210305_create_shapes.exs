defmodule ShapeFinder.Repo.Migrations.CreateShapes do
  use Ecto.Migration

  def change do
    create table(:shapes) do
      add :color, :string
      add :sides, :integer
      add :dimensions, :string

      timestamps()
    end
  end
end
