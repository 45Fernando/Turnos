defmodule Turnos.Repo.Migrations.CreateUsersMedicalsinsurancesTable do
  use Ecto.Migration

  def change do
    create table(:users_medicalsinsurances, primary_key: false) do
      add(:medical_insurance_id, references(:medicalsinsurances), primary_key: true)
      add(:user_id, references(:users), primary_key: true)
    end

    create(index(:users_medicalsinsurances, [:medical_insurance_id]))
    create(index(:users_medicalsinsurances, [:user_id]))

    create(
      unique_index(:users_medicalsinsurances, [:user_id, :medical_insurance_id], name: :user_id_medical_insurance_id_unique_index)
    )
  end
end
