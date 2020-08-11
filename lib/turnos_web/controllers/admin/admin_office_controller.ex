defmodule TurnosWeb.Admin.OfficePerController do
  use TurnosWeb, :controller

  alias Turnos.OfficesPer
  alias Turnos.OfficesPer.OfficePer

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    offices_per = OfficesPer.list_offices_per()
    render(conn, "index.json", offices_per: offices_per)
  end

  def create(conn, office_per_params) do
    with {:ok, %OfficePer{} = office_per} <- OfficesPer.create_office_per(office_per_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_office_per_path(conn, :show, office_per))
      |> render("show.json", office_per: office_per)
    end
  end

  def show(conn, %{"id" => id}) do
    office_per = OfficesPer.get_office_per!(id)

    conn
    |> put_view(TurnosWeb.OfficePerView)
    |> render("show.json", office_per: office_per)
  end

  def update(conn, office_per_params) do
    id = office_per_params["id"]
    office_per = OfficesPer.get_office_per!(id)
    office_per_params = Map.delete(office_per_params, "id")

    with {:ok, %OfficePer{} = office_per} <- OfficesPer.update_office_per(office_per, office_per_params) do
      render(conn, "show.json", office_per: office_per)
    end
  end

  def delete(conn, %{"id" => id}) do
    office_per = OfficesPer.get_office_per!(id)

    with {:ok, %OfficePer{}} <- OfficesPer.delete_office_per(office_per) do
      send_resp(conn, :no_content, "")
    end
  end
end
