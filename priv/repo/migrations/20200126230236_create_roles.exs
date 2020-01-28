defmodule Turnos.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :roleName, :string

      timestamps()
    end

  end
end
