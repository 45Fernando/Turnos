defmodule TurnosWeb.UserOfficeController do
  use TurnosWeb, :controller

  alias Turnos.Users
  alias Turnos.UsersOffices.UserOffice

  action_fallback TurnosWeb.FallbackController


  def create_offices(conn, params) do
    with {:ok, %UserOffice{} = useroffice} <- Users.create_user_offices(params) do
      TurnosWeb.Admin.UserController.show_offices(conn, %{"user_id" => useroffice.user_id})
    end
  end

  def update_offices(conn, params) do
    useroff_id = params["id"]
    useroff = Users.get_userofid!(useroff_id)
    params = Map.delete(params, "id")

    with {:ok, %UserOffice{} = useroffice} <- Users.update_user_offices(useroff, params) do
      TurnosWeb.Admin.UserController.show_offices(conn, %{"user_id" => useroffice.user_id})
    end
  end

  def delete_office(conn, %{"id" => id}) do
    useroffice = Users.get_userofid!(id)

    with {:ok, %UserOffice{}} <- Users.delete_user_office(useroffice) do
      send_resp(conn, :no_content, "")
    end
  end

end
