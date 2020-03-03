defmodule Turnos.Repo.Migrations.CreateOfficesDaysTable do
  use Ecto.Migration

  def change do
    create table(:offices_days) do
      add :office_id, references(:offices)
      add :day_id, references(:days)
      add :timeFrom, :time
      add :timeTo, :time
      add :open, :boolean, default: false

      timestamps()
    end

    create(index(:offices_days, [:office_id]))
    create(index(:offices_days, [:day_id]))

  end
end
