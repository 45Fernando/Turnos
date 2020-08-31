defmodule TurnosWeb.Paciente.UserController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.Users.User

  action_fallback TurnosWeb.FallbackController

  def show(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show.json", user: user)
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
