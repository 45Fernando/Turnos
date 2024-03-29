defmodule TurnosWeb.AppointmentControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.Appointments
  alias Turnos.Appointments.Appointment

  @create_attrs %{
    appointment_date: ~D[2010-04-17],
    availability: true,
    time_end: ~T[14:00:00],
    time_start: ~T[14:00:00]
  }
  @update_attrs %{
    appointment_date: ~D[2011-05-18],
    availability: false,
    time_end: ~T[15:01:01],
    time_start: ~T[15:01:01]
  }
  @invalid_attrs %{appointment_date: nil, availability: nil, time_end: nil, time_start: nil}

  def fixture(:appointment) do
    {:ok, appointment} = Appointments.create_appointment(@create_attrs)
    appointment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all appointments", %{conn: conn} do
      conn = get(conn, Routes.appointment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create appointment" do
    test "renders appointment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.appointment_path(conn, :create), appointment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.appointment_path(conn, :show, id))

      assert %{
               "id" => id,
               "appointment_date" => "2010-04-17",
               "availability" => true,
               "time_end" => "14:00:00",
               "time_start" => "14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.appointment_path(conn, :create), appointment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update appointment" do
    setup [:create_appointment]

    test "renders appointment when data is valid", %{conn: conn, appointment: %Appointment{id: id} = appointment} do
      conn = put(conn, Routes.appointment_path(conn, :update, appointment), appointment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.appointment_path(conn, :show, id))

      assert %{
               "id" => id,
               "appointment_date" => "2011-05-18",
               "availability" => false,
               "time_end" => "15:01:01",
               "time_start" => "15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, appointment: appointment} do
      conn = put(conn, Routes.appointment_path(conn, :update, appointment), appointment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete appointment" do
    setup [:create_appointment]

    test "deletes chosen appointment", %{conn: conn, appointment: appointment} do
      conn = delete(conn, Routes.appointment_path(conn, :delete, appointment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.appointment_path(conn, :show, appointment))
      end
    end
  end

  defp create_appointment(_) do
    appointment = fixture(:appointment)
    {:ok, appointment: appointment}
  end
end
