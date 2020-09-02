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
    %{id: appointment.id,
      appointment_date: appointment.appointment_date,
      time_start: appointment.time_start,
      time_end: appointment.time_end,
      availability: appointment.availability}
  end
end
