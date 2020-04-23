defmodule Turnos.Repo.Migrations.UpdateUsersTableAddcountries do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:countries_id, references(:countries))
    end
  end
end
