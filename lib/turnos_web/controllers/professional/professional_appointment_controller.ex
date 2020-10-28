defmodule TurnosWeb.Professional.AppointmentController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.Repo
  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment
  alias Turnos.ConfigHeaders.ConfigHeader

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Professional_Appointment:
        swagger_schema do
          title("Professional Appointments")
          description("Professional Appointments")

          properties do
            id(:integer, "The ID of the appointment")
            availability(:boolean, "If the appointment is available or not", required: true)
            start_time(:time_usec, "When the appointmend end", required: true)
            end_time(:time_usec, "When the appointmend end", required: true)
            overturn(:boolean, "If the appointment is a overturn appointment", required: true)
            patient_id(:integer, "Patient's ID", required: true)
            professional_id(:integer, "Professional's ID", required: true)
            office_id(:integer, "Office's ID", required: true)
            office_per_id(:integer, "Office_per's ID", required: true)
            inserted_at(:string, "When was the country initially inserted", format: "ISO-8601")
            updated_at(:string, "When was the country last updated", format: "ISO-8601")
          end

          example(%{
            appointment_date: "2020-10-28T21:52:13.549656Z",
            availability: false,
            end_time: "12:30:00.000000",
            id: 79,
            overturn: false,
            professional_id: 1,
            office_id: 1,
            office_per_id: "",
            start_time: "12:00:00.000000"
          })
        end,
      Professional_Appointments:
        swagger_schema do
          title("Professional's Appointments")
          description("All appointments of the Professional")
          type(:array)
          items(Schema.ref(:Professional_Appointment))
        end,
      Error:
        swagger_schema do
          title("Errors")
          description("Error responses from the API")

          properties do
            error(:string, "The message of the error raised", required: true)
          end
        end
    }
  end

  swagger_path :index_by_professional do
    get("/api/professional/{user_id}/appointments")
    summary("List all the next appointments of the professional")
    description("List all the next appointments of the professional")
    produces("application/json")

    parameters do
      user_id(:path, :integer, "The id of the professional", required: true)
    end

    response(200, "Ok", Schema.ref(:Professional_Appointments))
    response(400, "Client Error")
  end

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

  swagger_path :generate_appointments do
    get("/api/professional/{user_id}/appointments/generate")
    summary("Generate the appointments base on the user's configuration")
    description("Generate the appointments base on the professional's configuration")
    produces("application/json")

    parameters do
      user_id(:path, :integer, "The id of the professional", required: true)
      time_zone(:body, :string, "The time zone of the client", required: true)
    end

    response(200, "Ok", Schema.ref(:Professional_Appointments))
    response(400, "Client Error")
  end

  def generate_appointments(conn, params) do
    user = conn |> Guardian.Plug.current_resource()
    time_zone = params["time_zone"]

    config_header = user.id |> Turnos.ConfigHeaders.get_config_by_user()
    config_details = user.id |> Turnos.ConfigDetails.get_config_details_by_user() |> Repo.all()
    last_appointment = user.id |> Turnos.Appointments.get_last_appointment()

    last_appointment_not_available =
      user.id |> Turnos.Appointments.get_last_not_avalaible_appointment()

    {date, acc} =
      get_date(
        last_appointment_not_available,
        last_appointment,
        config_header,
        time_zone
      )

    {_quantity_rows, _} = user.id |> Turnos.Appointments.delete_appointment_by_date(date)

    {:ok, lastdate} =
      if !config_header.generate_up_to do
        generate_by_days(config_details, date, acc, user.id, time_zone)
      else
        generate_till_date(config_header.generate_up_to, config_details, date, user.id, time_zone)
      end

    with {:ok, %ConfigHeader{} = _config_header} <-
           Turnos.ConfigHeaders.update_config(config_header, %{"lastdate" => lastdate}) do
      conn
      |> index_by_professional(user)
    end
  end

  # Para generar los turnos cada ciertos dias
  defp generate_by_days(config_details, date, acc, user_id, time_zone)
       when acc > 0 do
    day_of_week = Date.day_of_week(date)

    if day_of_week != 6 or day_of_week != 7 do
      list_of_details = search_days_in_details(day_of_week, config_details)

      list_of_details
      |> Enum.each(fn detail -> generate_by_detail(detail, date, user_id, time_zone) end)
    end

    date = DateTime.add(date, 86400)
    generate_by_days(config_details, date, acc - 1, user_id, time_zone)
  end

  defp generate_by_days(_config_details, date, acc, _user_id, _time_zone)
       when acc == 0 do
    {:ok, date}
  end

  # Para generar los turnos hasta cierta fecha
  defp generate_till_date(generate_up_to, config_details, date, user_id, time_zone) do
    if DateTime.compare(generate_up_to, date) == :gt do
      day_of_week = Date.day_of_week(date)

      if day_of_week != 6 or day_of_week != 7 do
        list_of_details = search_days_in_details(day_of_week, config_details)

        list_of_details
        |> Enum.each(fn detail -> generate_by_detail(detail, date, user_id, time_zone) end)
      end

      date = DateTime.add(date, 86400)
      generate_till_date(generate_up_to, config_details, date, user_id, time_zone)
    else
      {:ok, date}
    end
  end

  # ------------------------------------------

  defp generate_by_detail(detail, date, user_id, time_zone) do
    generate_by_detail(
      detail.start_time,
      detail.end_time,
      detail.minutes_interval,
      date,
      detail.office_id,
      detail.office_per_id,
      user_id,
      time_zone
    )
  end

  defp generate_by_detail(
         start_time,
         end_time,
         minutes_interval,
         date,
         office_id,
         office_per_id,
         user_id,
         time_zone
       ) do
    if Time.compare(start_time, end_time) == :lt do
      end_appointment =
        start_time
        |> Time.add(minutes_interval * 60, :second)

      date = TurnosWeb.HelpersDateTime.get_utc_with_start_time(date, start_time, time_zone)

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
        user_id,
        time_zone
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

  # Para conseguir desde que fecha borrar los turnos y generar los nuevos turnos
  # Y para conseguir la diferencia de dias a generar y no pasar lo puesto en la
  # configuracion
  defp get_date(
         last_appointment_not_available,
         last_appointment,
         config_header,
         time_zone
       ) do
    if last_appointment_not_available == nil do
      today = DateTime.now!(time_zone) |> DateTime.shift_zone!("Etc/UTC")

      {today, config_header.generate_every_days}
    else
      date = DateTime.add(last_appointment_not_available.appointment_date, 86400)

      acc =
        last_appointment.appointment_date
        |> DateTime.diff(date)
        |> div(86400)
        |> abs()

      {date, acc + 1}
    end
  end

  swagger_path :show do
    get("/api/professional/{user_id}/appointments/{id} ")
    summary("Retrieve a appointment of a professional")
    description("Retrieve a appointment of a professional")

    parameters do
      id(:path, :integer, "The id of the appointment", required: true)
      user_id(:path, :integer, "The id of the professional", required: true)
    end

    response(200, "Ok", Schema.ref(:Professional_Appointment))
    response(404, "Not found", Schema.ref(:Error))
  end

  # Muestra el detalle de un turno de un paciente
  def show(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    appointment =
      user.id
      |> Appointments.get_appointments_by_professional()
      |> Repo.get!(params["id"])
      |> Repo.preload(appointments_patient: [:countries, :provinces])
      |> Repo.preload([:appointments_office, :appointments_office_per])

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("show.json", appointment: appointment)
  end

  swagger_path :update do
    patch("/api/professionals/{user_id}/appointments/{id}")
    summary("Change the availabilty of an appointment by a professional")
    description("Change the availabilty of an appointment by a professional")

    parameters do
      id(:path, :integer, "The id of the appointment", required: true)
      user_id(:path, :integer, "The id of the professional", required: true)

      availability(:body, :boolean, "True or False of the availability of the appointment",
        required: true
      )
    end

    response(201, "Ok", Schema.ref(:Patient_Appointment))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  # Para modificar la disponibilidad del turno.
  def update(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    appointment =
      user.id
      |> Appointments.get_appointments_by_professional()
      |> Repo.get!(params["id"])

    params = params |> Map.delete("user_id") |> Map.put("patient_id", nil)

    with {:ok, %Appointment{} = appointment} <-
           Appointments.update_patient_appointment(appointment, params) do
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
