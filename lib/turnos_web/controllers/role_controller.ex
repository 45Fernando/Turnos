defmodule TurnosWeb.RoleController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.Roles
  alias Turnos.Roles.Role

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Role:
        swagger_schema do
          title("Role")
          description("A role")

          properties do
            id(:integer, "The ID of the role")
            roleName(:string, "The name of the role", required: true)
            users(:array, "Has many users")
            inserted_at(:string, "When was the role initially inserted", format: "ISO-8601")
            updated_at(:string, "When was the role last updated", format: "ISO-8601")
          end

          example(%{
            id: 1,
            roleName: "admin",
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      Roles:
        swagger_schema do
          title("Roles")
          description("All roles")
          type(:array)
          items(Schema.ref(:Role))
        end,
      Error:
        swagger_schema do
          title("Errors")
          description("Error responses from the API")

          properties do
            error(:string, "The message of the error raised", required: true)
          end
        end
    }
  end

  def action(conn, _) do
    current_user_roles =
      conn |> Guardian.Plug.current_resource() |> TurnosWeb.ExtractRoles.extract_roles()

    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user_roles])
  end

  swagger_path :index do
    get("/api/roles")
    summary("List all roles")
    description("List all roles")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Roles))
    response(400, "Client Error")
  end

  def index(conn, _params, current_user_roles) do
    cond do
      "admin" in current_user_roles -> TurnosWeb.Admin.RoleController.index(conn, [])
      true -> conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # Deshabilitado
  def create(conn, role_params) do
    with {:ok, %Role{} = role} <- Roles.create_role(role_params) do
      conn
      |> put_view(TurnosWeb.RoleView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.role_path(conn, :show, role))
      |> render("show.json", role: role)
    end
  end

  swagger_path :show do
    get("/api/roles/{id}")
    summary("Retrieve a role")
    description("Retrieve a role")

    parameters do
      id(:path, :integer, "The id of the role", required: true)
    end

    response(200, "Ok", Schema.ref(:Specialty))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles -> TurnosWeb.Admin.RoleController.show(conn, %{"id" => id})
      true -> conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # Deshabilitado
  def update(conn, params) do
    id = params["id"]
    role = Roles.get_role!(id)
    params = Map.delete(params, "id")

    with {:ok, %Role{} = role} <- Roles.update_role(role, params) do
      conn
      |> put_view(TurnosWeb.RoleView)
      |> render("show.json", role: role)
    end
  end

  # Deshabilitado
  def delete(conn, %{"id" => id}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{}} <- Roles.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
