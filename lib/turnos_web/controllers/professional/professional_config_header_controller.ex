defmodule TurnosWeb.Professional.ConfigHeaderController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.ConfigHeaders
  alias Turnos.ConfigHeaders.ConfigHeader

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

  swagger_path :show do
    get("api/professional/{user_id}/config")
    summary("Retrieve the config header")
    description("Retrieve the config header")

    parameters do
      user_id(:path, :integer, "The id of the professional", required: true)
    end

    response(200, "Ok", Schema.ref(:Config_Header))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    config_header = user.id |> Turnos.ConfigHeaders.get_config_by_user()

    conn
    |> put_view(TurnosWeb.ConfigHeaderView)
    |> render("show.json", config_header: config_header)
  end

  swagger_path :create do
    post("api/professional/{user_id}/config")
    summary("Create a config header")
    description("Create a config header")

    parameters do
      config_header(:body, Schema.ref(:Config_Header), "Country to record", required: true)
      user_id(:path, :integer, "The id of the professional", required: true)
    end

    response(201, "Ok", Schema.ref(:Config_Header))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params =
      Map.update!(params, "user_id", fn _data ->
        user.id
      end)

    with {:ok, %ConfigHeader{} = config_header} <- ConfigHeaders.create_config(params) do
      conn
      |> put_view(TurnosWeb.ConfigHeaderView)
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.professional_user_config_header_path(
          conn,
          :show,
          config_header.user_id,
          config_header
        )
      )
      |> render("show.json", config_header: config_header)
    end
  end

  swagger_path :update do
    patch("api/professional/{user_id}/config")
    summary("Update the config header")
    description("Update the config header")

    parameters do
      config_header(:body, Schema.ref(:Config_Header), "Country to record", required: true)
      user_id(:path, :integer, "The id of the professional", required: true)
    end

    response(201, "Ok", Schema.ref(:Config_Header))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    config_header = user.id |> Turnos.ConfigHeaders.get_config_by_user()

    params = Map.delete(params, "id")
    params = Map.delete(params, "user_id")
    params = Map.put(params, "user_id", user.id)

    with {:ok, %ConfigHeader{} = config_header} <-
           ConfigHeaders.update_config(config_header, params) do
      conn
      |> put_view(TurnosWeb.ConfigHeaderView)
      |> render("show.json", config_header: config_header)
    end
  end

  # def delete(conn, _params) do
  #  config = conn
  #            |> Guardian.Plug.current_resource()
  #            |> Turnos.ConfigHeaders.get_config_by_user()

  #  with {:ok, %ConfigHeader{}} <- ConfigHeaders.delete_config(config) do
  #    send_resp(conn, :no_content, "")
  #  end
  # end
end
