defmodule Turnos.Repo.Migrations.CreateOffices do
  use Ecto.Migration

  def change do
    create table(:offices) do
      add :name, :string
      add :address, :string
      add :status, :boolean, default: false, null: false

      timestamps()
    end

  end
end
