defmodule TurnosWeb.OfficeController do
  use TurnosWeb, :controller

  alias Turnos.Offices
  alias Turnos.Offices.Office

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    offices = Offices.list_offices()
    render(conn, "index.json", offices: offices)
  end

  def create(conn, office_params) do
    with {:ok, %Office{} = office} <- Offices.create_office(office_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.office_path(conn, :show, office))
      |> render("show.json", office: office)
    end
  end

  def show(conn, %{"id" => id}) do
    office = Offices.get_office!(id)

    conn
    |> put_view(TurnosWeb.OfficeView)
    |> render("show.json", office: office)
  end

  def update(conn, office_params) do
    id = office_params["id"]
    office = Offices.get_office!(id)
    office_params = Map.delete(office_params, "id")

    with {:ok, %Office{} = office} <- Offices.update_office(office, office_params) do
      render(conn, "show.json", office: office)
    end
  end

  def delete(conn, %{"id" => id}) do
    office = Offices.get_office!(id)

    with {:ok, %Office{}} <- Offices.delete_office(office) do
      send_resp(conn, :no_content, "")
    end
  end
end
