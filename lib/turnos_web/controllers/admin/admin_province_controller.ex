defmodule TurnosWeb.Admin.ProvinceController do
  use TurnosWeb, :controller

  alias Turnos.Provinces
  alias Turnos.Provinces.Province

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    provinces = Provinces.list_provinces()
    render(conn, "index.json", provinces: provinces)
  end

  def create(conn, province_params) do
    with {:ok, %Province{} = province} <- Provinces.create_province(province_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_province_path(conn, :show, province))
      |> render("show.json", province: province)
    end
  end

  def show(conn, %{"id" => id}) do
    province = Provinces.get_province!(id)
    render(conn, "show.json", province: province)
  end

  def update(conn, province_params) do
    province = Provinces.get_province!(province_params["id"])
    province_params = Map.delete(province_params, "id")

    with {:ok, %Province{} = province} <- Provinces.update_province(province, province_params) do
      render(conn, "show.json", province: province)
    end
  end

  def delete(conn, %{"id" => id}) do
    province = Provinces.get_province!(id)

    with {:ok, %Province{}} <- Provinces.delete_province(province) do
      send_resp(conn, :no_content, "")
    end
  end
end
