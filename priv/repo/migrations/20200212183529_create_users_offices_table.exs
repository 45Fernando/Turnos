defmodule Turnos.Repo.Migrations.CreateUsersOfficesTable do
  use Ecto.Migration

  def change do
    create table(:users_offices) do
      add(:office_id, references(:offices))
      add(:user_id, references(:users))
      add(:day_id, references(:days))
      add :timeFrom, :time
      add :timeTo, :time

      timestamps()
    end

    create(index(:users_offices, [:office_id]))
    create(index(:users_offices, [:user_id]))
    create(index(:users_offices, [:day_id]))
  end
end
