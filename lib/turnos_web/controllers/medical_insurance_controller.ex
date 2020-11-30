defmodule TurnosWeb.MedicalInsuranceController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.MedicalsInsurances
  alias Turnos.MedicalsInsurances.MedicalInsurance

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      MedicalInsurance:
        swagger_schema do
          title("Medical insurance")
          description("A medical insurance")

          properties do
            id(:integer, "The ID of the medical insurance")
            businessName(:string, "The business Name of the medical insurance", required: true)
            cuit(:string, "The CUIT of the medical insurance", required: true)
            name(:string, "The name of the medical insurance", required: true)
            status(:boolean, "The status of the medical insurance")
            users(:array, "Has many professionals")

            inserted_at(:string, "When was the medical insurance initially inserted",
              format: "ISO-8601"
            )

            updated_at(:string, "When was the medical insurance last updated", format: "ISO-8601")
          end

          example(%{
            id: 1,
            businessName: "OSPE",
            cuit: "20741258391",
            name: "Obra Social de Petroleros",
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      MedicalsInsurances:
        swagger_schema do
          title("Medicals insurances")
          description("All medicals insurances")
          type(:array)
          items(Schema.ref(:MedicalInsurance))
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
    get("/api/medicalsinsurances")
    summary("List all medicals insurances")
    description("List all medicals insurances")
    produces("application/json")
    response(200, "Ok", Schema.ref(:MedicalsInsurances))
    response(400, "Client Error")
  end

  def index(conn, _params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.MedicalInsuranceController.index(conn, [])

      "profesional" in current_user_roles ->
        TurnosWeb.Admin.MedicalInsuranceController.index(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :create do
    post("/api/medicalsinsurances/")
    summary("Add a new medical insurance")
    description("Record a new medical insurance")

    parameters do
      country(:body, Schema.ref(:MedicalInsurance), "Medical insurance to record", required: true)
    end

    response(201, "Ok", Schema.ref(:MedicalInsurance))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, medical_insurance_params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.MedicalInsuranceController.create(conn, medical_insurance_params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show do
    get("/api/medicalsinsurances/{id}")
    summary("Retrieve a medical insurance")
    description("Retrieve a medical insurance")

    parameters do
      id(:path, :integer, "The id of the medical insurance", required: true)
    end

    response(200, "Ok", Schema.ref(:MedicalInsurance))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.MedicalInsuranceController.show(conn, %{"id" => id})

      "profesional" in current_user_roles ->
        TurnosWeb.Admin.MedicalInsuranceController.show(conn, %{"id" => id})

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update do
    patch("/api/medicalsinsurances/{id}")
    summary("Update the medical insurance ")
    description("Update the medical insurance")

    parameters do
      medicalinsurance(:body, Schema.ref(:MedicalInsurance), "Specialty to record", required: true)

      id(:path, :integer, "The id of the specialty", required: true)
    end

    response(201, "Ok", Schema.ref(:MedicalInsurance))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, medical_insurance_params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.MedicalInsuranceController.update(conn, medical_insurance_params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # Deshabilitado
  def delete(conn, %{"id" => id}) do
    medical_insurance = MedicalsInsurances.get_medical_insurance!(id)

    with {:ok, %MedicalInsurance{}} <-
           MedicalsInsurances.delete_medical_insurance(medical_insurance) do
      send_resp(conn, :no_content, "")
    end
  end
end
