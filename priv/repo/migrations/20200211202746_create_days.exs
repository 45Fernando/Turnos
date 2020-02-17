defmodule Turnos.Repo.Migrations.CreateDays do
  use Ecto.Migration

  def change do
    create table(:days) do
      add :name, :string

      timestamps()
    end

  end
end
