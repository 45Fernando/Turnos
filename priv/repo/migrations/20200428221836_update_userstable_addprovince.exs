defmodule Turnos.Repo.Migrations.UpdateUserstableAddprovince do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:province_id, references(:provinces))
    end
  end
end
