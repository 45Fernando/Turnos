defmodule TurnosWeb.Patient.UserController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.Users.User
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  #Muestra el perfil de un paciente
  def show(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show.json", user: user)
  end

  #Muestra el listado de profesionales
  def index_professionals(conn, _params) do
    professionals = Users.list_professionals() |> Repo.all()

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("index_professional.json", professionals: professionals)
  end

  def show_professionals(conn, params) do
    professional = Users.list_professionals() |> Repo.get!(params["id"])

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show_professional.json", professional: professional)
  end

  def update(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.delete(params, "id")

    #Chequeo si tiene o no un avatar subido, si tiene borro el archivo
    #del almacenamiento para guardar el nuevo archivo.
    if user.avatar != nil do
      :ok = TurnosWeb.Uploaders.Avatar.delete({user.avatar, user})
    end

    with {:ok, %User{} = user} <- Users.update_user(user, params) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show.json", user: user)
    end
  end

  #Buscar si existe un mail registrado o no
  def search_by_mail(conn, %{"mail" => mail}) do
    user = Users.get_user_by_mail(mail)

    message = if user != nil do
                "Not Available"
              else
                "Available"
              end

    render(conn, "mail.json", message: message)
  end

end
