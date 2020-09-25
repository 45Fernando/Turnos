defmodule TurnosWeb.Patient.AppointmentController do
  use TurnosWeb, :controller

  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  # Muestra los turnos proximos del paciente, con fecha mayor o igual
  # a la actual
  def index(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    appointments = Appointments.get_appointment_by_users(user.id) |> Repo.all()

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("index.json", appointments: appointments)
  end

  # Muestra el listado de turnos disponibles de un profesional con fecha
  # mayor o igual a la actual
  def index_by_professional(conn, params) do
    appointments =
      Appointments.get_available_appointments_by_professional(params["professional_id"])
      |> Repo.all()

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("index.json", appointments: appointments)
  end

  # Muestra el detalle de un turno de un paciente
  def show(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    appointment = user.id |> Appointments.get_appointment_by_users() |> Repo.get!(params["id"])

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("show.json", appointment: appointment)
  end

  # Para modificar la disponibilidad del turno.
  def update_patient_appointment(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params = params |> Map.delete("user_id") |> Map.put("patient_id", user.id)

    appointment = user.id |> Appointments.get_appointment_by_users() |> Repo.get!(params["id"])

    with {:ok, %Appointment{} = appointment} <-
           Appointments.update_patient_appointment(appointment, params) do
      conn
      |> put_view(TurnosWeb.AppointmentView)
      |> render("show.json", appointment: appointment)
    end
  end
end
