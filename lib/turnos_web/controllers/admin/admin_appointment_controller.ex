defmodule TurnosWeb.Admin.AppointmentController do
  use TurnosWeb, :controller

  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    appointments = Appointments.list_appointments()
    render(conn, "index.json", appointments: appointments)
  end

  # def create(conn, %{"appointment" => appointment_params}) do
  # with {:ok, %Appointment{} = appointment} <- Appointments.create_professional_appointment(appointment_params) do
  # conn
  # |> put_status(:created)
  # |> put_resp_header("location", Routes.appointment_path(conn, :show, appointment))
  # |> render("show.json", appointment: appointment)
  # end
  # end

  def show(conn, %{"id" => id}) do
    appointment = Appointments.get_appointment!(id)
    render(conn, "show.json", appointment: appointment)
  end

  def update(conn, %{"id" => id, "appointment" => appointment_params}) do
    appointment = Appointments.get_appointment!(id)

    with {:ok, %Appointment{} = appointment} <-
           Appointments.update_patient_appointment(appointment, appointment_params) do
      render(conn, "show.json", appointment: appointment)
    end
  end

  def delete(conn, %{"id" => id}) do
    appointment = Appointments.get_appointment!(id)

    with {:ok, %Appointment{}} <- Appointments.delete_appointment(appointment) do
      send_resp(conn, :no_content, "")
    end
  end
end
