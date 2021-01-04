defmodule TurnosWeb.Admin.UserController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.Users.User
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users() |> Repo.preload([:roles, :countries, :provinces])

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("index.json", users: users)
  end

  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create_user(params) do
      conn
      |> put_view(TurnosWeb.UserView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show.json", user: user)
  end

  def show_medicalsinsurances(conn, %{"id" => id}) do
    medicals_insurances = Turnos.MedicalsInsurances.get_medicals_insurance_by_user(id)

    conn
    |> put_view(TurnosWeb.MedicalInsuranceView)
    |> render("index.json", medicals_insurances: medicals_insurances)
  end

  def show_specialties(conn, %{"id" => id}) do
    specialties = Turnos.Specialties.get_specialties_user(id)

    conn
    |> put_view(TurnosWeb.SpecialtyView)
    |> render("index.json", specialties: specialties)
  end

  def update(conn, params) do
    {user, params} = get_user_params(params)

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
      |> put_view(TurnosWeb.MedicalInsuranceView)
      |> render("index.json", medicals_insurances: user.medicalsinsurances)
    end
  end

  def update_specialties(conn, params) do
    {user, params} = get_userspecialties_params(params)

    with {:ok, %User{} = user} <- Users.update_user_specialties(user, params) do
      conn
      |> put_view(TurnosWeb.SpecialtyView)
      |> render("index.json", specialties: user.specialties)
    end
  end

  def show_roles(conn, %{"id" => id}) do
    roles = Turnos.Roles.get_roles_by_user(id)

    conn
    |> put_view(TurnosWeb.RoleView)
    |> render("index", roles: roles)
  end

  def update_roles(conn, params) do
    {user, params} = get_user_params(params)

    with {:ok, %User{} = user} <- Users.update_user_roles(user, params) do
      conn
      |> put_view(TurnosWeb.RoleView)
      |> render("show.json", roles: user.roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
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
