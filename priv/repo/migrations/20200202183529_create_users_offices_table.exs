defmodule Turnos.Repo.Migrations.CreateUsersOfficesTable do
  use Ecto.Migration

  def change do
    create table(:users_offices, primary_key: false) do
      add(:office_id, references(:offices), primary_key: true)
      add(:user_id, references(:users), primary_key: true)
      add :timeFrom, :time
      add :timeTo, :time

      #timestamps()
    end

    create(index(:users_offices, [:office_id]))
    create(index(:users_offices, [:user_id]))

    create(
      unique_index(:users_offices, [:user_id, :office_id], name: :user_id_office_id_unique_index)
    )
  end
end
