defmodule TurnosWeb.Admin.OfficePerController do
  use TurnosWeb, :controller

  alias Turnos.OfficesPer
  alias Turnos.OfficesPer.OfficePer
  alias Turnos.Repo


  action_fallback TurnosWeb.FallbackController

  def index(conn, params) do
    offices_per =
      Turnos.OfficesPer.users_offices_per(params["user_id"])
      |> Repo.all

    render(conn, "index.json", offices_per: offices_per)
  end

  def create(conn, office_per_params) do
    with {:ok, %OfficePer{} = office_per} <- OfficesPer.create_office_per(office_per_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_user_office_per_path(conn, :show, office_per.user_id, office_per))
      |> render("show.json", office_per: office_per)
    end
  end

  def show(conn, params) do
    office_per = Repo.get!(Turnos.OfficesPer.users_offices_per(params["user_id"]), params["id"])

    conn
    |> put_view(TurnosWeb.Admin.OfficePerView)
    |> render("show.json", office_per: office_per)
  end

  def update(conn, params) do
    office_per = Repo.get!(Turnos.OfficesPer.users_offices_per(params["user_id"]), params["id"])
    params = Map.delete(params, "id")

    with {:ok, %OfficePer{} = office_per} <- OfficesPer.update_office_per(office_per, params) do
      render(conn, "show.json", office_per: office_per)
    end
  end

  def delete(conn, params) do
    office_per = Repo.get!(Turnos.OfficesPer.users_offices_per(params["user_id"]), params["id"])

    with {:ok, %OfficePer{}} <- OfficesPer.delete_office_per(office_per) do
      send_resp(conn, :no_content, "")
    end
  end


end
