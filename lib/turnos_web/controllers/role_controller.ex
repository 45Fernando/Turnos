defmodule TurnosWeb.RoleController do
  use TurnosWeb, :controller

  alias Turnos.Roles
  alias Turnos.Roles.Role

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    roles = Roles.list_roles()
    render(conn, "index.json", roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Roles.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.role_path(conn, :show, role))
      |> render("show.json", role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Roles.get_role!(id)
    render(conn, "show.json", role: role)
  end

  def update(conn, params) do
    id = params["id"]
    role = Roles.get_role!(id)
    params = Map.delete(params, "id")

    with {:ok, %Role{} = role} <- Roles.update_role(role, params) do
      render(conn, "show.json", role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{}} <- Roles.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
