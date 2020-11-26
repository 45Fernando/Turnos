defmodule TurnosWeb.ProvinceController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.Provinces
  alias Turnos.Provinces.Province
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Province:
        swagger_schema do
          title("Province")
          description("A province of the world")

          properties do
            id(:integer, "The ID of the province")
            code(:string, "The code of the province", required: true)
            name(:string, "The name of the province", required: true)
            country_id(:integer, "The ID of the country that belong")
            inserted_at(:string, "When was the province initially inserted", format: "ISO-8601")
            updated_at(:string, "When was the province last updated", format: "ISO-8601")
          end

          example(%{
            code: "AR-A",
            name: "Salta",
            country_id: 1,
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      Provinces:
        swagger_schema do
          title("Provinces")
          description("All provinces/states of the world")
          type(:array)
          items(Schema.ref(:Province))
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
    get("api/countries/{country_id}/provinces")
    summary("List all provinces that belong to a country")
    description("List all provinces that belong to a country")

    parameters do
      country_id(:path, :integer, "The id of the country", required: true)
    end

    produces("application/json")
    response(200, "Ok", Schema.ref(:Provinces))
    response(400, "Client Error")
  end

  def index(conn, params, current_user_roles) do
    IO.inspect(current_user_roles, label: "ROLES")

    cond do
      "admin" in current_user_roles -> TurnosWeb.Admin.ProvinceController.index(conn, params)
      true -> conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # No esta habilitado.
  def create(conn, province_params, _current_user_roles) do
    with {:ok, %Province{} = province} <- Provinces.create_province(province_params) do
      conn
      |> put_view(TurnosWeb.ProvinceView)
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.country_province_path(conn, :show, province.country_id, province)
      )
      |> render("show.json", province: province)
    end
  end

  swagger_path :show do
    get("api/countries/{country_id}/provinces/{id}")
    summary("Retrieve a country")
    description("Retrieve a country")

    parameters do
      country_id(:path, :integer, "The id of the country", required: true)
      id(:path, :integer, "The id of the province", required: true)
    end

    response(200, "Ok", Schema.ref(:Province))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.ProvinceController.show(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # Se decidido no ponerlo, porque sera cargado por seed
  def update(conn, province_params) do
    province =
      Repo.get!(
        Provinces.provinces_by_country(province_params["country_id"]),
        province_params["id"]
      )

    province_params = Map.delete(province_params, "id")

    with {:ok, %Province{} = province} <- Provinces.update_province(province, province_params) do
      conn
      |> put_view(TurnosWeb.ProvinceView)
      |> render("show.json", province: province)
    end
  end

  # Se decidido no ponerlo, porque sera cargado por seed
  def delete(conn, params) do
    province = Repo.get!(Provinces.provinces_by_country(params["country_id"]), params["id"])

    with {:ok, %Province{}} <- Provinces.delete_province(province) do
      send_resp(conn, :no_content, "")
    end
  end
end
