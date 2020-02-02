defmodule Turnos.Repo.Migrations.CreateMedicalsinsurances do
  use Ecto.Migration

  def change do
    create table(:medicalsinsurances) do
      add :cuit, :string
      add :name, :string
      add :businessName, :string
      add :status, :boolean, default: true

      timestamps()
    end

  end
end
