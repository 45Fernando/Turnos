defmodule Turnos.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :professional_id, references(:users)
      add :patient_id, references(:users)
      add :appointment_date, :date
      add :time_start, :time
      add :time_end, :time
      add :availability, :boolean, default: false, null: false

      timestamps()
    end

  end
end
