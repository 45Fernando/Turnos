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
      professional: professional?(appointment.appointments_professional),
      patient: patient?(appointment.appointments_patient),
      office: office?(appointment.appointments_office),
      office_per: office_per?(appointment.appointments_office_per)
    }
  end

  defp professional?(professional) do
    if Ecto.assoc_loaded?(professional) do
      render_one(professional, TurnosWeb.UserView, "professional.json", as: :professional)
    else
      []
    end
  end

  defp patient?(patient) do
    if Ecto.assoc_loaded?(patient) do
      render_one(patient, TurnosWeb.UserView, "patient.json", as: :patient)
    else
      []
    end
  end

  defp office?(office) do
    if Ecto.assoc_loaded?(office) do
      render_one(office, TurnosWeb.OfficeView, "office.json", as: :office)
    else
      []
    end
  end

  defp office_per?(office_per) do
    if Ecto.assoc_loaded?(office_per) do
      render_one(office_per, TurnosWeb.OfficePerView, "office_per.json", as: :office_per)
    else
      []
    end
  end
end
