defmodule TurnosWeb.Patient.AppointmentController do
  use TurnosWeb, :controller

  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  # Muestra los turnos proximos del paciente, con fecha mayor o igual
  # a la actual
  def index(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    if user.id == params["user_id"] do
      appointments = Appointments.get_appointments_by_users(user.id) |> Repo.all()

      conn
      |> put_view(TurnosWeb.AppointmentView)
      |> render("index.json", appointments: appointments)
    else
      index_by_professional(conn, params)
    end
  end

  # Muestra el listado de turnos disponibles de un profesional con fecha
  # mayor o igual a la actual
  defp index_by_professional(conn, params) do
    appointments =
      Appointments.get_available_appointments_by_professional(params["user_id"])
      |> Repo.all()

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("index.json", appointments: appointments)
  end

  # Muestra el detalle de un turno de un paciente
  def show(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    appointment =
      user.id
      |> Appointments.get_appointments_by_users()
      |> Repo.get!(params["id"])
      |> Repo.preload(appointments_professional: [:countries, :provinces])
      |> Repo.preload([:appointments_office, :appointments_office_per])

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("show.json", appointment: appointment)
  end

  # Para modificar la disponibilidad del turno.
  def update(conn, params) do
    if !params["availability"] do
      pick_patient_appointment(conn, params)
    else
      cancel_patient_appointment(conn, params)
    end
  end

  defp pick_patient_appointment(conn, params) do
    user = conn |> Guardian.Plug.current_resource()
    professional_id = params["user_id"]
    params = params |> Map.delete("user_id") |> Map.put("patient_id", user.id)

    appointment =
      professional_id
      |> Appointments.get_available_appointments_by_professional()
      |> Repo.get!(params["id"])
      |> Repo.preload(appointments_professional: [:countries, :provinces])
      |> Repo.preload([:appointments_office, :appointments_office_per])

    with {:ok, %Appointment{} = appointment} <-
           Appointments.update_patient_appointment(appointment, params) do
      conn
      |> put_view(TurnosWeb.AppointmentView)
      |> render("show.json", appointment: appointment)
    end
  end

  defp cancel_patient_appointment(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params = params |> Map.delete("user_id") |> Map.put("patient_id", nil)

    appointment =
      user.id
      |> Appointments.get_appointments_by_users()
      |> Repo.get!(params["id"])

    with {:ok, %Appointment{} = _appointment} <-
           Appointments.update_patient_appointment(appointment, params) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
