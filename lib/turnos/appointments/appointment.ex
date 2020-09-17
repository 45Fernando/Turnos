defmodule Turnos.Appointments.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :appointment_date, :utc_datetime
    field :availability, :boolean, default: false
    field :end_time, :time
    field :start_time, :time
    field :overturn, :boolean, default: false

    belongs_to(:appointments_patient, Turnos.Users.User, foreign_key: :patient_id)
    belongs_to(:appointments_professional, Turnos.Users.User, foreign_key: :professional_id)

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
    |> cast(attrs, [:appointment_date, :start_time, :end_time, :availability, :profesional_id, :overturn])
    |> validate_required([:appointment_date, :start_time, :end_time, :availability, :profesional_id, :overturn])
    |> foreign_key_constraint(:professional_id)
  end
end
