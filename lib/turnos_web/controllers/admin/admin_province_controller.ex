defmodule TurnosWeb.Admin.ProvinceController do
  use TurnosWeb, :controller

  alias Turnos.Provinces
  alias Turnos.Provinces.Province
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def index(conn, params) do
    provinces =
       Provinces.provinces_by_country(params["country_id"])
       |> Repo.all

    render(conn, "index.json", provinces: provinces)
  end

  def create(conn, province_params) do
    with {:ok, %Province{} = province} <- Provinces.create_province(province_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_country_province_path(conn, :show, province.country_id ,province))
      |> render("show.json", province: province)
    end
  end

  def show(conn, params) do
    province = Repo.get!(Provinces.provinces_by_country(params["country_id"]), params["id"])

    render(conn, "show.json", province: province)
  end

  def update(conn, province_params) do
    province = Repo.get!(Provinces.provinces_by_country(province_params["country_id"]), province_params["id"])
    province_params = Map.delete(province_params, "id")

    with {:ok, %Province{} = province} <- Provinces.update_province(province, province_params) do
      render(conn, "show.json", province: province)
    end
  end

  def delete(conn, params) do
    province = Repo.get!(Provinces.provinces_by_country(params["country_id"]), params["id"])

    with {:ok, %Province{}} <- Provinces.delete_province(province) do
      send_resp(conn, :no_content, "")
    end
  end
end
