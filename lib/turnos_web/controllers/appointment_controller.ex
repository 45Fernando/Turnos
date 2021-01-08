defmodule TurnosWeb.AppointmentController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Appointment:
        swagger_schema do
          title("Appointments")
          description("Appointments")

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
      Appointments:
        swagger_schema do
          title("Appointments")
          description("All appointments of the user")
          type(:array)
          items(Schema.ref(:Appointment))
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

  def action(conn, _) do
    current_user_roles =
      conn |> Guardian.Plug.current_resource() |> TurnosWeb.ExtractRoles.extract_roles()

    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user_roles])
  end

  swagger_path :index do
    get("/api/users/{user_id}/appointments")
    summary("List all the next appointments of the user")
    description("List all the next appointments of the user")
    produces("application/json")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(200, "Ok", Schema.ref(:Appointments))
    response(400, "Client Error")
  end

  def index(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.AppointmentController.index(conn, [])

      "patient" in current_user_roles ->
        TurnosWeb.Patient.AppointmentController.index(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show do
    get("/api/users/{user_id}/appointments/{id} ")
    summary("Retrieve a appointment of a user")
    description("Retrieve a appointment of a user")

    parameters do
      id(:path, :integer, "The id of the appointment", required: true)
      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(200, "Ok", Schema.ref(:Appointment))
    response(404, "Not found", Schema.ref(:Error))
  end

  # Muestra el detalle de un turno de un paciente
  def show(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.AppointmentController.show(conn, params)

      "patient" in current_user_roles ->
        TurnosWeb.Patient.AppointmentController.show(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update do
    patch("/api/users/{user_id}/appointments/{id}")
    summary("Pick an appointment by a user")
    description("Pick an appointment by a user")

    parameters do
      id(:path, :integer, "The id of the appointment", required: true)
      user_id(:path, :integer, "The id of the user", required: true)

      availability(:body, :boolean, "True or False of the availability of the appointment",
        required: true
      )
    end

    response(201, "Ok", Schema.ref(:Appointment))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  # Para modificar la disponibilidad del turno.
  def update(conn, params, current_user_roles) do
    user = conn |> Guardian.Plug.current_resource()

    # TODO revisar estas condiciones para ver si se pueden mejorar y si hay algun error en la logica
    cond do
      "patient" in current_user_roles and user.id != params["user_id"] ->
        TurnosWeb.Patient.AppointmentController.update(conn, params)

      "patient" in current_user_roles and user.id == params["user_id"] ->
        TurnosWeb.Patient.AppointmentController.update(conn, params)

      "professional" in current_user_roles and user.id == params["user_id"] ->
        TurnosWeb.Professional.AppointmentController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :generate_appointments do
    get("/api/users/{user_id}/appointments/generate")
    summary("Generate the appointments base on the user's configuration")
    description("Generate the appointments base on the users's configuration")
    produces("application/json")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
      time_zone(:body, :string, "The time zone of the client", required: true)
    end

    response(200, "Ok", Schema.ref(:Appointments))
    response(400, "Client Error")
  end

  def generate_appointments(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.AppointmentController.generate_appointments(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end
end
