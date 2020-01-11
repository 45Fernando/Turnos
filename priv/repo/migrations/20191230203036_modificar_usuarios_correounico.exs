defmodule Turnos.Repo.Migrations.ModificarUsuariosCorreounico do
  use Ecto.Migration

  def change do
    create unique_index(:usuarios, [:mail])
  end
end
