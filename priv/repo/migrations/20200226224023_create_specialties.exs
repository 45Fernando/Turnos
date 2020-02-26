defmodule Turnos.Repo.Migrations.CreateSpecialties do
  use Ecto.Migration

  def change do
    create table(:specialties) do
      add :name, :string

      timestamps()
    end

  end
end
