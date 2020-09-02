defmodule Turnos.Appointments.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :appointment_date, :date
    field :availability, :boolean, default: false
    field :time_end, :time
    field :time_start, :time

    belongs_to(:appointments_patient, Turnos.Users.User, foreign_key: :patient_id)
    belongs_to(:appointments_professional, Turnos.Users.User, foreign_key: :profesional_id)

    timestamps()
  end

  @doc false
  def changeset_patient(appointment, attrs) do
    appointment
    |> cast(attrs, [:availability, :patient_id])
    |> validate_required([:availability, :patient_id])
    |> foreign_key_constraint(:patient_id)
  end

  #TODO revisar si falta cambiar algo
  def changeset_professional(appointment, attrs) do
    appointment
    |> cast(attrs, [:appointment_date, :time_start, :time_end, :availability, :profesional_id])
    |> validate_required([:appointment_date, :time_start, :time_end, :availability, :profesional_id])
    |> foreign_key_constraint(:professional_id)
  end
end
