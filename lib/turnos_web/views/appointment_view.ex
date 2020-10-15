defmodule TurnosWeb.AppointmentView do
  use TurnosWeb, :view
  alias TurnosWeb.AppointmentView

  def render("index.json", %{appointments: appointments}) do
    %{data: render_many(appointments, AppointmentView, "appointment.json")}
  end

  def render("show.json", %{appointment: appointment}) do
    %{data: render_one(appointment, AppointmentView, "appointment.json")}
  end

  def render("appointment.json", %{appointment: appointment}) do
    %{
      id: appointment.id,
      appointment_date: appointment.appointment_date,
      start_time: appointment.start_time,
      end_time: appointment.end_time,
      availability: appointment.availability,
      overturn: appointment.overturn,
      professional: professional?(appointment.appointments_professional)
    }
  end

  defp professional?(professional) do
    if Ecto.assoc_loaded?(professional) do
      render_one(professional, TurnosWeb.UserView, "professional.json", as: :professional)
    else
      []
    end
  end
end
