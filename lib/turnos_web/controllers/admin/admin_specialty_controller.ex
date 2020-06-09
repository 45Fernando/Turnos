defmodule TurnosWeb.Admin.SpecialtyController do
  use TurnosWeb, :controller

  alias Turnos.Specialties
  alias Turnos.Specialties.Specialty

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    specialties = Specialties.list_specialties()
    render(conn, "index.json", specialties: specialties)
  end

  def create(conn, specialty_params) do
    with {:ok, %Specialty{} = specialty} <- Specialties.create_specialty(specialty_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_specialty_path(conn, :show, specialty))
      |> render("show.json", specialty: specialty)
    end
  end

  def show(conn, %{"id" => id}) do
    specialty = Specialties.get_specialty!(id)
    render(conn, "show.json", specialty: specialty)
  end

  def update(conn, params) do
    id = params["id"]
    specialty = Specialties.get_specialty!(id)
    params = Map.delete(params, "id")

    with {:ok, %Specialty{} = specialty} <- Specialties.update_specialty(specialty, params) do
      render(conn, "show.json", specialty: specialty)
    end
  end

  def delete(conn, %{"id" => id}) do
    specialty = Specialties.get_specialty!(id)

    with {:ok, %Specialty{}} <- Specialties.delete_specialty(specialty) do
      send_resp(conn, :no_content, "")
    end
  end
end