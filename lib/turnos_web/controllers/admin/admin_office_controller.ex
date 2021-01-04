defmodule TurnosWeb.Admin.OfficeController do
  use TurnosWeb, :controller

  alias Turnos.Offices
  alias Turnos.Offices.Office

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    offices = Offices.list_offices()

    conn
    |> put_view(TurnosWeb.OfficeView)
    |> render("index.json", offices: offices)
  end

  def create(conn, office_params) do
    with {:ok, %Office{} = office} <- Offices.create_office(office_params) do
      conn
      |> put_view(TurnosWeb.OfficeView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.office_path(conn, :show, office))
      |> render("show.json", office: office)
    end
  end

  def show(conn, params) do
    office = Offices.get_office!(params["id"])

    conn
    |> put_view(TurnosWeb.OfficeView)
    |> render("show.json", office: office)
  end

  def update(conn, params) do
    id = params["id"]
    office = Offices.get_office!(id)
    params = Map.delete(params, "id")

    with {:ok, %Office{} = office} <- Offices.update_office(office, params) do
      conn
      |> put_view(TurnosWeb.OfficeView)
      |> render("show.json", office: office)
    end
  end

  def delete(conn, params) do
    office = Offices.get_office!(params["id"])

    with {:ok, %Office{}} <- Offices.delete_office(office) do
      send_resp(conn, :no_content, "")
    end
  end
end
