defmodule TurnosWeb.OfficeDayController do
  use TurnosWeb, :controller

  alias Turnos.Offices
  alias Turnos.OfficesDays.OfficeDay

  action_fallback TurnosWeb.FallbackController


  def create_days(conn, params) do
    with {:ok, %OfficeDay{} = officeday} <- Offices.create_offices_days(params) do
      TurnosWeb.OfficeController.show(conn, %{"id" => officeday.office_id})
    end
  end

  def update_days(conn, params) do
    officeday_id = params["id"]
    officed = Offices.get_officedayid!(officeday_id)
    params = Map.delete(params, "id")

    with {:ok, %OfficeDay{} = officeday} <- Offices.update_offices_days(officed, params) do
      TurnosWeb.OfficeController.show(conn, %{"id" => officeday.office_id})
    end
  end

  def delete_days(conn, %{"id" => id}) do
    officed = Offices.get_officedayid!(id)

    with {:ok, %OfficeDay{}} <- Offices.delete_office_day(officed) do
      send_resp(conn, :no_content, "")
    end
  end

end
