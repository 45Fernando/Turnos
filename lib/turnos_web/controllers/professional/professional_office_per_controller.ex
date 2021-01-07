defmodule TurnosWeb.Professional.OfficePerController do
  use TurnosWeb, :controller

  alias Turnos.OfficesPer
  alias Turnos.OfficesPer.OfficePer
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    offices_per_by_user =
      user.id
      |> Turnos.OfficesPer.get_offices_per_by_user()
      |> Repo.all()

    conn
    |> put_view(TurnosWeb.OfficePerView)
    |> render("index.json", offices_per: offices_per_by_user)
  end

  def create(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params =
      Map.update!(params, "id", fn _data ->
        user.id
      end)

    with {:ok, %OfficePer{} = office_per} <- OfficesPer.create_office_per(params) do
      conn
      |> put_view(TurnosWeb.OfficePerView)
      |> put_resp_header(
        "location",
        Routes.professional_user_office_per_path(conn, :show, office_per.user_id, office_per)
      )
      |> render("show.json", office_per: office_per)
    end
  end

  def show(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    office_per =
      user.id
      |> OfficesPer.get_offices_per_by_user()
      |> Repo.get!(params["id"])

    conn
    |> put_view(TurnosWeb.OfficePerView)
    |> render("show.json", office_per: office_per)
  end

  def update(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    office_per =
      user.id
      |> OfficesPer.get_offices_per_by_user()
      |> Repo.get!(params["id"])

    params = Map.delete(params, "id")

    with {:ok, %OfficePer{} = office_per} <- OfficesPer.update_office_per(office_per, params) do
      conn
      |> put_view(TurnosWeb.OfficePerView)
      |> render("show.json", office_per: office_per)
    end
  end

  def delete(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    office_per =
      user.id
      |> OfficesPer.get_offices_per_by_user()
      |> Repo.get!(params["id"])

    with {:ok, %OfficePer{}} <- OfficesPer.delete_office_per(office_per) do
      send_resp(conn, :no_content, "")
    end
  end
end
