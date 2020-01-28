defmodule Turnos.Repo.Migrations.CreateUsersRolesTable do
  use Ecto.Migration

  def change do

    create table(:users_roles, primary_key: false) do
      add(:role_id, references(:roles, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)

      timestamps()
    end

    create(index(:users_roles, [:role_id]))
    create(index(:users_roles, [:user_id]))

    create(
      unique_index(:users_roles, [:user_id, :role_id], name: :user_id_role_id_unique_index)
    )
  end
end
