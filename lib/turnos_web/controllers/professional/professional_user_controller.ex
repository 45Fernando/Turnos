defmodule TurnosWeb.Professional.UserController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.Users.User

  action_fallback TurnosWeb.FallbackController


  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show.json", user: user)
  end

  def show_medicalsinsurances(conn, %{"id" => id}) do
    user = Users.get_usermi!(id)

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show_mi.json", user: user)
  end

  def show_specialties(conn, %{"id" => id}) do
    user = Users.get_userspecialties!(id)

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show_specialties.json", user: user)
  end

  def update(conn, params) do
    {user, params} = get_user_params(params)

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

  def update_password(conn, params) do
    {user, params} = get_user_params(params)

    with {:ok, %User{} = user} <- Users.update_password(user, params) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show.json", user: user)
    end
  end

  def update_medicalsinsurances(conn, params) do
    {user, params} = get_usermi_params(params)

    with {:ok, %User{} = user} <- Users.update_user_mi(user, params) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show_mi.json", user: user)
    end
  end

  def update_specialties(conn, params) do
    {user, params} = get_userspecialties_params(params)

    with {:ok, %User{} = user} <- Users.update_user_specialties(user, params) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> render("show_specialties.json", user: user)
    end
  end

  def show_offices(conn, %{"user_id" => id}) do
    user = Users.get_useroffice_per!(id)

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show_offices.json", user: user)
  end


  defp get_user_params(params) do
    id = params["id"]
    user = Users.get_user!(id)
    params = Map.delete(params, "id")

    {user, params}
  end

  defp get_usermi_params(params) do
    id = params["id"]
    user = Users.get_usermi!(id)
    params = Map.delete(params, "id")

    {user, params}
  end

  def get_userspecialties_params(params) do
    id = params["id"]
    user = Users.get_userspecialties!(id)
    params = Map.delete(params, "id")

    {user, params}
  end

end
