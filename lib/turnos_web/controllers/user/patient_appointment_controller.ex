defmodule TurnosWeb.Patient.AppointmentController do
  use TurnosWeb, :controller

  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment

  action_fallback TurnosWeb.FallbackController

  #Muestra los turnos proximos del paciente, con fecha mayor o igual
  #a la actual
  def index(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    appointments = Appointments.get_appointment_by_users(user.id)

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("index.json", appointments: appointments)
  end

  #Muestra el detalle de un turno de un paciente
  def show(conn, %{"id" => id}) do
    appointment = Appointments.get_appointment!(id)
    render(conn, "show.json", appointment: appointment)
  end

  #Para modificar la disponibilidad del turno.
  def update(conn, %{"id" => id, "appointment" => appointment_params}) do
    appointment = Appointments.get_appointment!(id)

    with {:ok, %Appointment{} = appointment} <- Appointments.update_patient_appointment(appointment, appointment_params) do
      render(conn, "show.json", appointment: appointment)
    end
  end
end
