defmodule TurnosWeb.Admin.DayController do
  use TurnosWeb, :controller

  alias Turnos.Days
  alias Turnos.Days.Day

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    days = Days.list_days()

    conn
    |> put_view(TurnosWeb.DayView)
    |> render("index.json", days: days)
  end

  # Deshabilitado
  def create(conn, %{"day" => day_params}) do
    with {:ok, %Day{} = day} <- Days.create_day(day_params) do
      conn
      |> put_view(TurnosWeb.DayView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.day_path(conn, :show, day))
      |> render("show.json", day: day)
    end
  end

  def show(conn, %{"id" => id}) do
    day = Days.get_day!(id)

    conn
    |> put_view(TurnosWeb.DayView)
    |> render("show.json", day: day)
  end

  # Deshabilitado
  def update(conn, %{"id" => id, "day" => day_params}) do
    day = Days.get_day!(id)

    with {:ok, %Day{} = day} <- Days.update_day(day, day_params) do
      conn
      |> put_view(TurnosWeb.DayView)
      |> render("show.json", day: day)
    end
  end

  # Deshabilitado
  def delete(conn, %{"id" => id}) do
    day = Days.get_day!(id)

    with {:ok, %Day{}} <- Days.delete_day(day) do
      send_resp(conn, :no_content, "")
    end
  end
end
