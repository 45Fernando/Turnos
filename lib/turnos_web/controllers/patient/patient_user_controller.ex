defmodule TurnosWeb.Patient.UserController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.Users.User
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  # Muestra el perfil de un paciente
  def show(conn, %{"id" => id} = map) do
    user = conn |> Guardian.Plug.current_resource()

    if user.id == id do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show.json", user: user)
    else
      show_professionals(conn, map)
    end
  end

  # Muestra el listado de profesionales
  def index_professionals(conn, _params) do
    professionals = Users.list_professionals() |> Repo.all()

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("index_professional.json", professionals: professionals)
  end

  defp show_professionals(conn, params) do
    professional = Users.get_user!(params["id"])

    if Enum.any?(professional.roles, fn x -> x.roleName == "profesional" end) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show_professional.json", professional: professional)
    else
      conn
      |> put_status(404)
      |> Phoenix.Controller.render(TurnosWeb.ErrorView, :"404")
      |> halt()
    end
  end

  def update(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.delete(params, "id")

    # Chequeo si tiene o no un avatar subido, si tiene borro el archivo
    # del almacenamiento para guardar el nuevo archivo.
    if user.avatar != nil do
      :ok = TurnosWeb.Uploaders.Avatar.delete({user.avatar, user})
    end

    with {:ok, %User{} = user} <- Users.update_user(user, params) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show.json", user: user)
    end
  end

  def update_password(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.delete(params, "id")

    with {:ok, %User{} = user} <- Users.update_password(user, params) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show.json", user: user)
    end
  end
end
