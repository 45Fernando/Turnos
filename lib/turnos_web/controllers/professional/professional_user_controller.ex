defmodule TurnosWeb.Professional.UserController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.Users.User
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("show.json", user: user)
  end

  def show_medicalsinsurances(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    medicals_insurances =
      Turnos.MedicalsInsurances.get_medicals_insurance_by_user(user.id) |> Repo.all()

    conn
    |> put_view(TurnosWeb.MedicalInsuranceView)
    |> render("index.json", medicals_insurances: medicals_insurances)
  end

  def show_specialties(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    specialties = Turnos.Specialties.get_specialties_user(user.id) |> Repo.all()

    conn
    |> put_view(TurnosWeb.SpecialtyView)
    |> render("index.json", specialties: specialties)
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

  def update_medicalsinsurances(conn, params) do
    params = Map.delete(params, "id")

    user_with_medicals_insurances =
      conn
      |> Guardian.Plug.current_resource()
      |> Users.get_usermi!()

    with {:ok, %User{} = user} <- Users.update_user_mi(user_with_medicals_insurances, params) do
      conn
      |> put_view(TurnosWeb.MedicalInsuranceView)
      |> render("index.json", medicals_insurances: user.medicalsinsurances)
    end
  end

  def update_specialties(conn, params) do
    params = Map.delete(params, "id")

    user_with_specialties =
      conn
      |> Guardian.Plug.current_resource()
      |> Users.get_userspecialties!()

    with {:ok, %User{} = user} <- Users.update_user_specialties(user_with_specialties, params) do
      conn
      |> put_view(TurnosWeb.SpecialtyView)
      |> render("index.json", specialties: user.specialties)
    end
  end
end
