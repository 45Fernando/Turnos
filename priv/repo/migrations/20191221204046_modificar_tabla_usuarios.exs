defmodule Turnos.Repo.Migrations.ModificarTablaUsuarios do
  use Ecto.Migration

  def change do
    alter table(:usuarios) do
      add :matriculaNacional, :string
      add :matriculaProvincial, :string
      remove :matricula
    end
  end
end
