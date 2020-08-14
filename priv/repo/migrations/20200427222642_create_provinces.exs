defmodule Turnos.Repo.Migrations.CreateProvinces do
  use Ecto.Migration

  def change do
    create table(:provinces) do
      add :name, :string
      add :code, :string
      add :country_id, references :countries

      timestamps()
    end

  end
end
