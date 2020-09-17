defmodule Turnos.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :professional_id, references(:users)
      add :patient_id, references(:users)
      add :appointment_date, :utc_datetime
      add :start_time, :time
      add :end_time, :time
      add :availability, :boolean, default: false, null: false
      add :overturn, :boolean, default: false, null: false

      timestamps()
    end

  end
end
