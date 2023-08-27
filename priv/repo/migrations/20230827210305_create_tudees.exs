defmodule TudeeFinder.Repo.Migrations.CreateTudees do
  use Ecto.Migration

  def change do
    create table(:tudees) do
      add :color, :string
      add :sides, :integer
      add :dimensions, :string

      timestamps()
    end
  end
end
