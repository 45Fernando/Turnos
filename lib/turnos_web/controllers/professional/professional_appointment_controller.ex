defmodule TurnosWeb.Professional.AppointmentController do
  use TurnosWeb, :controller

  alias Turnos.Repo
  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment
  alias Turnos.ConfigHeaders.ConfigHeader

  action_fallback TurnosWeb.FallbackController

  # Muestra todos los turnos relacionados a un profesional.
  # Mayor o igual a la fecha actual
  # A definir que turnos vamos a mostrar
  def index_by_professional(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    appointments = Appointments.get_appointments_by_professional(user.id) |> Repo.all()

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("index.json", appointments: appointments)
  end

  # Preguntar si el profesional va a poder crea manualmente un turno
  # def create(conn, %{"appointment" => appointment_params}) do
  # with {:ok, %Appointment{} = appointment} <- Appointments.create_professional_appointment(appointment_params) do
  # conn
  # |> put_status(:created)
  # |> put_resp_header("location", Routes.appointment_path(conn, :show, appointment))
  # |> render("show.json", appointment: appointment)
  # end
  # end

  def generate_appointments(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    config_header = user.id |> Turnos.ConfigHeaders.get_config_by_user()
    config_details = user.id |> Turnos.ConfigDetails.get_config_details_by_user() |> Repo.all()

    today = DateTime.now!("America/Buenos_Aires")

    if !config_header.generate_up_to do
      case generate(config_header.generate_every_days, config_details, today, 1, user.id) do
        {:ok, lastdate} ->
          lastdate = lastdate |> DateTime.shift_zone!("Etc/UTC")

          with {:ok, %ConfigHeader{} = _config_header} <-
                 Turnos.ConfigHeaders.update_config(config_header, %{"lastdate" => lastdate}) do
            conn
            |> index_by_professional(user)
          end
      end
    else
      case generate_till_date(config_header.generate_up_to, config_details, today, user.id) do
        {:ok, lastdate} ->
          lastdate = lastdate |> DateTime.shift_zone!("Etc/UTC")

          with {:ok, %ConfigHeader{} = _config_header} <-
                 Turnos.ConfigHeaders.update_config(config_header, %{"lastdate" => lastdate}) do
            conn
            |> index_by_professional(user)
          end
      end
    end
  end

  # Para generar los turnos cada ciertos dias
  defp generate(generate_every_days, config_details, date, acc, user_id)
       when acc < generate_every_days do
    day_of_week = Date.day_of_week(date)

    if day_of_week != 6 or day_of_week != 7 do
      list_of_details = search_days_in_details(day_of_week, config_details)

      list_of_details
      |> Enum.each(fn detail -> generate_by_detail(detail, date, user_id) end)
    end

    date = DateTime.add(date, 86400)
    generate(generate_every_days, config_details, date, acc + 1, user_id)
  end

  defp generate(generate_every_days, _config_details, date, acc, _user_id)
       when acc >= generate_every_days do
    {:ok, date}
  end

  # Para generar los turnos hasta cierta fecha
  defp generate_till_date(generate_up_to, config_details, date, user_id) do
    if DateTime.compare(generate_up_to, date) == :gt do
      day_of_week = Date.day_of_week(date)

      if day_of_week != 6 or day_of_week != 7 do
        list_of_details = search_days_in_details(day_of_week, config_details)

        list_of_details
        |> Enum.each(fn detail -> generate_by_detail(detail, date, user_id) end)
      end

      date = DateTime.add(date, 86400)
      generate_till_date(generate_up_to, config_details, date, user_id)
    else
      {:ok, date}
    end
  end

  # ------------------------------------------

  defp generate_by_detail(detail, date, user_id) do
    generate_by_detail(
      detail.start_time,
      detail.end_time,
      detail.minutes_interval,
      date,
      detail.office_id,
      detail.office_per_id,
      user_id
    )
  end

  defp generate_by_detail(
         start_time,
         end_time,
         minutes_interval,
         date,
         office_id,
         office_per_id,
         user_id
       ) do
    if Time.compare(start_time, end_time) == :lt do
      end_appointment =
        start_time
        |> Time.add(minutes_interval * 60, :second)

      insert_appointment(start_time, end_appointment, date, office_id, office_per_id, user_id)

      start_time =
        start_time
        |> Time.add(minutes_interval * 60, :second)

      generate_by_detail(
        start_time,
        end_time,
        minutes_interval,
        date,
        office_id,
        office_per_id,
        user_id
      )
    else
      nil
    end
  end

  defp search_days_in_details(day_of_week, config_details) do
    config_details
    |> Enum.filter(fn detail -> day_of_week == detail.day_id end)
  end

  defp insert_appointment(
         start_time,
         end_time,
         appointment_date,
         office_id,
         office_per_id,
         professional_id
       ) do
    IO.inspect(appointment_date, label: "FECHA")

    appointment_date =
      appointment_date
      |> DateTime.shift_zone!("Etc/UTC")

    appointment = %Appointment{
      appointment_date: appointment_date,
      start_time: start_time,
      end_time: end_time,
      professional_id: professional_id,
      office_id: office_id,
      office_per_id: office_per_id
    }

    Repo.insert!(appointment)
  end

  # Muestra el detalle de un turno de un paciente
  def show(conn, %{"id" => id}) do
    appointment = Appointments.get_appointment!(id)
    render(conn, "show.json", appointment: appointment)
  end

  # Para modificar la disponibilidad del turno.
  def update(conn, %{"id" => id, "appointment" => appointment_params}) do
    appointment = Appointments.get_appointment!(id)

    with {:ok, %Appointment{} = appointment} <-
           Appointments.update_patient_appointment(appointment, appointment_params) do
      render(conn, "show.json", appointment: appointment)
    end
  end

  # Este tambien ira al controlador del profesional.
  # revisar como se hara esto de borrar un turno
  def delete(conn, %{"id" => id}) do
    appointment = Appointments.get_appointment!(id)

    with {:ok, %Appointment{}} <- Appointments.delete_appointment(appointment) do
      send_resp(conn, :no_content, "")
    end
  end
end
