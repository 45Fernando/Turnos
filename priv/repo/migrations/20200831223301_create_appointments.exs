defmodule Turnos.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :professional_id, references(:users)
      add :patient_id, references(:users)
      add :appointment_date, :utc_datetime_usec
      add :start_time, :time_usec
      add :end_time, :time_usec
      add :availability, :boolean, default: true, null: false
      add :overturn, :boolean, default: false, null: false

      timestamps()
    end

  end
end
