defmodule TurnosWeb.DayController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.Days
  alias Turnos.Days.Day

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Day:
        swagger_schema do
          title("Day")
          description("A day")

          properties do
            id(:integer, "The ID of the day")
            name(:string, "The name of the day", required: true)
            config_details(:array, "Has many users")
            inserted_at(:string, "When was the day initially inserted", format: "ISO-8601")
            updated_at(:string, "When was the day last updated", format: "ISO-8601")
          end

          example(%{
            id: 1,
            name: "Lunes",
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      Days:
        swagger_schema do
          title("Days")
          description("All days")
          type(:array)
          items(Schema.ref(:Day))
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
    get("/api/days")
    summary("List all days")
    description("List all days")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Days))
    response(400, "Client Error")
  end

  def index(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles -> TurnosWeb.Admin.DayController.index(conn, params)
      true -> conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # Deshabilitado
  def create(conn, %{"day" => day_params}) do
    with {:ok, %Day{} = day} <- Days.create_day(day_params) do
      conn
      |> put_view(TurnosWeb.DayView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.day_path(conn, :show, day))
      |> render("show.json", day: day)
    end
  end

  swagger_path :show do
    get("/api/days/{id}")
    summary("Retrieve a day")
    description("Retrieve a day")

    parameters do
      id(:path, :integer, "The id of the day", required: true)
    end

    response(200, "Ok", Schema.ref(:Specialty))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles -> TurnosWeb.Admin.DayController.show(conn, %{"id" => id})
      true -> conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # Deshabilitado
  def update(conn, %{"id" => id, "day" => day_params}) do
    day = Days.get_day!(id)

    with {:ok, %Day{} = day} <- Days.update_day(day, day_params) do
      conn
      |> put_view(TurnosWeb.DayView)
      |> render("show.json", day: day)
    end
  end

  # Deshabilitado
  def delete(conn, %{"id" => id}) do
    day = Days.get_day!(id)

    with {:ok, %Day{}} <- Days.delete_day(day) do
      send_resp(conn, :no_content, "")
    end
  end
end
