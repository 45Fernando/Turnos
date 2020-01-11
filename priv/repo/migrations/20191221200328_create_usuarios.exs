defmodule Turnos.Repo.Migrations.CreateUsuarios do
  use Ecto.Migration

  def change do
    create table(:usuarios) do
      add :nombre, :string
      add :apellido, :string
      add :dni, :string
      add :mail, :string
      add :direccion, :string
      add :direccionProfesional, :string
      add :contraseña, :string
      add :telefono, :string
      add :telefonoProfesional, :string
      add :celular, :string
      add :foto, :string
      add :estado, :boolean, default: false, null: false
      add :fechaNacimiento, :date
      add :cuil, :string
      add :matricula, :string

      timestamps()
    end

  end
end
