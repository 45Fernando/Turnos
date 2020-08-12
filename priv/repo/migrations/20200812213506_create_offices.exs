defmodule Turnos.Repo.Migrations.CreateOffices do
  use Ecto.Migration

  def change do
    create table(:offices) do
      add :phone, :string
      add :name, :string
      add :address, :string
      add :status, :boolean, default: false, null: false
      add :lat, :string
      add :long, :string

      timestamps()
    end

  end
end
