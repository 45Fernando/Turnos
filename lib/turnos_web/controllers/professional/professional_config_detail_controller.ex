defmodule TurnosWeb.Professional.ConfigDetailController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.ConfigDetails
  alias Turnos.ConfigDetails.ConfigDetail
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    config_details = user.id |> ConfigDetails.get_config_details_by_user() |> Repo.all()

    conn
    |> put_view(TurnosWeb.ConfigDetailView)
    |> render("index.json", config_details: config_details)
  end

  def create(conn, config_detail_params) do
    user = conn |> Guardian.Plug.current_resource()

    config_header = user.id |> Turnos.ConfigHeaders.get_config_by_user()

    config_detail_params =
      config_detail_params
      |> Map.delete("user_id")
      |> Map.put("config_header_id", config_header.id)

    with {:ok, %ConfigDetail{} = config_detail} <-
           ConfigDetails.create_config_detail(config_detail_params) do
      conn
      |> put_view(TurnosWeb.ConfigDetailView)
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.user_config_detail_path(conn, :show, user.id, config_detail)
      )
      |> render("show.json", config_detail: config_detail)
    end
  end

  def show(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    config_detail =
      user.id |> ConfigDetails.get_config_details_by_user() |> Repo.get!(params["id"])

    conn
    |> put_view(TurnosWeb.ConfigDetailView)
    |> render("show.json", config_detail: config_detail)
  end

  def update(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params = Map.delete(params, "user_id")

    config_detail =
      user.id |> ConfigDetails.get_config_details_by_user() |> Repo.get!(params["id"])

    with {:ok, %ConfigDetail{} = config_detail} <-
           ConfigDetails.update_config_detail(config_detail, params) do
      conn
      |> put_view(TurnosWeb.ConfigDetailView)
      |> render("show.json", config_detail: config_detail)
    end
  end

  def delete(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params = Map.delete(params, "user_id")

    config_detail =
      user.id |> ConfigDetails.get_config_details_by_user() |> Repo.get!(params["id"])

    with {:ok, %ConfigDetail{}} <- ConfigDetails.delete_config_detail(config_detail) do
      send_resp(conn, :no_content, "")
    end
  end
end
