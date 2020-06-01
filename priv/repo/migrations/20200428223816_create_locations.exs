defmodule Turnos.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :code, :string
      add :latitude, :string
      add :longitude, :string
      add :province_id, references(:provinces)

      timestamps()
    end

  end
end
