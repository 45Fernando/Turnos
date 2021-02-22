defmodule TurnosWeb.OfficeController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Office:
        swagger_schema do
          title("Office")
          description("An office")

          properties do
            id(:integer, "The ID of the office")
            address(:string, "The address of the office", required: true)
            lat(:string, "The lat of the office", required: true)
            long(:string, "The long of the office", required: true)
            name(:string, "The name of the office", required: true)
            phone(:string, "The phone of the office", required: true)
            status(:boolean, "The status of the office")
            appointments(:array, "Has many appointments")
            config_details(:array, "Has many config details")

            inserted_at(:string, "When was the office initially inserted", format: "ISO-8601")

            updated_at(:string, "When was the office last updated", format: "ISO-8601")
          end

          example(%{
            id: 1,
            addres: "Santa Fe 97",
            lat: "",
            long: "",
            name: "CEMID",
            phone: "11111",
            status: true,
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      Offices:
        swagger_schema do
          title("Offices ")
          description("All offices")
          type(:array)
          items(Schema.ref(:Offices))
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
    get("/api/offices")
    summary("List all offices")
    description("List all offices")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Offices))
    response(400, "Client Error")
  end

  def index(conn, _params, _current_user_roles) do
    TurnosWeb.Admin.OfficeController.index(conn, [])
  end

  swagger_path :create do
    post("/api/offices/")
    summary("Add a new office")
    description("Record a new office")

    parameters do
      office(:body, Schema.ref(:Office), "Office to record", required: true)
    end

    response(201, "Ok", Schema.ref(:Office))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, office_params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficeController.create(conn, office_params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show do
    get("/api/offices/{id}")
    summary("Retrieve a office")
    description("Retrieve a office")

    parameters do
      id(:path, :integer, "The id of the office", required: true)
    end

    response(200, "Ok", Schema.ref(:Office))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, params, _current_user_roles) do
    TurnosWeb.Admin.OfficeController.show(conn, params)
  end

  swagger_path :update do
    patch("/api/offices/{id}")
    summary("Update the office")
    description("Update the office")

    parameters do
      office(:body, Schema.ref(:Office), "Office to record", required: true)

      id(:path, :integer, "The id of the Office", required: true)
    end

    response(201, "Ok", Schema.ref(:Office))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficeController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/offices/{id}")
    summary("Delete a office")
    description("Remove a office from the system")

    parameters do
      id(:path, :integer, "The id of the office", required: true)
    end

    response(204, "No content")
    response(404, "Not found")
  end

  def delete(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.OfficeController.delete(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end
end
