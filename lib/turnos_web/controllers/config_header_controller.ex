defmodule TurnosWeb.ConfigHeaderController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Config_Header:
        swagger_schema do
          title("Config Header")
          description("A config header for a professional to store his appointmens config")

          properties do
            id(:integer, "The ID of the config head")

            generate_every_days(:integer, "How often appointmens will be generated",
              required: true,
              default: 30
            )

            generate_up_to(:utc_datetime_usec, "Till what date will generated appointmes",
              required: false
            )

            # user_id(:integer, "Foreign Key of the user")

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
            generate_every_days: 30,
            generate_up_to: "~U[2020-10-14 20:42:07.148801Z]",
            # user_id: 2,
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
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

  swagger_path :show do
    get("/api/users/{user_id}/config/{id}")
    summary("Retrieve the config header")
    description("Retrieve the config header")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
      id(:path, :integer, "The id of the config header", required: false)
    end

    response(200, "Ok", Schema.ref(:Config_Header))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, _params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigHeaderController.show(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :create do
    post("/api/users/{user_id}/config")
    summary("Create a config header")
    description("Create a config header")

    parameters do
      config_header(:body, Schema.ref(:Config_Header), "Country to record", required: true)
      user_id(:path, :integer, "The id of the professional", required: true)
    end

    response(201, "Ok", Schema.ref(:Config_Header))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigHeaderController.create(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update do
    patch("/api/users/{user_id}/config/{id}")
    summary("Update the config header")
    description("Update the config header")

    parameters do
      config_header(:body, Schema.ref(:Config_Header), "Country to record", required: true)
      user_id(:path, :integer, "The id of the professional", required: true)
      id(:path, :integer, "The id of the config header", required: false)
    end

    response(201, "Ok", Schema.ref(:Config_Header))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, params, current_user_roles) do
    cond do
      "professional" in current_user_roles ->
        TurnosWeb.Professional.ConfigHeaderController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end
end
