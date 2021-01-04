defmodule TurnosWeb.UserController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.Users.User

  action_fallback TurnosWeb.FallbackController

  def action(conn, _) do
    current_user_roles =
      conn |> Guardian.Plug.current_resource() |> TurnosWeb.ExtractRoles.extract_roles()

    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user_roles])
  end

  def index(conn, _params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.index(conn, [])

      "patient" in current_user_roles ->
        TurnosWeb.Patient.UserController.index_professionals(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def create(conn, params, _current_user_roles) do
    TurnosWeb.Admin.UserController.create(conn, params)
  end

  def show(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show(conn, id)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.show(conn, [])

      "patient" in current_user_roles ->
        TurnosWeb.Patient.UserController.show(conn, id)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def show_medicalsinsurances(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show_medicalsinsurances(conn, id)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.show_medicalsinsurances(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def show_specialties(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show_specialties(conn, id)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.show_specialties(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def update(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.update(conn, params)

      "patient" in current_user_roles ->
        TurnosWeb.Professional.UserController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def search_by_mail(conn, %{"mail" => mail}) do
    user = Users.get_user_by_mail(mail)

    message =
      if user != nil do
        "Not Available"
      else
        "Available"
      end

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("mail.json", message: message)
  end

  def update_password(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_password(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.update_password(conn, params)

      "patient" in current_user_roles ->
        TurnosWeb.Patient.UserController.update_password(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def update_medicalsinsurances(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_medicalsinsurances(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.update_medicalsinsurances(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def update_specialties(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_specialties(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_specialties(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def show_roles(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show_roles(conn, id)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  def update_roles(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_roles(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # No esta habilitado
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
