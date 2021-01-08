defmodule TurnosWeb.ConfigDetailController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Config_Detail:
        swagger_schema do
          title("Config Detail")

          description(
            "A config detail for config header of a professional, to store his appointmens config"
          )

          properties do
            id(:integer, "The ID of the config detail")

            start_time(:time_usec, "A what time will start seeing patients the professional",
              required: true,
              default: 30
            )

            end_time(:time_usec, "A what time will end seeing patients the professional",
              required: true
            )

            minutes_interval(:integer, "The interval between appointmens", required: true)
            overturn(:boolean, "If the professional allow overturn appointments", required: false)

            quantity_persons_overturn(
              :integer,
              "How many patients the professional will see in overturn",
              required: false,
              default: 0
            )

            quantity_persons_per_day(
              :integer,
              "How many patients the professional will see in a day",
              required: false,
              default: 0
            )

            day_id(:integer, "Foreign key of the day", required: true)
            office_id(:integer, "Foreign key of the office", required: true)
            office_per_id(:integer, "Foreign key of the personalized office", required: true)

            inserted_at(:string, "When was the country initially inserted",
              format: "ISO-8601",
              required: false
            )

            updated_at(:string, "When was the country last updated",
              format: "ISO-8601",
              required: false
            )
          end

          example(%{
            day_id: 4,
            end_time: "20:00:00.000000",
            id: 4,
            minutes_interval: 15,
            office_id: "",
            office_per: 2,
            overturn: true,
            quantity_persons_overturn: 4,
            quantity_persons_per_day: 0,
            start_time: "15:00:00.000000"
          })
        end,
      Config_Details:
        swagger_schema do
          title("Config Details")
          description("Config details of a config header, that belong to a professional")
          type(:array)
          items(Schema.ref(:Config_Detail))
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
    get("/api/users/{user_id}/config/config_details ")
    summary("List all config details of a config header")
    description("List all config details of a config header, will show acording to permisions")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Config_Details))
    response(400, "Client Error")
  end

  def index(conn, _params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigDetailController.index(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :create do
    post("/api/users/{user_id}/config/config_details")
    summary("Create a config detail")
    description("Create a config detail, acording to permisions")

    parameters do
      config_detail(:body, Schema.ref(:Config_Detail), "Config Detail to record", required: true)
      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(201, "Ok", Schema.ref(:Config_Detail))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, config_detail_params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigDetailController.create(conn, config_detail_params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show do
    get("/api/users/{user_id}/config/config_details/{id}")
    summary("Retrieve the config detail")
    description("Retrieve the config header, acording to permisions")

    parameters do
      user_id(:path, :integer, "The id of the professional", required: true)
      id(:path, :integer, "The id of the config detail", required: true)
    end

    response(200, "Ok", Schema.ref(:Config_Header))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigDetailController.show(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update do
    patch("/api/users/{user_id}/config/config_details/{id}")
    summary("Update the config detail")
    description("Update the config detail, acording to permisions")

    parameters do
      config_detail(:body, Schema.ref(:Config_Detail), "Config detail to record", required: true)
      user_id(:path, :integer, "The id of the user", required: true)
      id(:path, :integer, "The id of the config detail", required: true)
    end

    response(201, "Ok", Schema.ref(:Config_Detail))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigDetailController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/{user_id}/config/config_details/{id}")
    summary("Delete a config detail")
    description("Remove a config detail from the system, acording to permisions")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
      id(:path, :integer, "The id of the config detail", required: true)
    end

    response(204, "No content")
    response(404, "Not found")
  end

  def delete(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigDetailController.delete(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end
end
