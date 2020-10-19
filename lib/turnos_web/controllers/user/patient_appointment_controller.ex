defmodule TurnosWeb.Patient.AppointmentController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Patient_Appointment:
        swagger_schema do
          title("Patient Appointments")
          description("Patient Appointments")

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
      Patient_Appointments:
        swagger_schema do
          title("Patient's Appointments")
          description("All appointments of the patient")
          type(:array)
          items(Schema.ref(:Patient_Appointment))
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

  swagger_path :index do
    get("/api/patient/{user_id}/appointments")
    summary("List all the next appointments of the patient")
    description("List all the next appointments of the patient")
    produces("application/json")

    parameters do
      user_id(:path, :integer, "The id of the patient", required: true)
    end

    response(200, "Ok", Schema.ref(:Patient_Appointment))
    response(400, "Client Error")
  end

  # Muestra los turnos proximos del paciente, con fecha mayor o igual
  # a la actual
  def index(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    appointments = Appointments.get_appointments_by_users(user.id) |> Repo.all()

    conn
    |> put_view(TurnosWeb.AppointmentView)
    |> render("index.json", appointments: appointments)
  end

  swagger_path :index_by_professional do
    get("/api/patient/professionals/{professional_id}/appointments ")
    summary("List all the next available appointments of a professional")
    description("List all the next available appointments of a professional")
    produces("application/json")

    parameters do
      professional_id(:path, :integer, "The id of the professional", required: true)
    end

    response(200, "Ok", Schema.ref(:Patient_Appointment))
    response(400, "Client Error")
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

  swagger_path :show do
    get("/api/patient/{user_id}/appointments/{id} ")
    summary("Retrieve a appointment of a patient")
    description("Retrieve a appointment of a patient")

    parameters do
      id(:path, :integer, "The id of the appointment", required: true)
      user_id(:path, :integer, "The id of the patient", required: true)
    end

    response(200, "Ok", Schema.ref(:Patient_Appointment))
    response(404, "Not found", Schema.ref(:Error))
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

  swagger_path :update_patient_appointment do
    patch("/api/patient/{user_id}/professionals/{professional_id}/appointments/{id}")
    summary("Pick an appointment by a patient")
    description("Pick an appointment by a patient")

    parameters do
      id(:path, :integer, "The id of the appointment", required: true)
      user_id(:path, :integer, "The id of the patient", required: true)

      availability(:body, :boolean, "True or False of the availability of the appointment",
        required: true
      )
    end

    response(201, "Ok", Schema.ref(:Patient_Appointment))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  # Para modificar la disponibilidad del turno.
  def update_patient_appointment(conn, params) do
    if !params["availability"] do
      pick_patient_appointment(conn, params)
    else
      cancel_patient_appointment(conn, params)
    end
  end

  defp pick_patient_appointment(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params = params |> Map.delete("user_id") |> Map.put("patient_id", user.id)

    appointment =
      params["professional_id"]
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
