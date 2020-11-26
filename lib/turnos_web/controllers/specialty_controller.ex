defmodule TurnosWeb.SpecialtyController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Specialty:
        swagger_schema do
          title("Specialty")
          description("A specialty")

          properties do
            id(:integer, "The ID of the specialty")
            name(:string, "The name of the specialty", required: true)
            users(:array, "Has many users")
            inserted_at(:string, "When was the specialty initially inserted", format: "ISO-8601")
            updated_at(:string, "When was the specialty last updated", format: "ISO-8601")
          end

          example(%{
            id: 1,
            name: "Dermatologia",
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      Specialties:
        swagger_schema do
          title("Specialties")
          description("All specialties")
          type(:array)
          items(Schema.ref(:Specialty))
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
    get("/api/specialties")
    summary("List all specialties")
    description("List all specialties")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Countries))
    response(400, "Client Error")
  end

  def index(conn, _params, current_user_roles) do
    cond do
      "admin" in current_user_roles -> TurnosWeb.Admin.SpecialtyController.index(conn, [])
      true -> conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :create do
    post("/api/specialties/")
    summary("Add a new specialty")
    description("Record a new specialty")

    parameters do
      country(:body, Schema.ref(:Specialty), "Specialty to record", required: true)
    end

    response(201, "Ok", Schema.ref(:Specialty))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, specialty_params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.SpecialtyController.create(conn, specialty_params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show do
    get("/api/specialties/{id}")
    summary("Retrieve a specialty")
    description("Retrieve a specialty")

    parameters do
      id(:path, :integer, "The id of the specialty", required: true)
    end

    response(200, "Ok", Schema.ref(:Specialty))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.SpecialtyController.show(conn, %{"id" => id})

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update do
    patch("/api/specialties/{id}")
    summary("Update the specialty")
    description("Update the specialty")

    parameters do
      config_detail(:body, Schema.ref(:Specialty), "Specialty to record", required: true)
      id(:path, :integer, "The id of the specialty", required: true)
    end

    response(201, "Ok", Schema.ref(:Specialty))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.SpecialtyController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/specialties/{id}")
    summary("Delete a specialty")
    description("Remove a specialty from the system")

    parameters do
      id(:path, :integer, "The id of the specialty", required: true)
    end

    response(204, "No content")
    response(404, "Not found")
  end

  def delete(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.SpecialtyController.delete(conn, %{"id" => id})

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end
end
