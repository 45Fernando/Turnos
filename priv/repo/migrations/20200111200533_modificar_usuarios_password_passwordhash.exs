defmodule Turnos.Repo.Migrations.ModificarUsuariosPasswordPasswordhash do
  use Ecto.Migration

  def change do
    alter table(:usuarios) do
      add :password_hash, :string
      remove :contraseña
    end
  end
end
