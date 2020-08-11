defmodule Turnos.Repo.Migrations.CreateOfficesPer do
  use Ecto.Migration

  def change do
    create table(:offices_per) do
      add :name, :string
      add :address, :string
      add :status, :boolean, default: false, null: false
      add :phone, :string
      add :lat, :string
      add :long, :string
      add :user_id, references(:users)

      timestamps()
    end

  end
end
