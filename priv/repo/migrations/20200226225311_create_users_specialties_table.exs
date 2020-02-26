defmodule Turnos.Repo.Migrations.CreateUsersSpecialtiesTable do
  use Ecto.Migration

  def change do
    create table(:users_specialties, primary_key: false) do
      add(:specialty_id, references(:specialties), primary_key: true)
      add(:user_id, references(:users), primary_key: true)
    end

    create(index(:users_specialties, [:specialty_id]))
    create(index(:users_specialties, [:user_id]))

    create(
      unique_index(:users_specialties, [:user_id, :specialty_id], name: :user_id_specialty_id_unique_index)
    )
  end
end
