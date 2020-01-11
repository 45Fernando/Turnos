defmodule TurnosWeb.UsuarioController do
  use TurnosWeb, :controller

  alias Turnos.Usuarios
  alias Turnos.Usuarios.Usuario

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    usuarios = Usuarios.list_usuarios()
    render(conn, "index.json", usuarios: usuarios)
  end

  def create(conn, params) do
    with {:ok, %Usuario{} = usuario} <- Usuarios.create_usuario(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.usuario_path(conn, :show, usuario))
      |> render("show.json", usuario: usuario)
    end
  end

  def show(conn, %{"id" => id}) do
    usuario = Usuarios.get_usuario!(id)
    render(conn, "show.json", usuario: usuario)
  end

  def update(conn, params) do
    id = params["id"]
    usuario = Usuarios.get_usuario!(id)

    params = Map.delete(params, "id")

    with {:ok, %Usuario{} = usuario} <- Usuarios.update_usuario(usuario, params) do
      render(conn, "show.json", usuario: usuario)
    end
  end

  def delete(conn, %{"id" => id}) do
    usuario = Usuarios.get_usuario!(id)

    with {:ok, %Usuario{}} <- Usuarios.delete_usuario(usuario) do
      send_resp(conn, :no_content, "")
    end
  end
end
