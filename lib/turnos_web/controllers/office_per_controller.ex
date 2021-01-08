defmodule TurnosWeb.OfficePerController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      PersonalizedOffice:
        swagger_schema do
          title("Personalized office")
          description("A personalized office")

          properties do
            id(:integer, "The ID of the personalized office")
            address(:string, "The address of the personalized office", required: true)
            name(:string, "The name of the personalized office", required: true)
            phone(:string, "The phone of the personalized office", required: true)
            lat(:string, "The latituded of the personalized office", required: true)
            long(:string, "The longituted of the personalized office", required: true)
            status(:boolean, "The status of the personalized office")
            user_id(:integer, "The id (FK) of the user who belongs the office")
            configdetails(:array, "Has many config details")
            appointments(:array, "Has many appointments")

            inserted_at(:string, "When was the personalized office initially inserted",
              format: "ISO-8601"
            )

            updated_at(:string, "When was the personalized office last updated",
              format: "ISO-8601"
            )
          end

          example(%{
            id: 1,
            name: "Casa",
            address: "La Rioja 97",
            status: true,
            user_id: 1,
            lat: "",
            long: "",
            phone: "1111",
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      PersonalizedOffices:
        swagger_schema do
          title("Personalized offices")
          description("All personalized offices")
          type(:array)
          items(Schema.ref(:PersonalizedOffice))
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
    get("/api/users/{user_id}/offices_per ")
    summary("List all personalized offices")
    description("List all personalized offices, will show acording to permisions")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
    end

    produces("application/json")
    response(200, "Ok", Schema.ref(:PersonalizedOffices))
    response(400, "Client Error")
  end

  def index(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficePerController.index(conn, params)

      "profesional" in current_user_roles ->
        TurnosWeb.Professional.OfficePerController.index(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :create do
    post("/api/users/{user_id}/offices_per/")
    summary("Add a new personalized office")
    description("Record a new personalized office")

    parameters do
      personalizedOffice(:body, Schema.ref(:PersonalizedOffice), "Personalized office to record",
        required: true
      )

      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(201, "Ok", Schema.ref(:PersonalizedOffice))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, office_per_params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficePerController.create(conn, office_per_params)

      "profesional" in current_user_roles ->
        TurnosWeb.Professional.OfficePerController.create(conn, office_per_params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show do
    get("/api/users/{user_id}/offices_per/{id}")
    summary("Retrieve a personalized office")
    description("Retrieve a personalized office")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
      id(:path, :integer, "The id of the personalized office", required: true)
    end

    response(200, "Ok", Schema.ref(:PersonalizedOffice))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficePerController.show(conn, params)

      "profesional" in current_user_roles ->
        TurnosWeb.Professional.OfficePerController.show(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update do
    patch("/api/users/{user_id}/offices_per/{id} ")
    summary("Update the personalized office ")
    description("Update the personalized office")

    parameters do
      personalizedOffice(:body, Schema.ref(:PersonalizedOffice), "Personalized office to record",
        required: true
      )

      user_id(:path, :integer, "The id of the user", required: true)
      id(:path, :integer, "The id of the personalized office", required: true)
    end

    response(201, "Ok", Schema.ref(:PersonalizedOffice))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficePerController.update(conn, params)

      "profesional" in current_user_roles ->
        TurnosWeb.Professional.OfficePerController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/{user_id}/offices_per/{id}")
    summary("Delete a personalized office")
    description("Remove a personalized office from the system")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
      id(:path, :integer, "The id of the personalized office", required: true)
    end

    response(204, "No content")
    response(404, "Not found")
  end

  def delete(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficePerController.delete(conn, params)

      "profesional" in current_user_roles ->
        TurnosWeb.Professional.OfficePerController.delete(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end
end
